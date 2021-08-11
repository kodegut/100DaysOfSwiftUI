//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Tim Musil on 01.06.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var orderWrapper = OrderWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orderWrapper.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $orderWrapper.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(orderWrapper.order.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: $orderWrapper.order.specialRequestEnabled.animation(), label: {
                        Text("Any special requests?")
                    })
                    if orderWrapper.order.specialRequestEnabled {
                        Toggle(isOn: $orderWrapper.order.extraFrosting, label: {
                            Text("Add extra frosting?")
                        })
                        
                        Toggle(isOn: $orderWrapper.order.addSprinkles, label: {
                            Text("Add extra sprinkles?")
                        })
                    }
                }
                Section {
                    NavigationLink(destination: AddressView(orderWrapper: orderWrapper)) {
                        Text("Delivery details")
                    }
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
                            .background(Color.black.opacity(0.7))
                            .clipShape(Capsule())
                            .padding()
                            .padding(.trailing, 10)
                            .accessibility(hidden: true)
                    }
                })
            .navigationBarTitle("CupcakeCorner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
