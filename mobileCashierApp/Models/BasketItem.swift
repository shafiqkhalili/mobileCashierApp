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
    var name: String?
    var price: Double?
    var image: String?
    var quantity: Int
    var discount: Double
    
    enum CodingKeys: CodingKey {
        case key
        case quantity
        case discount
    }
    
    init(key: String,name:String,price:Double,image:String,quantity: Int = 1, discount: Double = 0.0){
        self.key = key
        self.name = name
        self.price = price
        self.image = image
        self.quantity = quantity
        self.discount = discount
    }
    
    init(key: String){
        self.key = key
        self.name = ""
        self.price = 0
        self.image = ""
        self.quantity = 1
        self.discount = 0
    }

}
