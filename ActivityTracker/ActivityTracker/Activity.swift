//
//  Activity.swift
//  ActivityTracker
//
//  Created by Tim Musil on 28.05.21.
//

import Foundation

class Activities: ObservableObject {
    @Published var activities = [Activity]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let activities = UserDefaults.standard.data(forKey: "Activities") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Activity].self, from: activities) {
                self.activities = decoded
                return
            }
        }
        
        self.activities = []
    }
}

struct Activity: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let description: String
    let image: String
    var count: Int = 0
    
    mutating func countUp() {
        count += 1
    }
    
    mutating func countDown() {
        count -= 1
    }
}
