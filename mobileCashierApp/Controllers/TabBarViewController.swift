//
//  TabBarViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-29.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class TabBarViewController: UITabBarController {

    let ref = Database.database().reference(withPath: "product-basket")
    
    var items: [ProductItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        ref.observe(.value, with: { snapshot in
            // 2
            var newItems: [ProductItem] = []
            
            // 3
            for child in snapshot.children {
                // 4
                if let snapshot = child as? DataSnapshot,
                    let productItem = ProductItem(snapshot: snapshot) {
                    print(snapshot)
                    newItems.append(productItem)
                }
            }
            
            // 5
            self.items = newItems
        })*/
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
