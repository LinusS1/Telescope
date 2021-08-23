//
//  StarSidebarCell.swift
//  StarSidebarCell
//
//  Created by Linus Skucas on 8/20/21.
//

import SwiftUI

struct StarSidebarCell: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var star: Star
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if star.lookedAt {
                    Image(systemName: "checkmark.seal")
                        .animation(.default)
                }
                
                Text(star.name!)
                    .bold()
                    .animation(.default)
                    .transition(.move(edge: .trailing))
            }
            Text(star.wrappedDescription)
                .lineLimit(4)
                .truncationMode(.tail)
            if star.reminderTime != nil,
               Calendar.current.isDateInToday(star.reminderTime!) {
                HStack(alignment: .center) {
                    Image(systemName: "hourglass")
                    Text(star.reminderTime!, formatter: dateFormatter)
                }
                .font(.caption)
                .animation(.default)
                .transition(.move(edge: .bottom))
            }
        }
        .onDeleteCommand {
            deleteStar(star)
        }
        .contextMenu {
            Button("Delete") {
                deleteStar(star)
            }
        }
    }
    
    private func deleteStar(_ star: Star) {
        withAnimation {
            viewContext.delete(star)
            try! viewContext.save()
        }
    }
}


fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()
