//
//  DetailView.swift
//  ActivityTracker
//
//  Created by Tim Musil on 30.05.21.
//

import SwiftUI

struct DetailView: View {
    let activity: Activity
    var body: some View {
        VStack() {
            Image(systemName: activity.image)
                .resizable()
                .scaledToFit()
                .frame(height: 150 , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Text(activity.name)
                .font(.largeTitle)
                .padding(.vertical, 30)
            
            Text(activity.description)
                .padding()
            Text("Count: \(activity.count)")
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(activity: Activity(name: "Test", description: "Test", image: "airplane"))
    }
}
