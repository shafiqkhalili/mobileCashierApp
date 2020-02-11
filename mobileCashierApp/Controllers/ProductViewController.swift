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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellID,for: indexPath) as! ProductTVCell
        cell.prodViewDelegate = self
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
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        let item = items[indexPath.row]
        
        let refBasket = ref.child("product-basket")
        
        refBasket.childByAutoId().setValue(item.toAnyObject())
        
    }
    func goToNextScene() {
        performSegue(withIdentifier: prodDetailsSegue, sender: self)
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
    
    //    func addToBasket(basketItem : BasketItem) {
    //
    //        let itemRef = ref.child("product-basket")
    //        let basketRef = itemRef.childByAutoId()
    //        basketRef.setValue(basketItem.toDict())
    //    }
}
