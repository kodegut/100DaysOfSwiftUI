//
//  Person.swift
//  WhatTheFace
//
//  Created by Tim Musil on 10.07.21.
//

import Foundation
import MapKit

struct Person: Identifiable, Codable, Comparable {
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        if lhs.lastName == rhs.lastName {
            return lhs.firstName < rhs.firstName
        } else {
            return lhs.lastName < rhs.lastName
        }
    }
    
    
    let id: UUID
    var firstName: String
    var lastName: String
    var imageId: UUID
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    
}
