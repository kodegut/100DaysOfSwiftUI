//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Tim Musil on 04.06.21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var orderWrapper: OrderWrapper
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        GeometryReader { gr in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: gr.size.width)
                        .accessibility(hidden: true)
                    Text("Your total is €\(orderWrapper.order.cost, specifier: "%.2f")")
                    Button("Place the order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        })
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(orderWrapper.order)
        else {
            print("Failed to encode the order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request =  URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.alertMessage = "no data in response: \(error?.localizedDescription ?? "Unknown Error")"
                self.alertTitle = "Sorry!"
                self.showingAlert = true
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertTitle = "Thank you!"
                self.alertMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingAlert = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderWrapper: OrderWrapper())
    }
}
