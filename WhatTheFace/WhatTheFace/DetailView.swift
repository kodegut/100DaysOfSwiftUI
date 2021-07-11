//
//  DetailView.swift
//  WhatTheFace
//
//  Created by Tim Musil on 11.07.21.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct DetailView: View {
    var person: Person
    
    @State private var location: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    
    var metAt: [AnnotatedItem] {
        
        return [AnnotatedItem(name: "You met \(person.firstName) at this place", coordinate: .init(latitude: person.latitude, longitude: person.longitude))]
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $location, annotationItems: metAt) { item in
                MapMarker(coordinate: item.coordinate, tint: .red)
            }.onAppear(perform: {
                location.center = CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude)
            })
            .edgesIgnoringSafeArea(.top)
            .frame(height: 400)
            
            VStack(spacing: 20) {
                Image(uiImage: (PersonStore.loadImage(imageId: person.imageId) ?? UIImage(systemName: "person"))!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 400, height: 400)
                
                HStack {
                    Text(person.firstName)
                    Text(person.lastName)
                }
                .font(.largeTitle)
            }.offset(y: -180)
            
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(person: Person(id: UUID(), firstName: "Tim", lastName: "Tester", imageId: UUID(),latitude: 48, longitude: 12 ))
    }
}
