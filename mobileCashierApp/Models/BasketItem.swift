//
//  BasketItems.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-04.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import Firebase

class BasketItem : Codable  {
    var key: String
    var name: String
    var price: String
    var image: String
    var quantity : Int
    
    enum CodingKeys: CodingKey {
        case key
        case name
        case price
        case image
        case quantity
    }
    
    init(name: String, price: String, imageURL: String, key: String, quantity: Int){
        self.key = key
        self.name = name
        self.price = price
        self.image = imageURL
        self.quantity = quantity
        
    }

    /*
    override init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let price = value["price"] as? String,
            let imageURL = value["image"] as? String,
            let prodKey = value["prodKey"] as? String,
            let baskQuantity = value["quantity"] as? Int
            else {return nil}
        
        self.prodKey = prodKey
        self.basketQuantity = baskQuantity
        super.init(name: name, price: price, imageURL: imageURL, key: prodKey)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func toAnyObject() -> Any {
        return [
            "name": super.name,
            "price": super.price,
            "image": super.image,
            "prodKey" : self.prodKey,
            "quantity": self.basketQuantity
        ]
    }
    */
}
