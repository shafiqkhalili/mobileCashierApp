//
//  AddProductViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-27.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class AddProductViewController: UIViewController {
    func goToNextScene() {
        performSegue(withIdentifier: "addProduct", sender: self)
    }
    
    let ref = Database.database().reference(withPath: "product-items")
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let myCustomView = Bundle.main.loadNibNamed("FooterViewController", owner: self, options: nil)?[0] as! FooterViewController
        //        myCustomView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addProduct(_ sender: Any) {
        
        guard let name = productName.text,
            let price = productPrice.text else { return }
        
        let productItem = ProductItem(name: name, price: price)
        // 3
        let productItemRef = self.ref.childByAutoId()
        
        // 4
        productItemRef.setValue(productItem.toAnyObject())
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
