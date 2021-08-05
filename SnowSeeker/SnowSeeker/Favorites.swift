//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Tim Musil on 03.08.21.
//

import SwiftUI

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        // load our saved data
        let defaults = UserDefaults.standard
        
        if let resortsArray = defaults.stringArray(forKey: saveKey) {
            self.resorts = Set(resortsArray)
        }

        // still here? Use an empty array
        self.resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        // write out our data
        let defaults = UserDefaults.standard
        
        let resortsArray = Array(resorts)
        defaults.set(resortsArray, forKey: saveKey)
    }
}
