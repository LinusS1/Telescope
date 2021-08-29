//
//  STLabel.swift
//  STLabel
//
//  Created by Linus Skucas on 8/22/21.
//

import SwiftUI

struct STLabel<Content> : View where Content : View {
    var systemImage: String
    var content: Content
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: systemImage)
            content
        }
    }
}

struct STLabel_Previews: PreviewProvider {
    static var previews: some View {
        STLabel(systemImage: "hourglass", content: Text("hi"))
    }
}
