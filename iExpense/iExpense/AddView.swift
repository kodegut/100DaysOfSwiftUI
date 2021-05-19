//
//  addView.swift
//  iExpense
//
//  Created by Tim Musil on 18.05.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save"){
                addItem()
            })
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
            })
        }
    }
    
    func addItem () {
        if let actualAmount = Int(self.amount) {
            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
            self.expenses.items.append(item)
            self.presentationMode.wrappedValue.dismiss()
        } else {
            alertTitle = "Wrong format"
            alertMessage = "\(self.amount) cannot be turned into a valid number please enter a correct amount"
            showingAlert = true
        }
    }
}

struct addView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
