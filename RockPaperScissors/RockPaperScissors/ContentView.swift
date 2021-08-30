//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Tim Musil on 27.04.21.
//

import SwiftUI



struct ContentView: View {
    
    let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var choice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    private var correctMove: Int {
        return shouldWin ? (choice + 1) % 3 : (choice + 2) % 3
    }
    @State private var score = 0
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                Text("Current Score: \(score)")
                Text("Computer chose \(moves[choice])")
                    .bold()
                Text(shouldWin ? "You should win!" : "You should lose!")
                Text("What would you like to pick?")
                HStack {
                    ForEach(0...2, id: \.self) { index in
                        Button(moves[index]) {
                            pick(index)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                    }
                }
                .padding()
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
            }
            .navigationTitle("RockPaperScissors")
        }
    }
    
    func pick(_ playerMove: Int) {
        if playerMove == correctMove {
            score += 1
            print("Correct, Player wins a point!")
        } else {
            score -= 1
            print("Wrong, Player loses a point!")
        }
        
        // set up next game
        choice = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
