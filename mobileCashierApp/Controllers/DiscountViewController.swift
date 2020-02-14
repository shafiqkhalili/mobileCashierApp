//
//  DiscountViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-29.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class DiscountViewController: UIViewController {
    
    var prodName : String?
    var prodPrice : String?
    var prodKey : String?
    
    var discountType : UISegmentedControl?
    
    let ref = Database.database().reference()
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var discountAmount: UITextField!
    @IBAction func cancelDiscount(_ sender: UIBarButtonItem) {
        dismiss(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let prodKey = prodKey{
            ref.keepSynced(true)
            ref.child("product-basket").child(prodKey).observeSingleEvent(of: .value, with: { (snapshot) in
                
                print("Inside reference \(snapshot)")
                
                for child in snapshot.children {
                    print("child: \(child)")
                    if let snapshot = child as? ProductItem{
                        print(snapshot.name)
                    }
                }
                if snapshot.exists(){
                    if let item = snapshot.value as? ProductItem {
                        self.prodName = item.name
                        self.prodPrice = item.price
                    }
                }
                else{
                    print("Snapshot is: \(snapshot.exists() ? true : false)")
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("prodName \(prodName ?? "empty Name")")
        productName.text = prodName
        productPrice.text = prodPrice
    }
    
    @IBAction func discountType(_ sender: UISegmentedControl) {
    }
    
    @IBAction func applyDiscount(_ sender: UIButton) {
        
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
