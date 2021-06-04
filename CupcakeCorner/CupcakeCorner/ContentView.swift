//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Tim Musil on 01.06.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        Picker("Select your cake type", selection: $order.type) {
                            ForEach(0..<Order.types.count) {
                                Text(Order.types[$0])
                            }
                        }
                        
                        Stepper(value: $order.quantity, in: 3...20) {
                            Text("Number of cakes: \(order.quantity)")
                        }
                    }
                    Section {
                        Toggle(isOn: $order.specialRequestEnabled.animation(), label: {
                            Text("Any special requests?")
                        })
                        if order.specialRequestEnabled {
                            Toggle(isOn: $order.extraFrosting, label: {
                                Text("Add extra frosting?")
                            })
                            
                            Toggle(isOn: $order.addSprinkles, label: {
                                Text("Add extra sprinkles?")
                            })
                        }
                    }
                    Section {
                        NavigationLink(destination: AddressView(order: order)) {
                            Text("Delivery details")
                        }
                    }
                }
                .navigationBarTitle("CupcakeCorner")
                
                VStack {
                    Spacer()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
