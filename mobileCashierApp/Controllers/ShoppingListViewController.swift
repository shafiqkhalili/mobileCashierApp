//
//  ShoppingListViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-29.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class ShoppingListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TableCellDelegate {
    
    
    let ref = Database.database().reference(withPath: "product-items")
    
    let shoppingCellID = "shoppingCell"
    let productDiscountSegue = "discountSegue"
    let productDetailsSegue = "productDetailsSegue"
    //weak var prodViewDelegate : TableCellDelegate?
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    // MARK: Products array
    var items: [ProductItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.badgeValue = "0"
        // Do any additional setup after loading the view.
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
            self.shoppingTableView.reloadData()
        })
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ShoppingTVCell", bundle: nil)
        shoppingTableView.register(nib, forCellReuseIdentifier: shoppingCellID)
        shoppingTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCellID,for: indexPath) as! ShoppingTVCell
        cell.shoppingViewDelegate = self
        cell.itemName.text = items[indexPath.row].name
        cell.itemPrice.text = items[indexPath.row].price
        cell.imageView?.image = #imageLiteral(resourceName: "logo")
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        return cell
    }
    
   // internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "tableHeaderCell") as! ProductTVCellHeader
//        headerCell.backgroundColor = UIColor.cyan
//
//
//        return headerCell
    //}
    
  
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        let item = items[indexPath.row]
        
        print(item.key)
//         self.performSegue(withIdentifier: productDetailsSegue, sender: tableView)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print(indexPath)
        self.performSegue(withIdentifier: productDiscountSegue, sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == productDiscountSegue {
            guard  let destinationVC = segue.destination as? DiscountViewController else {return}
                    
            destinationVC.prodName = "test"
        }
    }
    
    func goToNextScene() {
          print("goToNextSchen clicked")
          performSegue(withIdentifier: productDiscountSegue, sender: self)
      }
      
}


