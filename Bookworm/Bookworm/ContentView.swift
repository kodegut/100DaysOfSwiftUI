//
//  ContentView.swift
//  Bookworm
//
//  Created by Tim Musil on 11.06.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(books, id: \.self) { book in
                            NavigationLink(
                                destination: DetailView(book: book),
                                label: {
                                    EmojiRatingView(rating: book.rating)
                                        .font(.largeTitle)
                                    
                                    VStack(alignment: .leading) {
                                        Text(book.title ?? "unknown Title")
                                            .font(.headline)
                                            .foregroundColor(book.rating == 1 ? .red : .primary)
                                        Text(book.author ?? "unknown Author")
                                            .foregroundColor(.secondary)
                                    }
                                })
                        }
                        .onDelete(perform: deleteBooks)
                    }
                    
                    HStack {
                        Spacer()
                        Text("@kodegut")
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                        
                    }
                }
            }
            .navigationBarTitle("Bookworm")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
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
