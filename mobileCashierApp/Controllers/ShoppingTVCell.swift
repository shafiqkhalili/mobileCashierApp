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
    
    weak var shoppingViewDelegate : TableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func discountButton(_ sender: UIButton) {
        print("btn discount clicked")
        if let d =  shoppingViewDelegate {
            d.goToNextScene(cell: self)
        } else {
            print("delegete is nil")
        }
    }
}
