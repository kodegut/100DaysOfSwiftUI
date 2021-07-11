//
//  faceList.swift
//  WhatTheFace
//
//  Created by Tim Musil on 10.07.21.
//

import SwiftUI

struct FaceList: View {
    
    @StateObject var personStore = PersonStore()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(personStore.persons) { person in
                    NavigationLink(destination: DetailView(person: person),
                                   label: {
                                    ListRow(person: person)
                                   })
                }
                .onDelete(perform: removeItems)
                
            }
            .sheet(isPresented: $showingAddView) {
                AddView(personStore: personStore)
            }
            .navigationTitle("What the Face")
            .navigationBarItems(leading: EditButton() ,
                trailing: Button(action: {
                showingAddView = true
            }, label: {
                Image(systemName: "plus")
            }))
        }
        
    }
    
    func removeItems(at offsets: IndexSet) {
            personStore.persons.remove(atOffsets: offsets)
        }
    
}

struct ListRow: View {
    var person: Person
    
    var body: some View {
        HStack {
            Image(uiImage: (PersonStore.loadImage(imageId: person.imageId) ?? UIImage(systemName: "person"))!)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text(person.firstName)
            Text(person.lastName)
        }
    }
}

struct FaceList_Previews: PreviewProvider {
    static var previews: some View {
        FaceList()
    }
}
