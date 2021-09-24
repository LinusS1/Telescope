//
//  StarCreationSheetContent.swift
//  StarCreationSheetContent
//
//  Created by Linus Skucas on 9/6/21.
//

import SwiftUI
//import Quartz


struct StarCreationSheetContent: View {
    @State var draftText = ""
    @Binding var draftUTI: String?
    @Binding var draftData: Data?
    
    var body: some View {
        if draftUTI == ContentType.text.rawValue || draftUTI == nil {
            Text("Text or URL:")
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
//                if #available(macOS 12.0, *) {
//                    Menu {
//                        Button("Choose Image...") {
//                            openImageTakerPanel()
//                        }
//                    } label: {
//                        Text("Choose File...")
//                    } primaryAction: {
//                        openOpenFilePanel()
//                    }
//                } else {
//                    // Fallback on earlier versions
//                    Menu("Choose File...") {
//                        Button("Choose File...") {
//                            openOpenFilePanel()
//                        }
//                        Button("Choose Image...") {
//                            openImageTakerPanel()
//                        }
//                    }
//                }
            }
        }
    }
    
//    func openImageTakerPanel() {
//        let pictureTaker = IKPictureTaker.pictureTaker()
////        pictureTaker?.setValue(true as NSNumber, forKey: IKPictureTakerShowEffectsKey)  // really, linus? TODO: Fix
//        pictureTaker?.runModal()
//        guard let picture = pictureTaker?.outputImage() else { return }
//    }
    
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
//                print("uti: \(draftUTI) at \(fileURL.absoluteURL)")
            }
        }
    }
}
