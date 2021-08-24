//
//  ContentView.swift
//  WeSplit
//
//  Created by Tim Musil on 20.04.21.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totals: (total: Double, totalPerPerson: Double) {
        //calculate the total per person
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount * tipSelection / 100
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return (total: grandTotal, totalPerPerson: amountPerPerson)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    // the guide wants me to turn this into a text field but I won't do it because I think it is better the way it is.
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .textCase(nil)
                
                Section (header: Text("Total Amount:")) {
                    Text("$\(totals.total, specifier: "%.2f")")
                        .foregroundColor(tipPercentage == 4 ? .red : .primary)
                }
                .textCase(nil)
                
                Section (header: Text("Amount per Person:")) {
                    Text("$\(totals.totalPerPerson, specifier: "%.2f")")
                }
                .textCase(nil)
            }
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
            .navigationTitle("WeSplit")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
