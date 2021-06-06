//
//  Order.swift
//  CupcakeCorner
//
//  Created by Tim Musil on 04.06.21.
//

import Foundation

// the wrapper is only used due to the challenge of day 52
class OrderWrapper: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case order
    }
    
   @Published var order: Order = Order()
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        order = try container.decode(Order.self, forKey: .order)
    }
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(order, forKey: .order)
       
    }
}
struct Order: Codable {
    
    
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    //returns true as long as some digit or letter is contained in each string
    var hasValidAddress: Bool {
        let pattern = "[a-zA-Z0-9]"
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        if name.range(of: pattern, options: .regularExpression) == nil || streetAddress.range(of: pattern, options: .regularExpression) == nil || city.range(of: pattern, options: .regularExpression) == nil || zip.range(of: pattern, options: .regularExpression) == nil{
            return false
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type)/2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity)/2
        }
        
        return cost
    }
    
    
    
   
    
    
}
