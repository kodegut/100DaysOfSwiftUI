//
//  FilterView.swift
//  SnowSeeker
//
//  Created by Tim Musil on 04.08.21.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let sortings = ["Default", "Alphabetical", "Country"]
    
    @Binding var currentSorting: String
    @Binding var countryFilters: [String: Bool]
    @Binding var sizeFilters: [Int: Bool]
    @Binding var priceFilters: [Int: Bool]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Sorty by:", selection: $currentSorting) {
                        ForEach(sortings, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Countries")) {
                    ForEach(countryFilters.keys.sorted(), id: \.self) { country in
                        
                        
                        Toggle(isOn: self.countryBinding(for: country)) {
                            HStack {
                            Image(country)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 20)
                                
                            Text(country)
                                .padding(.horizontal)
                            }
                                
                        }
                    }
                }
                
                Section(header: Text("Size")) {
                    ForEach(sizeFilters.keys.sorted(), id: \.self) { size in
                        Toggle(getResortSize(for: size), isOn: self.sizeBinding(for: size))
                    }
                }
                
                Section(header: Text("Price")) {
                    ForEach(priceFilters.keys.sorted(), id: \.self) { price in
                        Toggle(getResortPrice(for: price), isOn: self.priceBinding(for: price))
                    }
                }
                
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing:
                                    Button("Done") {
                                        presentationMode.wrappedValue.dismiss()
                                    })
        }
    }
    
    
    func getResortSize(for number: Int) -> String {
            switch number {
            case 1:
                return "Small"
            case 2:
                return "Average"
            default:
                return "Large"
            }
        }
    
    func getResortPrice(for number: Int) -> String {
        String(repeating: "$", count: number)
    }
    
    private func countryBinding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.countryFilters[key, default: false] },
            set: { self.countryFilters[key] = $0 })
    }
    
    private func priceBinding(for key: Int) -> Binding<Bool> {
        return .init(
            get: { self.priceFilters[key, default: false] },
            set: { self.priceFilters[key] = $0 })
    }
    
    private func sizeBinding(for key: Int) -> Binding<Bool> {
        return .init(
            get: { self.sizeFilters[key, default: false] },
            set: { self.sizeFilters[key] = $0 })
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(currentSorting: .constant("default"), countryFilters: .constant(["Austria": true]), sizeFilters: .constant([3: true]), priceFilters: .constant([2: true]))
    }
}
