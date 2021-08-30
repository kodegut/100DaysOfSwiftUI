//
//  ContentView.swift
//  Edutainment
//
//  Created by Tim Musil on 08.05.21.
//

import SwiftUI

struct Question {
    let left: Int
    let right: Int
    let answer: Int
}

struct ContentView: View {
    @State private var playing = false
    @State private var rangeStart = 1
    @State private var rangeEnd = 10
    @State private var playerAnswer = ""
    var questionAmounts = ["2","10","20","All"]
    @State private var playerQuestionAmount = 1
    @State private var questions: [Question] = []
    @State private var currentQuestion: Question = Question(left: 1, right: 1, answer: 1)
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    @State private var animateDots = false
    @State private var animateWhale = false
    @State private var showFinish = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if !playing {
                    ZStack {
                        
                        Form {
                            Section(header: Text ("Questions go from \(rangeStart) ...\(rangeEnd)")) {
                                Stepper("Starting from \(rangeStart)", value: $rangeStart, in: 1...19)
                                
                                Stepper("Ending with \(rangeEnd)", value: $rangeEnd, in: 2...20)
                            }
                            Section(header: Text ("How many questions should I ask you?")) {
                                Picker("How many questions should I ask you?", selection: $playerQuestionAmount) {
                                    ForEach(0..<questionAmounts.count) {
                                        Text("\(questionAmounts[$0])")
                                    }
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                        }
                        VStack(spacing: 50) {
                            Spacer()
                            Button(action: startGame) {
                                VStack {
                                    Image("narwhal")
                                        .padding()
                                    Text("Start Game")
                                }
                                
                            }
                            
                                HStack {
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
                        
                    }.navigationTitle("EinMalEins ")
                } else {
                    
                    Group {
                        VStack(alignment: .center, spacing: 20) {
                            Spacer()
                            Image("pig")
                            HStack {
                                Text("hmmm")
                                ForEach(0..<3) {i in
                                    Text(".")
                                        .opacity(animateDots ? 0.1 : 1)
                                        .animation(Animation.linear(duration: 1).repeatForever().delay(Double(i) * 0.4))
                                    
                                }
                                .onAppear() {
                                    animateDots = true
                                }
                            }
                            
                            Text("What is \(currentQuestion.left) x \(currentQuestion.right) ?")
                            
                            TextField("Answer", text: $playerAnswer, onCommit: {
                                answerQuestion(answer: playerAnswer)
                            })
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            
                            Button("That's my answer!") {
                                answerQuestion(answer: playerAnswer)
                            }
                            Spacer()
                            Text("\(questions.count + 1) questions to go.")
                            
                        }
                        .toolbar(content: {
                            Button("Settings") {
                                playing = false
                            }
                        })
                        
                        
                    }
                    
                    .navigationTitle("EinMalEins ")
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("OK")))
                    }
                }
                
                if showFinish {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .top)
                            .ignoresSafeArea()
                        VStack {
                            Image("whale")
                                .offset(x: animateWhale ? 0 : 200)
                                .animation(Animation.linear(duration: 2))
                            
                            Text("Finish!")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        .onAppear {
                            animateWhale = true
                        }
                    }
                    .onTapGesture {
                        showFinish = false
                    }
                }
            }
        }
    }
    
    func startGame() {
        questions = []
        if playerQuestionAmount == 3 {
            for i in rangeStart...rangeEnd {
                for j in i...rangeEnd {
                    questions.append(Question(left: i, right: j, answer: i * j))
                }
            }
        } else {
            if let amount = Int(questionAmounts[playerQuestionAmount]) {
                for _ in 0..<amount {
                    let left = Int.random(in: rangeStart...rangeEnd)
                    let right = Int.random(in: rangeStart...rangeEnd)
                    let answer = left * right
                    questions.append(Question(left: left, right: right, answer: answer))
                }
            }
        }
        questions.shuffle()
        if !questions.isEmpty {
            currentQuestion = questions.removeLast()
        }
        playing = true
    }
    
    func answerQuestion(answer: String) {
        if let answer = Int(answer) {
            if answer == currentQuestion.answer  {
                alertTitle = "Great!"
                alertText = "Your answer was correct."
            }
            else {
                alertTitle = "D'oh!"
                alertText = "The correct answer is \(currentQuestion.answer )"
                questions.append(currentQuestion)
                
            }
            showingAlert = true
            playerAnswer = ""
            if questions.count > 0 {
                questions.shuffle()
                if !questions.isEmpty {
                    currentQuestion = questions.removeLast()
                }
            } else {
                withAnimation {
                    showFinish = true
                }
                showingAlert = false
                playing = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
