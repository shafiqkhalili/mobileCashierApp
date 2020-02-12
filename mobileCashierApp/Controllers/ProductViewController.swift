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
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    
    var ref: DatabaseReference!
    
    // MARK: Products array
    var items: [ProductItem] = []
    var searchedItems: [ProductItem] = []
    
    var isSearching = false
    var clickedItemKey: String?
    
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
        
        searchBar.delegate = self
        
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
            self.searchedItems = newItems
            self.items = self.searchedItems
            self.productsTableView.reloadData()
        })
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ProductTVCell", bundle: nil)
        productsTableView.register(nib, forCellReuseIdentifier: productCellID)
        productsTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching == true {
            return searchedItems.count
        }
        else{
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellID,for: indexPath) as! ProductTVCell
        
        cell.prodViewDelegate = self
        
        var currentCell : ProductItem
        
        if isSearching {
            currentCell = searchedItems[indexPath.row]
        }
        else{
            currentCell = items[indexPath.row]
        }
        
        cell.itemName.text = currentCell.name
        cell.itemPrice.text = currentCell.price
        
        let photoUrl = currentCell.image
        
        getImage(url: photoUrl) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    cell.itemImage.image = photo
                }
                
            }
        }
        cell.imageView?.image = UIImage(named: currentCell.image)
        
        //cell.textLabel?.text = String(persons[indexPath.row])
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 2.0
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        let item = items[indexPath.row]
        clickedItemKey = item.key
        
        let refBasket = ref.child("product-basket")
        
        refBasket.childByAutoId().setValue(item.toAnyObject())
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
            
        }
    }
    
    func goToNextScene() {
        performSegue(withIdentifier: prodDetailsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == prodDetailsSegue {
        //            let destinationVC = segue.destination as! AddProductViewController
        //            destinationVC.prodKey = clickedItemKey
        //            print("prepare: \(clickedItemKey)")
        //        }
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                print("Error on fetching image !!!")
                completion(nil)
            }
        }.resume()
    }
}

extension ProductViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searchedItems = items.filter({ (mod) -> Bool in
                return mod.name.lowercased().contains(searchText.lowercased())
            })
            
            isSearching = true
        }
        
        self.productsTableView.reloadData()
    }
    func isSearchBarEmpty() {
        if searchBar.text?.isEmpty == true {
            isSearching = true
        }
        else{
            isSearching = false
        }
    }
}
