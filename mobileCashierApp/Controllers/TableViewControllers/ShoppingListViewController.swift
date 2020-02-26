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
UITableViewDelegate ,DiscountDelegate{
    
    //Firestore ref
    let db = Firestore.firestore().collection("users")
    
    var auth: Auth!
//    var ref: DatabaseReference!
    
    let shoppingCellID = "shoppingCell"
    let productDiscountSegue = "discountSegue"
    let basketToReceiptSegue = "basketToReceipt"
    
    var clickedItemKey : String?
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    // MARK: Products array
    var items: [BasketItem] = []
    var itemKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        //Retreive all data from Firestore
        //Firestore ref
        let dbRef = db.document(auth.currentUser!.uid)
        
        // Do any additional setup after loading the view.
        dbRef.collection("product-basket").addSnapshotListener(){(querySnapshot,error) in
            //guard let snapshot = snapshot else{return}
            if error != nil{
                print("First error: \(error?.localizedDescription)")
            }
            guard let documents = querySnapshot?.documents else {
                return
            }
            var newItems: [BasketItem] = []
            
            for document in documents{
                let result = Result{
                    //try document.data(as: ProductItem.init(snapshot: document))
                    try document.data(as: BasketItem.self)
                }
                switch result {
                case .success(let item):
                    if let item = item {
                        
                        newItems.append(item)
                    }
                case .failure(let error):
                    print("Error in switch: \(error.localizedDescription)")
                }
            }
            
            self.items = newItems
            self.shoppingTableView.reloadData()
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
        cell.itemName.text = items[indexPath.row].name
        cell.itemPrice.text = String(items[indexPath.row].price)
        cell.itemQuantity.text = String(items[indexPath.row].quantity)
        let photoUrl = items[indexPath.row].image
        
        getImage(url: photoUrl) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    cell.itemImage.image = photo
                }
                
            }
        }
        cell.imageView?.image = cell.itemImage.image
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 2.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let basketItem = items[indexPath.row]
            
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
        let item = items[indexPath.row]
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
    
    func goToNextScene(cell: UITableViewCell) {
        guard let indexPath = shoppingTableView.indexPath(for: cell) else {return}
        let item = items[indexPath.row]
        clickedItemKey = item.key
        
        performSegue(withIdentifier: productDiscountSegue, sender: self)
    }
}


