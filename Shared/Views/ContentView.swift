//
//  ContentView.swift
//  Shared
//
//  Created by Linus Skucas on 8/18/21.
//

import SwiftUI


struct ContentView: View {

    var body: some View {
        NavigationView {
            StarSidebar()
            
            Text("Select a Star")
                .font(.title)
                .foregroundColor(.gray)
        }
    }
}
