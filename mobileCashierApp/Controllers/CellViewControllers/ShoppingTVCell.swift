//
//  ShoppoingTableViewCell.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-08.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit

class ShoppingTVCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemStepper: UIStepper!
    
    weak var shoppingViewDelegate : DiscountDelegate?
    weak var stepperDelegate : StepperDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func discountButton(_ sender: UIButton) {
        if let d =  shoppingViewDelegate {
            d.goToNextScene(cell: self)
        } else {
            print("delegete is nil")
        }
    }
    @IBAction func stepperButton(_ sender: UIStepper) {
        if let s = stepperDelegate {
            s.changeBasketQuantity(cell: self,stepper: sender)
        } else {
            print("delegete is nil")
        }
    }
}
