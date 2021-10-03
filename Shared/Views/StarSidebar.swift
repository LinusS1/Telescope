//
//  StarSidebar.swift
//  StarSidebar
//
//  Created by Linus Skucas on 8/20/21.
//

import CoreData
import SwiftUI

struct StarSidebar: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Star.creationDate, ascending: true)], animation: .default)
    private var stars: FetchedResults<Star>

    @State private var isShowingNewStarSheet = false

    var body: some View {
        List {
            ForEach(stars) { star in
                NavigationLink {
                    StarDetailView(star: star)
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    if star.lookedAt {
                                        markStarAsUnread(star)
                                    } else {
                                        markStarAsRead(star)
                                    }
                                } label: {
                                    Label("Mark as \(star.lookedAt ? "Unread" : "Read")", systemImage: star.lookedAt ? "xmark.seal" : "checkmark.seal")
                                }
                                .keyboardShortcut("u", modifiers: [.command, .shift])
                            }
                        }
                } label: {
                    StarSidebarCell(star: star)
                }
                .onDeleteCommand {
                    deleteStar(star)
                }
                .contextMenu {
                    Button("Delete") {
                        deleteStar(star)
                    }
                    if star.lookedAt {
                        Button("Mark as Unread") {
                            markStarAsUnread(star)
                        }
                    } else {
                        Button("Mark as Read") {
                            markStarAsRead(star)
                        }
                    }
                }
            }
            .onDelete(perform: deleteStars)
        }
        .navigationTitle(Text("Stars"))
        .frame(minWidth: 280)
        .toolbar {
            Button {
                isShowingNewStarSheet.toggle()
            } label: {
                Label("New Star", systemImage: "plus")
            }
        }
        .sheet(isPresented: $isShowingNewStarSheet) {
            StarCreationSheet()
        }
    }

    private func deleteStars(offsets: IndexSet) {
        withAnimation {
            offsets.map { stars[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteStar(_ star: Star) {
        withAnimation {
            viewContext.delete(star)
            try! viewContext.save()
        }
    }

    private func markStarAsRead(_ star: Star) {
        withAnimation {
            star.lookedAt = true
            star.dateLookedAt = Date()
            try! viewContext.save()
        }
    }

    private func markStarAsUnread(_ star: Star) {
        withAnimation {
            star.lookedAt = false
            star.dateLookedAt = nil
            try! viewContext.save()
        }
    }
}
