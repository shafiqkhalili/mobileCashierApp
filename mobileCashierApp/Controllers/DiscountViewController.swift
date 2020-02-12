//
//  DiscountViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-29.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit

class DiscountViewController: UIViewController {
    
    var prodName : String?
    var prodPrice : String?
    
    var discountType : UISegmentedControl?
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var discountAmount: UITextField!
    @IBAction func cancelDiscount(_ sender: UIBarButtonItem) {
        dismiss(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
