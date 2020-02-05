//
//  ProductTVCell.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-30.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit


/**
 Custom protocol for changing Segue to product edit View
 */
protocol TableCellDelegate : class{
    
    // make this class protocol so you can create `weak` reference
    func goToNextScene()
}

class ProductTVCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    weak var prodViewDelegate : TableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func discountBtn(_ sender: UIButton) {
        print("btn discount clicked")
        if let d =  prodViewDelegate {
            d.goToNextScene()
        } else {
            print("delegete is nil")
        }
    }
}

