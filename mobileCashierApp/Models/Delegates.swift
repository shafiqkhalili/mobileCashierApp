//
//  CellToSegue.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-08.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import UIKit

/**
 Custom protocol for changing Segue to product edit View
 */
protocol DiscountDelegate : class{
    
    // make this class protocol so you can create `weak` reference
    func goToNextScene(cell: UITableViewCell)
}

protocol  StepperDelegate: class{
    func changeBasketQuantity(cell: UITableViewCell,stepper: UIStepper)
}
