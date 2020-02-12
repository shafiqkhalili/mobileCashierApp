//
//  TableCellDelegate.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-31.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation


/**
 Custom protocol for changing Segue to product edit View
 */
protocol TableCellDelegate {
    
    // make this class protocol so you can create `weak` reference
    func goToNextScene(message : String)
}
