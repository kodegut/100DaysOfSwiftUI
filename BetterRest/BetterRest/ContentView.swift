//
//  ContentView.swift
//  BetterRest
//
//  Created by Tim Musil on 28.04.21.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeupTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("When do you want to wake up?")
                        DatePicker("Please enter a time",
                                   selection: $wakeUp,
                                   displayedComponents:.hourAndMinute).labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        
                        }
                        .accessibility(value: Text("\(sleepAmount, specifier: "%g") hours sleep"))
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily Coffee Intake:")
                            .font(.headline)
                        
                        Picker("Coffee Intake", selection: $coffeeAmount) {
                            ForEach(0..<20) { i in
                                if i == 1 {
                                    Text("1 cup")
                                } else {
                                    Text("\(i) cups")
                                }
                                
                            }
                        }
                        
                    }
                }
                .navigationTitle("BetterRest")
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                }
                
                VStack(spacing: 50) {
                    Spacer()
                    Text("Your optimum sleep time is \(calculatedBedtime)")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                    HStack {
                        Spacer()
                        Text("@kodegut")
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    static var defaultWakeupTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    var calculatedBedtime: String {
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        var bedtime = ""
        
        do {
            let model: SleepCalculator = try SleepCalculator(configuration: MLModelConfiguration())
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            // setting alert title and message
            bedtime = formatter.string(from: sleepTime)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true
        }
        
        return bedtime
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
