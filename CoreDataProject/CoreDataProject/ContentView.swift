//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Tim Musil on 12.06.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            FilteredList(filterKey: "lastName", filterValue: lastNameFilter, predicate: .beginsWith, sortDescriptors: []) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            Group {
                Button("Add Examples") {
                    let taylor = Singer(context: self.moc)
                    taylor.firstName = "Taylor"
                    taylor.lastName = "Swift"
                    
                    let ed = Singer(context: self.moc)
                    ed.firstName = "Ed"
                    ed.lastName = "Sheeran"
                    
                    let adele = Singer(context: self.moc)
                    adele.firstName = "Adele"
                    adele.lastName = "Adkins"
                    
                    let michael = Singer(context: self.moc)
                    michael.firstName = "Michael"
                    michael.lastName = "Jackson"
                    
                    try? self.moc.save()
                }
                
                Button("Show A") {
                    self.lastNameFilter = "A"
                }
                
                Button("Show S") {
                    self.lastNameFilter = "S"
                }
            }.padding()
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("kodegut")
                        .frame(width: 100)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Capsule())
                        .padding()
                        .padding(.trailing, 10)
                        .accessibility(hidden: true)
                }
            })
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
