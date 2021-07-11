//
//  ContentView.swift
//  WhatTheFace
//
//  Created by Tim Musil on 06.07.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var personStore: PersonStore
    
    // properties for the new person
    @State private var image: Image?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    // properties for the picker
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
  
    var body: some View {
        NavigationView {
            Group {
                if image != nil {
                    VStack(spacing: 20) {
                        
                    image?
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                        .frame(width: 400, height: 400)
                        
                        TextField("Firstname", text: $firstName)
                            .padding(.horizontal)
                        TextField("Lastname", text: $lastName)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    
                    
                } else {
                    Text("Add a new face +")
                        .padding()
                        .font(.largeTitle)
                        .onTapGesture {
                            self.showingImagePicker = true
                        }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .navigationBarItems(leading: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                addPerson()
            }, label: {
                Text("Save")
            })
            .disabled(image == nil))
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addPerson() {
    
        if let image = inputImage {
            let imageUUID = UUID()
            personStore.saveImage(image: image, imageId: imageUUID)
            
            let newPerson = Person(id: UUID(), firstName: firstName, lastName: lastName, imageId: imageUUID)
            
            personStore.persons.append(newPerson)
            personStore.persons.sort()
            
            presentationMode.wrappedValue.dismiss()
        }
        
    }
    
}



struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(personStore: PersonStore())
    }
}
