//
//  ReceiptViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-30.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class ReceiptViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TableCellDelegate {
        
    var ref: DatabaseReference!
    
    let shoppingCellID = "shoppingCell"
    let productDiscountSegue = "discountSegue"
    
    var prodKey : String?
    var prodName : String?
    var prodImage : UIImage?
    var prodPrice : String?
    
    @IBOutlet weak var receiptTableView: UITableView!
    
    // MARK: Products array
    var items: [ProductItem] = []
    var itemKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tabBarItem.badgeValue = "0"
        let basketRef = ref.child("product-basket")
        let itemRef = ref.child("product-items")
        let itemKeyRef = itemRef.child("prodKey")
        
        let refItem = ref.child("product-items")
        
        // Do any additional setup after loading the view.
        basketRef.observe(.value, with: { snapshot in
            // 2
            var newItems: [ProductItem] = []
            
            // 3
            for child in snapshot.children {
                // 4
                if let snapshot = child as? DataSnapshot,
                    let productItem = ProductItem(snapshot: snapshot) {
                    newItems.append(productItem)
                }
            }
            
            self.items = newItems
            self.receiptTableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ShoppingTVCell", bundle: nil)
        receiptTableView.register(nib, forCellReuseIdentifier: shoppingCellID)
        receiptTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCellID,for: indexPath) as! ShoppingTVCell
        cell.shoppingViewDelegate = self
        cell.itemName.text = items[indexPath.row].name
        cell.itemPrice.text = items[indexPath.row].price
        
        let photoUrl = items[indexPath.row].image
        
        getImage(url: photoUrl) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    cell.itemImage.image = photo
                }
                
            }
        }
        cell.imageView?.image = UIImage(named: items[indexPath.row].image)
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 2.0
        return cell
    }
    
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
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let item = items[indexPath.row]
        //        prodKey = item.prodKey
        print("From didSelectRowAtIndexPath")
        self.performSegue(withIdentifier: productDiscountSegue, sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == productDiscountSegue {
            guard  let destinationVC = segue.destination as? DiscountViewController else {return}
            destinationVC.prodName = prodName
            destinationVC.prodPrice = prodPrice
        }
    }
    
    func goToNextScene(cell: UITableViewCell) {
        performSegue(withIdentifier: productDiscountSegue, sender: self)
    }
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
        }.resume()
    }
}

