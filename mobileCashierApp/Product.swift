//
//  Product.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-24.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation

struct Product {
    var name : String
    var price : Int
    var currency : String
    
    
    init(name: String, price: Int){
        self.name = name
        self.price = price
        self.currency = "SEK"
    }
}
