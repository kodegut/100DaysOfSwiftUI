//
//  ContentView.swift
//  WordScramble
//
//  Created by Tim Musil on 02.05.21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private var score: Int {
        var score = 0
        let usedWordsLengths = usedWords.map {$0.count}
        for length in usedWordsLengths {
            score += length
        }
        return score
    }
    
    var body: some View {
        GeometryReader { gr in
            NavigationView {
                VStack {
                    TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .padding()
                    
                    
                    List(usedWords, id: \.self) { word in
                        GeometryReader { listItem in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                    .foregroundColor(Color(hue: Double(listItem.frame(in: .global).maxY / gr.frame(in: .global).maxY), saturation: 1, brightness: 1))
                                Text(word)
                                
                                Text("midY: \(listItem.frame(in: .global).midY)")
                                
                            }
                            .offset(x: listItem.frame(in: .global).maxY > gr.frame(in: .global).midY ? 0.9 * (listItem.frame(in: .global).maxY - gr.frame(in: .global).midY): 0)
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(word), \(word.count) letters"))
                            
                        }
                    }
                    
                    Text("Score: \(score)")
                }
                .navigationTitle(rootWord)
                .onAppear(perform: startGame)
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
                .navigationBarItems(leading: Button("Restart", action: startGame))
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("kodegut")
                                .frame(width: 100)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Capsule())
                                .padding(.horizontal)
                        }
                    })
            }
            
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            if let startWords = try?
                String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = []
                return
            }
        }
        
        fatalError("Could not load start.txt from Bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word) && word != rootWord
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
