//
//  ViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-23.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class ProductViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,TableCellDelegate {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var ref: DatabaseReference!
    
    // MARK: Products array
    var items: [ProductItem] = []
    
    var basketItems = [ProductItem]()
    //var user: User!
    let productCellID = "productCell"
    
    var prodDetailsSegue = "productDetailsSegue"
    
    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        //items.removeAll()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let refItem = ref.child("product-items")
        
        // Do any additional setup after loading the view.
        refItem.observe(.value, with: { snapshot in
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
            
            self.items = newItems
            self.productsTableView.reloadData()
        })
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ProductTVCell", bundle: nil)
        productsTableView.register(nib, forCellReuseIdentifier: productCellID)
        productsTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellID,for: indexPath) as! ProductTVCell
        cell.prodViewDelegate = self
        cell.itemName.text = items[indexPath.row].name
        cell.itemPrice.text = items[indexPath.row].price
        cell.imageView?.image = #imageLiteral(resourceName: "logo")
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        let item = items[indexPath.row]
        
        //        basketItems.append(item)
        //        print(item.key)
    }
    func goToNextScene() {
        print("goToNextSchen clicked")
        performSegue(withIdentifier: prodDetailsSegue, sender: self)
    }
    
    //    func addToBasket(basketItem : BasketItem) {
    //
    //        let itemRef = ref.child("product-basket")
    //        let basketRef = itemRef.childByAutoId()
    //        basketRef.setValue(basketItem.toDict())
    //    }
}
