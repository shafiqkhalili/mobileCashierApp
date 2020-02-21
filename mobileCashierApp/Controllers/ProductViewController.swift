//
//  ViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-23.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ProductViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,TableCellDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Realtime ref
    //var ref: DatabaseReference!
    
    //Firestore ref
    let db = Firestore.firestore()

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
        
        //Retreive all data from Firestore
        //Firestore ref
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        db.collection("product-items").addSnapshotListener(){(querySnapshot,error) in
            //guard let snapshot = snapshot else{return}
            if error != nil{
                print("First error: \(error?.localizedDescription)")
            }
            guard let documents = querySnapshot?.documents else {
                return
            }
            var newItems: [ProductItem] = []
            
            for document in documents{
                let result = Result{
                    //try document.data(as: ProductItem.init(snapshot: document))
                    try document.data(as: ProductItem.self)
                }
                switch result {
                case .success(let item):
                    if let item = item {
                        item.key = document.documentID
                        //item.ref = ref
                        print("Item ref: \(String(describing: item.key))")
                        newItems.append(item)
                    }
                case .failure(let error):
                    print("Error in switch: \(error.localizedDescription)")
                }
            }
            
            self.items = newItems
            self.productsTableView.reloadData()
        }
        //productsTableView.allowsMultipleSelectionDuringEditing = true
        
        //        Retreive all data from Real time database
        /*
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
         */
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ProductTVCell", bundle: nil)
        productsTableView.register(nib, forCellReuseIdentifier: productCellID)
        productsTableView.dataSource = self
        
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Triggered from numberOfRowsInSection")
        if isSearching == true {
            return searchedItems.count
        }
        else{
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellID,for: indexPath) as! ProductTVCell
        var currentCell : ProductItem
        cell.prodViewDelegate = self
        
        if isSearching == true {
            currentCell = searchedItems[indexPath.row]
        }
        else{
            currentCell = items[indexPath.row]
        }
        
        let photoUrl = currentCell.image
        if !photoUrl.isEmpty {
            getImage(url: photoUrl) { photo in
                if photo != nil {
                    DispatchQueue.main.async {
                        cell.itemImage.image = photo
                    }
                }
            }
        }
        cell.itemName.text = currentCell.name
        
        let prc: Double = currentCell.price
        
        cell.itemPrice.text = String(prc)
        
        cell.imageView?.image = cell.itemImage.image
        
        //cell.textLabel?.text = String(persons[indexPath.row])
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 2.0
        
        return cell
    }
    
    /*
     Adding product to basket on clicking the row
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        
        let prodItem = items[indexPath.row]
        var basketItem: BasketItem?
        
        let basketRef = self.db.collection("product-basket").document(prodItem.key)
        
        basketRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: BasketItem.self)
            }
            switch result {
            case .success(let item):
                if let item = item {
                    basketItem = item
                    basketRef.updateData([
                        "quantity": FieldValue.increment(Int64(1))
                    ])
                } else {
                    //Create productitem Type
                    basketItem = BasketItem(name: prodItem.name ,
                                            price: prodItem.price,
                                            imageURL: prodItem.image,
                                            key: prodItem.key,
                                            quantity: 1)
                    do{
                        try basketRef.setData(from: basketItem.self){err in
                            if let err = err{
                                print("Error adding document \(err)")
                            }
                        }
                    }catch{
                        print("Error on adding document")
                    }
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
            }
        }
        /*
        // Atomically increment the population of the city by 50.
        // Note that increment() with no arguments increments by 1.
        basketDoc.updateData([
            "quantity": FieldValue.increment(Int64(1))
        ])
        
         //Check if item exists in Basket Collection
        if item.key != nil {
           
            
            
            //Increment quantity
            
        }
        else{
         let basket = BasketItem(prodKey: item.key, baskQuantity: 0, item: item)
            
        //Update using Firestore database
        // Update one field, creating the document if it does not exist.
//            self.db.collection("product-basket").setValue(<#T##value: Any?##Any?#>, forUndefinedKey: <#T##String#>)([ "capital": true ], merge: true)
            
         /* update using realtime database
         let refBasket = ref.child("product-basket")
         
         refBasket.childByAutoId().setValue(basket.toAnyObject())*/
         }*/
    }
    //Delete product
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let prodItem = items[indexPath.row]
            
            let itemKey = prodItem.key
            
            let itemRef = self.db.collection("product-items").document(itemKey)
             
            let basketRef = self.db.collection("product-basket").document(itemKey)
            
            //Delete item
            itemRef.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    //If success, delete basket
                    basketRef.delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    let imageUrl = prodItem.image
                    //Delete image from storage
                    // Create a reference to the file to delete
                    if imageUrl.isEmpty{
                        return
                    }
                    let storageRef = Storage.storage().reference(forURL: imageUrl)

                    // Delete the file
                    storageRef.delete { err in
                      if let err = err {
                          print("Error removing image: \(err)")
                      } else {
                          print("Image successfully removed!")
                      }
                    }
                        
                }
            }

            productsTableView.reloadData()

        }
    }
    
    func goToNextScene(cell: UITableViewCell ) {
        guard let indexPath = productsTableView.indexPath(for: cell) else {return}
        let item = items[indexPath.row]
        
        clickedItemKey = item.key
        
        performSegue(withIdentifier: prodDetailsSegue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == prodDetailsSegue {
            let destinationVC = segue.destination as! ProductDetailsViewController
            destinationVC.prodKey = clickedItemKey
        }
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
            isSearching = true
            
            searchedItems = items.filter({ (mod) -> Bool in
                return mod.name.lowercased().contains(searchText.lowercased())
            })
        }else{
            isSearching = false
            searchedItems.removeAll()
        }
        
        self.productsTableView.reloadData()
    }
}
