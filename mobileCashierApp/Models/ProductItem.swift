//
//  ProductItem.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-26.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import Firebase

struct ProductItem {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let price: String
    
    init(name: String, price: String, key: String = "") {
      self.ref = nil
      self.key = key
      self.name = name
      self.price = price
    }
    
    init?(snapshot: DataSnapshot) {
      guard
        let value = snapshot.value as? [String: AnyObject],
        let name = value["name"] as? String,
        let price = value["price"] as? String else {
        return nil
      }
      
      self.ref = snapshot.ref
      self.key = snapshot.key
      self.name = name
      self.price = price
    }
    
    func toAnyObject() -> Any {
      return [
        "name": name,
        "price": price
      ]
    }
}
