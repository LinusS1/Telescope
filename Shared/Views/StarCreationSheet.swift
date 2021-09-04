//
//  StarCreationSheet.swift
//  StarCreationSheet
//
//  Created by Linus Skucas on 8/24/21.
//

import SwiftUI

struct StarCreationSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext

    // MARK: - Draft Variables

    @State var draftText = ""
    @State private var draftName = ""
    @State private var draftNotes = ""
    @State private var isShowingReminder = false
    @State private var draftReminderDate = Date().sameTimeNextDay()
    

    var body: some View {
        Form {
            Text("Text or URL:")
                .foregroundColor(.secondary)
                .font(.caption)
            TextEditor(text: $draftText) // TODO: switch between text vs. file
            HStack {
                Text("or") // TODO: include a clear button
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .font(.caption)
                if #available(macOS 12.0, *) {
                    Menu {
                        Button("Choose Image...") {
                            print("choose image...")
                        }
                    } label: {
                        Text("Choose File...")
                    } primaryAction: {
                        print("choose file")
                    }
                } else {
                    // Fallback on earlier versions
                    Menu("Choose File...") {
                        Button("Choose File...") {
                            print("choose file")
                        }
                        Button("Choose Image...") {
                            print("choose image...")
                        }
                    }
                }
            }
            Divider()
            TextField("Name", text: $draftName)
            Text("Notes:")
                .foregroundColor(.secondary)
                .font(.caption)
            TextEditor(text: $draftNotes)
            DisclosureGroup(isExpanded: $isShowingReminder) {
                DatePicker(selection: $draftReminderDate,  in: Date()..., displayedComponents: [.hourAndMinute, .date]) {
                    EmptyView()  // TODO: Remove animation and layout shift
                }
            } label: {
                Label("Reminder", systemImage: "hourglass")
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                    #if os(macOS)
                        NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                    #endif
                }
                .keyboardShortcut(.cancelAction)
                Button("Create Star") {
                    // TODO: create star
                    let draftStar = Star(context: viewContext)
                    draftStar.name = draftName
                    draftStar.notes = draftNotes
                    draftStar.creationDate = Date()
                    draftStar.contentUTI = ContentType.text.rawValue // TODO: switch based on what is inputted
                    draftStar.content = draftText.data(using: .utf8)
                    if isShowingReminder {
                        draftStar.reminderTime = draftReminderDate
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        fatalError("### \(#file) \(#function) L\(#line): Error saving star: \(error.localizedDescription)") // TODO: handle error
                    }
                    presentationMode.wrappedValue.dismiss()
                    #if os(macOS)
                        NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
                    #endif
                }
                .keyboardShortcut(.defaultAction)
                .disabled((draftText == "") || (draftName == ""))
            }
        }
        
        .padding()
        .frame(minWidth: 400, minHeight: 310)
    }
}

struct StarCreationSheet_Previews: PreviewProvider {
    static var previews: some View {
        StarCreationSheet()
    }
}
