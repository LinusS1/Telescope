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
//                    .transition(.move(edge: .trailing))
            }
            Text(star.wrappedNotes)
                .lineLimit(4)
                .truncationMode(.tail)
            if star.reminderTime != nil,
               Calendar.current.isDateInToday(star.reminderTime!) {
                STLabel(systemImage: "hourglass", content: Text(star.reminderTime!, formatter: dateFormatter))
                    .font(.caption)
//                    .animation(.default)
//                    .transition(.move(edge: .top))
            }
        }
//        .animation(.default)
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
    formatter.timeStyle = .short
    return formatter
}()
