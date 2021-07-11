//
//  AddView.swift
//  WhatTheFace
//
//  Created by Tim Musil on 06.07.21.
//

import SwiftUI
import MapKit

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var personStore: PersonStore
    
    // properties for the new person
    @State private var image: Image?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    // properties for the image picker
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    // properties for the location
    let locationFetcher = LocationFetcher()
    @State private var location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.98, longitude: 12.09), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    
    
    var body: some View {
        NavigationView {
            Group {
                if image != nil {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        image?
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .onTapGesture {
                                self.showingImagePicker = true
                            }
                            .frame(width: 400, height: 200)
                        
                        TextField("Firstname", text: $firstName)
                            .padding(.horizontal)
                        TextField("Lastname", text: $lastName)
                            .padding(.horizontal)
                        
                        Text("Where have you met?")
                            .font(.subheadline)
                            .padding(.horizontal)
                        
                        ZStack {
                            Map(coordinateRegion: $location, showsUserLocation: true, userTrackingMode: .none)
                            Circle()
                                .fill(Color.blue)
                                .opacity(0.4)
                                .frame(width: 20, height: 20)
                        }
                        .onAppear(perform: {
                            locationFetcher.start()
                            if let lastKnownLocation = locationFetcher.lastKnownLocation {
                                location = MKCoordinateRegion(center: lastKnownLocation, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
                            }
                        })
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
            
            let latitude = location.center.latitude
            let longitude = location.center.longitude
            
            let newPerson = Person(id: UUID(), firstName: firstName, lastName: lastName, imageId: imageUUID, latitude: latitude, longitude: longitude)
            
            
            
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
