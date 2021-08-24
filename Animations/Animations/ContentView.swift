//
//  ContentView.swift
//  Animations
//
//  Created by Tim Musil on 05.05.21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(50)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
            .blur(radius: (animationAmount - 1)*3)
            .animation(.interpolatingSpring(stiffness: 100, damping: 10))
            
            Spacer()
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("kodegut")
                                .frame(width: 100)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Capsule())
                                .padding()
                                .padding(.trailing, 10)
                                .accessibility(hidden: true)
                        }
                    })
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
