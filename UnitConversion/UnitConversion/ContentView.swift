//
//  ContentView.swift
//  UnitConversion
//
//  Created by Tim Musil on 22.04.21.
//

import SwiftUI

struct ContentView: View {
    
    enum einheiten: String {
        case mm = "mm"
        case cm = "cm"
        case m = "m"
        case km = "km"
        
        static let allUnits = [mm,cm,m,km]
    }
    
    @State private var userInput = ""
    @State private var inputUnit = einheiten.mm
    @State private var outputUnit = einheiten.cm
    
    var result: (Double) {
        var baseValue: Double = Double(userInput) ?? 0
        
        switch inputUnit {
        case .mm: break
        case .cm:
            baseValue *= 10
        case .m:
            baseValue *= 1000
        case .km:
            baseValue *= 1000*1000
        }
        
        switch outputUnit {
        case .mm:
            return baseValue
        case .cm:
            baseValue /= 10
        case .m:
            baseValue /= 1000
        case .km:
            baseValue /= 1000*1000
        }
        
        return baseValue
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Input")) {
                    TextField("Enter Value", text: $userInput)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Input Unit")) {
                    Picker(selection: $inputUnit, label: Text("Picker")) {
                        ForEach(einheiten.allUnits, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output Unit")) {
                    Picker(selection: $outputUnit, label: Text("Picker")) {
                        ForEach(einheiten.allUnits, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                
                Section (header: Text("Result")) {
                    Text("\(outputUnit.rawValue) \(result, specifier: "%.2f")")
                }
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
            .navigationTitle("Unit Conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
