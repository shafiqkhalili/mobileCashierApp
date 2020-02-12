//
//  BasketItems.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-04.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import Firebase

struct BasketItem {
    let ref: DatabaseReference?
    let key: String
    let prodKey: String
    //let prodCount: Int
    
    init(prodKey : String, key: String = "") {
        self.ref = nil
        self.key = key
        self.prodKey = prodKey
        //self.prodCount = prodCount + 1
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let prodKey = value["prodKey"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.prodKey = prodKey
    }
     func toAnyObject() -> Any {
         return [
           "prodKey": prodKey
         ]
       }
    
}
