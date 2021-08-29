//
//  StarCreationSheet.swift
//  StarCreationSheet
//
//  Created by Linus Skucas on 8/24/21.
//

import SwiftUI

enum ContentType: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case text = "public.string"
    case url = "public.url"
    case image = "public.image"
//    case file = "public.data"
}

struct StarCreationSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    @State var draftContentType: ContentType = .text
    @State var draftText: String = ""
    @State var draftName: String = ""
    @State var draftNotes: String = ""
    @State var draftReminderDate: Date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Content")) {
                TextEditor(text: $draftText)  // TODO: have two areas one for files, another for text. Once text or a file is chosen the other disappears. There will be an x button to clear the file.
                Picker("Content Type", selection: $draftContentType) {
                    Text("Text").tag(ContentType.text)
                    Text("URL").tag(ContentType.url)
                    Text("Image").tag(ContentType.image)
//                    Text("File").tag(ContentType.file)
                }
                .pickerStyle(.segmented)
            }
            Section {
                TextField("Name", text: $draftName)  // TODO: Autofill based on content, add label
                Text("Notes:")  // TODO: add support for tabbing through
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextEditor(text: $draftNotes)  // TODO: Autofill based on content
                DatePicker("Reminder", selection: $draftReminderDate, displayedComponents: [.date, .hourAndMinute]) // TODO: make optional, require date to be in future
            }
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("Cancel")
                }
                .keyboardShortcut(.cancelAction)
                
                Button {
                    let draftStar = Star(context: viewContext)
                    draftStar.name = draftName
                    draftStar.notes = draftNotes
                    draftStar.creationDate = Date()
                    draftStar.reminderTime = draftReminderDate
                    draftStar.contentUTI = draftContentType.rawValue
                    draftStar.content = draftText.data(using: .utf8)!
                    presentationMode.wrappedValue.dismiss()
                    try! viewContext.save()
                } label: {
                    Label("Create Star", systemImage: "plus")
                }
                .keyboardShortcut(.defaultAction)
                .disabled(((draftName == "") || (draftText == "")))  // TODO: Check for all content
            }
        }
        .padding()
    }
}

struct StarCreationSheet_Previews: PreviewProvider {
    static var previews: some View {
        StarCreationSheet()
    }
}
