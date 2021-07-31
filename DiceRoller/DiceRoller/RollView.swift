//
//  RollView.swift
//  DiceRoll
//
//  Created by Tim Musil on 31.07.21.
//

import SwiftUI
import CoreHaptics

struct RollView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    let sides = [4, 6, 8, 10, 12, 20, 100]
    @State private var diceType = 6
    @State private var currentResult = ""
    
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sides of your dice:")
                Picker("Number of dice sides", selection: $diceType) {
                    ForEach(sides, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
                Button(currentResult == "" ? "Roll" : currentResult) {
                    rollDice()
                }
                .font(.largeTitle)
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Dice")
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
        .onAppear() {
            currentResult = ""
        }
        
    }
    
    func rollDice() {
        prepareHaptics()
        for side in 1...diceType {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(800/diceType * side)) {
                currentResult = String(Int.random(in: 1...diceType))
                rollHaptics()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                    
                    // if we are at the final dice we play a success haptic and save the final result to core data
                    if side == diceType {
                        
                        finalRollHaptics()
                        
                        let roll = Roll(context: moc)
                        roll.date = Date()
                        roll.sides = Int16(self.diceType)
                        roll.result = Int16(self.currentResult) ?? 0
                        
                        try? moc.save()
                    }
                }
            }
        }
        
        
        
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func rollHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Pattern Failed: \(error.localizedDescription).")
        }
    }
    
    func finalRollHaptics() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView()
    }
}
