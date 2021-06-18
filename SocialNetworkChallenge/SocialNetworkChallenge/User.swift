//
//  User.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 17.06.21.
//

import Foundation


struct User: Codable, Identifiable {
    let id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}

struct Friend: Codable, Identifiable {
    let id: UUID
    let name: String
}

