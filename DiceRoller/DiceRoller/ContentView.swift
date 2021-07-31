//
//  ContentView.swift
//  DiceRoll
//
//  Created by Tim Musil on 31.07.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView() {
            RollView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Roll")
                }
            ResultView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Results")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
