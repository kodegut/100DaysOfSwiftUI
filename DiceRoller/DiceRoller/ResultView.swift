//
//  ContentView.swift
//  DiceRoller
//
//  Created by Tim Musil on 31.07.21.
//

import SwiftUI
import CoreData

struct ResultView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Roll.date, ascending: false)],
        animation: .default)
    private var rolls: FetchedResults<Roll>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(rolls) { roll in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Dice Type: \(String(roll.sides)) sides")
                            Spacer()
                            Text("Result: \(roll.result)")
                                .font(.headline)
                        }
                        
                        Text("Rolled at \(roll.date!, formatter: itemFormatter)")
                            .font(.caption)
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Results")
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif
                
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { rolls[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
