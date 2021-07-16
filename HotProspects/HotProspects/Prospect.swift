//
//  Prospect.swift
//  HotProspects
//
//  Created by Tim Musil on 16.07.21.
//

import Foundation


class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}

class Prospects: ObservableObject {
    
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
}