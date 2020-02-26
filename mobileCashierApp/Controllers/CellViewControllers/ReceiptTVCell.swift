//
//  ReceiptTVCell.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-22.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit

class ReceiptTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
