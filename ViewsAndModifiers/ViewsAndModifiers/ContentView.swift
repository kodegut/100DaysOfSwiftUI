//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Tim Musil on 25.04.21.
//

import SwiftUI

struct BlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func blueTitleStyle() -> some View {
        self.modifier(BlueTitle())
    }
}

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading ,spacing: 20) {
            Spacer()
            Text("This is my Title")
                .modifier(BlueTitle())
            Text("This is my Title with view extension")
                .blueTitleStyle()
            Text("Yes, they are the same.")
            Spacer()
            
            HStack {
                Spacer()
                Text("@kodegut")
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
