//
//  AddBookView.swift
//  Bookworm
//
//  Created by Tim Musil on 11.06.21.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var showingFormWarning = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating, onImage: Image(systemName: "star.fill"))
                    
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        if genre == "" {
                            showingFormWarning = true
                        } else {
                            let newBook = Book(context: self.moc)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.rating = Int16(self.rating)
                            newBook.genre = self.genre
                            newBook.review = self.review
                            newBook.date = Date()
                            
                            try? self.moc.save()
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationBarTitle("Add Book")
            .alert(isPresented: $showingFormWarning, content: {
                    Alert(title: Text("Sorry"), message: Text("Please choose a genre"), dismissButton: .default(Text("OK")))})
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
