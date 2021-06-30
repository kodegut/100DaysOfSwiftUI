//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tim Musil on 23.04.21.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black,lineWidth: 1))
            .shadow(color: .secondary, radius: 2)
        
    }
    
    init(_ name: String){
        self.name = name
    }
}

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var animating = false
    @State private var falseFlagTapped = false
    @State private var tappedAnswer: Int?
    @State var animationAmount: Double = 0
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack (spacing: 30) {
                Spacer()
                VStack {
                    Text("Tap the flag of:")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        tappedAnswer = number
                        self.flagTapped(number)
                        withAnimation(.interpolatingSpring(stiffness: 20, damping: 300)) {
                            self.animationAmount += 360
                        }
                        
                        withAnimation(.easeIn(duration: 2)) {
                            animating = true
                        }
                        
                    }) {
                        
                        FlagImage(self.countries[number])
                            .rotation3DEffect(.degrees(number == tappedAnswer && number == correctAnswer ? animationAmount : 0), axis: (x:0 , y: 1, z: 0))
                            
                            .opacity((animating && number != correctAnswer && (number != tappedAnswer)) ? 0.25 : 1)
                            .overlay(Color.red.opacity(animating && number != correctAnswer && number == tappedAnswer ? 0.7 : 0))
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                        
                        
                        
                        
                        
                    }
                    
                }
                Spacer()
                Text("Current Score: \(score)")
                HStack {
                    Spacer()
                    Text("@kodegut")
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                }
            }.foregroundColor(.white)
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! \n Thats the flag of \(countries[number])."
        }
        showingScore = true
        animating = true
    }
    
    func askQuestion() {
        animating = false
        tappedAnswer = nil
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
