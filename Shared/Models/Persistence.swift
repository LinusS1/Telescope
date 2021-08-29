//
//  Persistence.swift
//  Shared
//
//  Created by Linus Skucas on 8/18/21.
//

import CoreData
import Combine
import SwiftUI

let appTransactionAuthorName = "Telescope"

class PersistenceController {
    static let shared = PersistenceController()
    private var subscriptions: Set<AnyCancellable> = []

    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "Telescope")
        guard let privateStoreDescription = container.persistentStoreDescriptions.first else {
            fatalError("### \(#file) \(#function) L\(#line) No Description")
        }
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("### \(#file) \(#function) L\(#line): Failed to load persistent stores: \(error.localizedDescription)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.transactionAuthor = appTransactionAuthorName
        container.viewContext.automaticallyMergesChangesFromParent = true

        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("### \(#file) \(#function) L\(#line): Failed to pin viewContext to the current generation: \(error.localizedDescription)")
        }

        NotificationCenter.default
            .publisher(for: .NSPersistentStoreRemoteChange)
            .sink { _ in
                self.processRemoteStoreChange()
            }
            .store(in: &subscriptions)
        
        if let tokenData = try? Data(contentsOf: tokenFile) {
            do {
                lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
            } catch {
                print("### \(#function): Failed to unarchive NSPersistentHistoryToken. Error = \(error)")
            }
        }
    }
    
    /**
         Track the last history token processed for a store, and write its value to file.

         The historyQueue reads the token when executing operations, and updates it after processing is complete.
         */
        private var lastHistoryToken: NSPersistentHistoryToken? {
            didSet {
                guard let token = lastHistoryToken,
                      let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else { return }

                do {
                    try data.write(to: tokenFile)
                } catch {
                    print("### \(#function): Failed to write token data. Error = \(error)")
                }
            }
        }

        /**
          The file URL for persisting the persistent history token.
         */
        private lazy var tokenFile: URL = {
            let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("Telescope", isDirectory: true)
            if !FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("### \(#function): Failed to create persistent container URL. Error = \(error)")
                }
            }
            return url.appendingPathComponent("token.data", isDirectory: false)
        }()

        /**
         An operation queue for handling history processing tasks: watching changes, deduplicating tags, and triggering UI updates if needed.
         */
        private lazy var historyQueue: OperationQueue = {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            return queue
        }()

        private func mergeChanges(from transactions: [NSPersistentHistoryTransaction]) {
            container.viewContext.perform {
                transactions.forEach { [weak self] transaction in
                    guard let self = self, let userInfo = transaction.objectIDNotification().userInfo else { return }
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [self.container.viewContext])
                }
            }
        }
}

extension PersistenceController {
    func processRemoteStoreChange() {
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }
}

extension PersistenceController {
    func processPersistentHistory() {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.performAndWait {
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest

            let result = (try? backgroundContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                  !transactions.isEmpty
            else { return }

            print("transactions = \(transactions)")
            self.mergeChanges(from: transactions)

            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last!.token
        }
    }
}
