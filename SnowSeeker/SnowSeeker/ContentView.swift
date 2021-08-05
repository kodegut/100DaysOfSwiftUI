//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Tim Musil on 01.08.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var favorites = Favorites()
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var isShowingFilterView = false
    
    @State private var currentSorting = "Default"
    @State private var countryFilters = [String: Bool]()
    @State private var sizeFilters = [1: true, 2: true, 3: true]
    @State private var priceFilters = [1: true, 2: true, 3: true]
    
    var filteredResorts: [Resort] {
        let filtered = resorts.filter { resort in
            
            let selectedCountries = countryFilters.filter{ $0.value }.keys
            let selectedSizes = sizeFilters.filter{ $0.value }.keys
            let selectedPrices = priceFilters.filter{ $0.value }.keys
            
            
            return selectedCountries.contains(resort.country)
                && selectedSizes.contains(resort.size)
                && selectedPrices.contains(resort.price)
        }
        return filtered
    }
    
    var filteredAndSortedResorts: [Resort] {
        let sorted: [Resort]
        
        switch currentSorting {
        case "Alphabetical":
            sorted = filteredResorts.sorted { $0.name < $1.name }
        case "Country":
            sorted = filteredResorts.sorted { $0.country < $1.country }
        default:
            sorted = filteredResorts
        }
        
        return sorted
    }
    
    
    var body: some View {
        NavigationView {
            List(filteredAndSortedResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    // it seems this modifier doesn't fix the problem (at least not anymore 03.08.2021)
                    .layoutPriority(1)
                    
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing:
                                    Button("Sort & Filter") {
                                        isShowingFilterView = true
                                    })
            .sheet(isPresented: $isShowingFilterView) {
                FilterView(currentSorting: $currentSorting, countryFilters: $countryFilters, sizeFilters: $sizeFilters, priceFilters: $priceFilters)
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
                            .accessibilityHidden(true)
                    }
                })
            
            
            WelcomeView()
        }
        .phoneOnlyStackNavigationView()
        .onAppear(perform: setCountryFilters)
        .environmentObject(favorites)
    }
    
    func setCountryFilters() {
        
        var dictionary = [String: Bool]()
        if countryFilters.isEmpty {
            for country in Array(Set(Resort.allResorts.map({$0.country}))) {
                dictionary[country] = true
            }
        }
        countryFilters = dictionary
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
