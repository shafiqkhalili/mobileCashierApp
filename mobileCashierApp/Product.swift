//
//  Product.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-24.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation

struct Product {
    var discription : String
    var price : Int
    var currency : String
    
    
    init(description: String, price: Int){
        self.discription = description
        self.price = price
        self.currency = "SEK"
    }
}
