//
//  DetailView.swift
//  WhatTheFace
//
//  Created by Tim Musil on 11.07.21.
//

import SwiftUI

struct DetailView: View {
    var person: Person
    var body: some View {
        VStack(spacing: 40) {
            Image(uiImage: (PersonStore.loadImage(imageId: person.imageId) ?? UIImage(systemName: "person"))!)
                .resizable()
                .scaledToFit()
            HStack {
                Text(person.firstName)
                Text(person.lastName)
            }
            .font(.largeTitle)
            Spacer()
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(person: Person(id: UUID(), firstName: "Tim", lastName: "Tester", imageId: UUID()))
    }
}
