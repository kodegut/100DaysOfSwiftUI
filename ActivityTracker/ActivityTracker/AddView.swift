//
//  AddView.swift
//  ActivityTracker
//
//  Created by Tim Musil on 30.05.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var activities: Activities
    @State private var name = ""
    @State private var description = ""
    @State private var image = "bicycle"
    
    static let images = ["bicycle", "figure.walk", "airplane", "car.fill", "gamecontroller", "bag", "tv", "laptopcomputer", "iphone", "music.note", "sportscourt"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name
                )
                TextField("Description", text: $description)
                Section(header: Text("Image")) {
                    Picker("Image", selection: $image) {
                        ForEach(Self.images, id: \.self) {
                            Image(systemName: $0)
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
            }.navigationBarTitle("Add new activity")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Save"){
                addActivity()
            })
        }
    }
    
    func addActivity() {
        let activity = Activity(name: name, description: description, image: image)
        activities.activities.append(activity)
        self.presentationMode.wrappedValue.dismiss()
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(activities: Activities())
    }
}
