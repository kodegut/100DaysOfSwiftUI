//
//  ContentView.swift
//  iExpense
//
//  Created by Tim Musil on 14.05.21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(expenses.items) {
                    item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(item.amount < 10 ? .green : item.amount < 100 ? .blue : .red)
                    }
                    
                    
                }
                .onDelete(perform: removeItems)
                
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
            .navigationTitle("iExpense")
            .navigationBarItems(
                leading: EditButton()
                ,trailing: Button(action: {
                    self.showingAddExpense = true
                }){
                    Image(systemName:"plus")
                })
            .sheet(isPresented: $showingAddExpense, content: {
                AddView(expenses: self.expenses)
            })
            
            
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
