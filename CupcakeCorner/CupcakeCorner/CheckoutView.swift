//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Tim Musil on 04.06.21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var body: some View {
        GeometryReader { gr in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: gr.size.width)
                    Text("Your total is €\(self.order.cost, specifier: "%.2f")")
                    Button("Place the order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation, content: {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("Ok")))
        })
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order)
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
                print("no data in response: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
