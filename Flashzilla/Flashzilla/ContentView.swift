//
//  ContentView.swift
//  Flashzilla
//
//  Created by Tim Musil on 21.07.21.
//
import CoreHaptics
import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var engine: CHHapticEngine?
    
    @State private var cards = [Card]()
    
    @State private var isActive = true
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    @State private var showingEditScreen = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertText = ""
    @State private var alertHasBeenShown = false
    
    @State private var repeatCards = false
    
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(decorative: "background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .opacity(0.75)
                        )
                    
                    ZStack {
                        ForEach(0..<cards.count, id: \.self) { index in
                            
                            let removal = { (correct: Bool) in
                                
                                if !repeatCards || correct {
                                    withAnimation {
                                        self.removeCard(at: index)
                                    }
                                } else {
                                    let wrongCard = self.cards.remove(at: index)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        self.cards.insert(wrongCard, at: 0)
                                    }
                                    
                                }
                            }
                            
                            CardView(card: self.cards[index], removal: removal)
                                .stacked(at: index, in: self.cards.count)
                                .allowsHitTesting(index == self.cards.count - 1)
                                .accessibility(hidden: index < self.cards.count - 1)
                        }
                    }
                    .allowsHitTesting(timeRemaining > 0)
                    
                    if cards.isEmpty {
                        Button("Start Again", action: resetCards)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
                
                VStack {
                    HStack {
                        NavigationLink(
                            destination: SettingsView(repeatCards: $repeatCards),
                            label: {
                                Image(systemName: "gear")
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                            })
                        
                        Spacer()
                        
                        Button(action: {
                            self.showingEditScreen = true
                        }) {
                            Image(systemName: "plus.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                    }
                    
                    Spacer()
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding()
                
                if differentiateWithoutColor || accessibilityEnabled {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    self.removeCard(at: cards.count - 1)
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibility(label: Text("Wrong"))
                            .accessibility(hint: Text("Mark your answer as being incorrect."))
                            
                            Spacer()
                            
                            Button(action: {
                                
                                if !repeatCards {
                                    withAnimation {
                                        self.removeCard(at: cards.count - 1)
                                    }
                                } else {
                                    let wrongCard = self.cards.remove(at: cards.count - 1)
                                    self.cards.insert(wrongCard, at: 0)
                                    
                                }
                                
                            })
                            {
                                Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            .accessibility(label: Text("Correct"))
                            .accessibility(hint: Text("Mark your answer as being correct."))
                        }
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                    }
                }
            }
            .overlay(
                VStack {
                    HStack {
                        Spacer()
                        Text("kodegut")
                            .frame(width: 100)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Capsule())
                            .padding()
                            .padding(.trailing, 100)
                            .accessibility(hidden: true)
                    }
                    Spacer()
                })
            .navigationBarHidden(true)
            .onReceive(timer) { time in
                guard self.isActive else { return }
                if self.timeRemaining > 0 {
                    if self.timeRemaining == 1 {
                        prepareHaptics()
                    }
                    
                    self.timeRemaining -= 1
                    
                } else {
                    if !alertHasBeenShown {
                        alertTitle = "Woops"
                        alertText = "You ran out of time!"
                        showingAlert = true
                        alertHasBeenShown = true
                        lostGame()
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.isActive = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                if self.cards.isEmpty == false {
                    self.isActive = true
                }
                
            }
            .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
                EditCards()
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Ok")))
            })
            .onAppear(perform: resetCards)
        }
    }
    
    
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        alertHasBeenShown = false
        loadData()
    }
    
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func lostGame() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.5)
        events.append(event)
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.6, duration: 0.5)
        events.append(event2)
        
        
        
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
        
        
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
