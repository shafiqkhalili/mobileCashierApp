//
//  ProductItem.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-26.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import Firebase

class ProductItem: Codable {
    //var ref: DatabaseReference?
    var key: String
    var name: String
    var price: Double
    var image: String
    
    enum CodingKeys: CodingKey {
        case key
        case name
        case price
        case image
    }
    
    init(name: String, price: Double, imageURL: String, key: String = "") {
        //self.ref = nil
        self.key = key
        self.name = name
        self.price = price
        self.image = imageURL
    }
    /*
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let key = value["key"] as? String,
            let name = value["name"] as? String,
            let price = value["price"] as? String,
            let image = value["image"] as? String else {return nil}
        
        self.ref = snapshot.ref
        self.key = key
        self.name = name
        self.price = price
        self.image = image
    }
    */
    //    func toAnyObject() -> Any {
    //        return [
    //            "name": name,
    //            "price": price,
    //            "image": image
    //        ]
    //    }
}
