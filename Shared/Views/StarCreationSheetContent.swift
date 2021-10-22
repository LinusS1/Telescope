//
//  StarCreationSheetContent.swift
//  StarCreationSheetContent
//
//  Created by Linus Skucas on 9/6/21.
//

import SwiftUI


struct StarCreationSheetContent: View {
    @State var draftText = ""
    @Binding var draftUTI: String?
    @Binding var draftData: Data?
    @Binding var draftName: String
    @Binding var draftNotes: String
    @State var draftFileName = ""
    
    var body: some View {
        if draftUTI == ContentType.text.rawValue || draftUTI == nil {
            Text("Text or URL:")  // TODO: Change based on input
                .foregroundColor(.secondary)
                .font(.caption)
            TextEditor(text: $draftText) // TODO: switch between text vs. file
                .onChange(of: draftText) { newValue in
                    draftData = newValue.data(using: .utf8)
                    draftUTI = ContentType.text.rawValue
                    if newValue == "" {
                        draftUTI = nil
                    }
                }
        }
        if draftUTI != ContentType.text.rawValue {
            HStack {
                if draftUTI == nil {
                    Text("or") // TODO: include a clear button
                        .textCase(.uppercase)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                Button("Choose File...") {
                    openOpenFilePanel()
                }
                if draftUTI != ContentType.text.rawValue && draftUTI != nil {
                    HStack {
                        Text(draftFileName)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Button {
                            draftUTI = nil
                            draftData = nil
                            draftName.clear()
                            draftNotes.clear()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
    }
    
    func openOpenFilePanel() {
        let panel = NSOpenPanel()
        panel.titleVisibility = .visible
        panel.title = "Pick a file for the new star"
        
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK,
               let fileURL = panel.url {
                guard let fileData = try? Data(contentsOf: fileURL),
                    let typeIdentifier = fileURL.typeIdentifier else { return }
                draftUTI = typeIdentifier.identifier
                draftData = fileData
                draftName = fileURL.deletingPathExtension().lastPathComponent
                draftFileName = fileURL.lastPathComponent
                let metadataItem = NSMetadataItem(url: fileURL)
                if let comments = metadataItem?.value(forAttribute: kMDItemFinderComment as String) as? String {
                    draftNotes = comments
                }
            }
        }
    }
}
