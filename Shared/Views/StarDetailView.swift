//
//  StarDetailView.swift
//  StarDetailView
//
//  Created by Linus Skucas on 8/22/21.
//

import SwiftUI

extension AnyTransition {
    static var slideUpAndFade: AnyTransition {
        let insertion = AnyTransition.opacity
            .combined(with: .move(edge: .top))
        let removal = AnyTransition.opacity
            .combined(with: .move(edge: .top))
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct StarDetailView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.openURL) var URLOpener
    @ObservedObject var star: Star
    @State var draftNotes = ""
    @State var isRenaming = false
    @State var draftName = ""
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        if isRenaming {
                            TextField("Name", text: $draftName)  // TODO: defocus on return
                        } else {
                            Text(star.wrappedName)
                                .font(.title2)
                                .bold()
                                .contextMenu {
                                    Button("Rename") {
                                        startDraftingName()
                                    }
                                }
                                .onTapGesture(count: 2) {
                                    startDraftingName()
                                }
                        }
//                        TextEditor(text: $draftNotes)  // TODO: Align with name
                        Text(draftNotes)
//                            .border(Color.secondary, width: 3)
                            .multilineTextAlignment(.leading)
                            .allowsTightening(true)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        STLabel(systemImage: "calendar.badge.clock", content: Text(star.wrappedCreationDate, formatter: dateFormatter))
                        STLabel(systemImage: "hourglass", content: Text(star.reminderTime ?? Date(), formatter: dateFormatter))
                            .hidden((star.reminderTime == nil))
                    }
                }
                Divider()
                if star.lookedAt {
                    VStack {
                        HStack {
                            Image(systemName: "checkmark.seal")
                            Text("Completed on \(star.dateLookedAt!, formatter: dateFormatter)")
                        }
                        Divider()
                    }
                    .foregroundColor(.secondary)
//                    .transition(.slide)  // TODO: Fix sliding dowwn
                    .animation(.default)
                }
                Group {
                    switch star.wrappedContentUTI {
                    case ContentType.text.rawValue:
                        Text(String(data: star.wrappedContent, encoding: .utf8)!)
                    case ContentType.url.rawValue:
                        Button {
                            URLOpener.callAsFunction(URL(string: String(data: star.wrappedContent, encoding: .utf8)!)!)  // do stuff with force unwrapping
                        } label: {
                            Label("Open \(star.wrappedName)", systemImage: "tray.and.arrow.up")  // Image could be arrow.up.right too
                        }
                    default:
                        Text("Unknown Content Type")

                    }
                }
                .animation(.default)
            }
            .padding()
        }
        .onAppear {
            draftNotes = star.wrappedNotes
        }
        .onChange(of: star.wrappedNotes, perform: { newValue in
            draftNotes = newValue
        })
        .onTapGesture {
            if isRenaming {
                saveName()
            }
        }
    }
    
    func startDraftingName() {
        draftName = star.wrappedName
        isRenaming.toggle()
    }
    
    func saveName() {
        isRenaming.toggle()
        // todo save
        star.name = draftName
        try! viewContext.save()
        draftName.clear()
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()
