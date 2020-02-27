//
//  ShoppingListViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-29.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ShoppingListViewController: UIViewController,UITableViewDataSource,
UITableViewDelegate ,DiscountDelegate, StepperDelegate{
    
    
    //Firestore ref
    let db = Firestore.firestore().collection("users")
    
    var auth: Auth!
    //    var ref: DatabaseReference!
    
    let shoppingCellID = "shoppingCell"
    let productDiscountSegue = "discountSegue"
    let basketToReceiptSegue = "basketToReceipt"
    
    var clickedItemKey : String?
    
    var productItem: ProductItem?
    
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    // MARK: Products array
    var items: [BasketItem] = []
    var itemKeys: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        // items = []
        //Retreive all data from Firestore
        //Firestore ref
        let dbRef = db.document(auth.currentUser!.uid)
        
        // Do any additional setup after loading the view.
        dbRef.collection("product-basket").addSnapshotListener(){(querySnapshot,error) in
            //guard let snapshot = snapshot else{return}
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.items.removeAll()
            
            for document in documents{
                let result = Result{
                    //try document.data(as: ProductItem.init(snapshot: document))
                    try document.data(as: BasketItem.self)
                }
                switch result {
                case .success(let basket):
                    if let basket = basket {
                        //Get product info
                        let prodRef = dbRef.collection("product-items").document(basket.key)
                        
                        prodRef.getDocument { (document, error) in
                            let result = Result {
                                try document?.data(as: ProductItem.self)
                            }
                            switch result {
                            case .success(let product):
                                if let prod = product {
                                    basket.name = prod.name
                                    basket.price = prod.price
                                    basket.image = prod.image
                                    
                                    self.items.append(basket)
                                    self.shoppingTableView.reloadData()
                                } else {
                                    print("Document does not exist")
                                }
                            case .failure(let error):
                                print("Error decoding: \(error)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Error in switch: \(error.localizedDescription)")
                }
            }
        }
        
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ShoppingTVCell", bundle: nil)
        shoppingTableView.register(nib, forCellReuseIdentifier: shoppingCellID)
        shoppingTableView.dataSource = self
    }
    
    
    @IBAction func createReceipt(_ sender: UIButton) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCellID,for: indexPath) as! ShoppingTVCell
        
        cell.shoppingViewDelegate = self
        cell.stepperDelegate = self
        
        if items.count > 0{
            
            cell.itemStepper.value = Double(items[indexPath.row].quantity)
            cell.itemStepper.minimumValue = 0
            
            cell.itemName.text = items[indexPath.row].name
            if let price = items[indexPath.row].price{
                cell.itemPrice.text = String(price)
            }
            cell.itemQuantity.text = String(items[indexPath.row].quantity)
            
            if let photoUrl = items[indexPath.row].image{
                
                getImage(url: photoUrl) { photo in
                    if photo != nil {
                        DispatchQueue.main.async {
                            cell.itemImage.image = photo
                        }
                        
                    }
                }
            }
            cell.imageView?.image = cell.itemImage.image
            cell.layer.borderColor = UIColor.orange.cgColor
            cell.layer.borderWidth = 2.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let basketItem = items[indexPath.row]
            items.remove(at: indexPath.row)
            let itemKey = basketItem.key
            
            let dbRef = self.db.document(auth.currentUser!.uid)
            
            let basketRef = dbRef.collection("product-basket").document(itemKey)
            
            //Delete item
            basketRef.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                }
            }
            shoppingTableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let item = items[indexPath.row]
        self.performSegue(withIdentifier: productDiscountSegue, sender: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == productDiscountSegue {
            guard  let destinationVC = segue.destination as? DiscountViewController else {return}
            destinationVC.prodKey = clickedItemKey
        }
        else if segue.identifier == basketToReceiptSegue{
            guard  let destinationVC = segue.destination as? ReceiptViewController else {return}
            destinationVC.items = items
        }
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
    
    @IBAction func emtpyBasketButton(_ sender: UIButton) {
        for basket in items {
            let dbRef = self.db.document(auth.currentUser!.uid)
            
            let basketRef = dbRef.collection("product-basket").document(basket.key)
            
            //Delete item
            basketRef.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                }
            }
        }
        shoppingTableView.reloadData()
    }
    func goToNextScene(cell: UITableViewCell) {
        guard let indexPath = shoppingTableView.indexPath(for: cell) else {return}
        let item = items[indexPath.row]
        clickedItemKey = item.key
        
        performSegue(withIdentifier: productDiscountSegue, sender: self)
    }
    
    func changeBasketQuantity(cell: UITableViewCell,stepper: UIStepper) {
        guard let indexPath = shoppingTableView.indexPath(for: cell) else {return}
        
        print("intdexPath: \( self.items[indexPath.row].name)")
        let item = items[indexPath.row]
        
        clickedItemKey = item.key
        
        let quantity = stepper.value
        if let key = clickedItemKey{
            let dbRef = db.document(auth.currentUser!.uid)
            let basketRef = dbRef.collection("product-basket").document(key)
            
            // Set the "capital" field of the city 'DC'
            basketRef.updateData(["quantity": quantity]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                self.shoppingTableView.reloadData()
            }
            if quantity > 0 {
                basketRef.delete { err in
                    if let err = err {
                        print("Error on deleting document: \(err)")
                    }
                }
                self.shoppingTableView.reloadData()
            }
        }
    }
}


