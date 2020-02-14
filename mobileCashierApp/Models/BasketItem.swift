//
//  BasketItems.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-04.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import Firebase

class BasketItem : ProductItem  {
    var prodKey: String
    var basketQuantity : Int
    
    init(prodKey : String, baskQuantity: Int,item: ProductItem){
       
        self.prodKey = prodKey
        self.basketQuantity = baskQuantity
        super.init(name: item.name, price: item.price, imageURL: item.image, key: item.key)
    }
    
    init(prodKey : String, baskQuantity: Int,name: String, price: String, imageURL: String, key: String = "") {
        self.prodKey = prodKey
        self.basketQuantity = baskQuantity
        super.init(name: name, price: price, imageURL: imageURL, key: key)
    }
    
    
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
    
    
    override func toAnyObject() -> Any {
        return [
            "name": super.name,
            "price": super.price,
            "image": super.image,
            "prodKey" : self.prodKey,
            "quantity": self.basketQuantity
        ]
    }
    
}
