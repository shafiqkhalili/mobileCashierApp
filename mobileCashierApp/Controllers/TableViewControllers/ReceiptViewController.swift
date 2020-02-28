//
//  ReceiptViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-30.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class ReceiptViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,DiscountDelegate {
    
    //    var ref: DatabaseReference!
    
    let receiptCell = "receiptCell"
    let productDiscountSegue = "discountSegue"
    
    let db = Firestore.firestore().collection("users")
    
    var auth: Auth!
    
    var prodKey : String?
    var prodName : String?
    var prodImage : UIImage?
    var prodPrice : Double?
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var receiptTableView: UITableView!
    
    
    var total: Double = 0
    
    // MARK: Products array
    var items: [ProductItem] = []
    
    var totalAmount: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        //Firestore ref
        let dbRef = db.document(auth.currentUser!.uid)
        
        self.totalAmount = 0
        
       let formatter = DateFormatter()
        formatter.timeStyle = .long
       let dateString = formatter.string(from: Date())
        
        labelDate.text = dateString
        
        self.items.removeAll()
        dbRef.collection("products").whereField("quantity", isGreaterThan: 0).addSnapshotListener(){(querySnapshot,error) in
            //guard let snapshot = snapshot else{return}
            if error != nil{
                print("First error: \(error?.localizedDescription)")
            }
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            for document in documents{
                let result = Result{
                    //try document.data(as: ProductItem.init(snapshot: document))
                    try document.data(as: ProductItem.self)
                }
                switch result {
                case .success(let basket):
                    if let basket = basket {
                        self.items.append(basket)
                        
                        self.totalAmount += (Double(basket.price) - Double(basket.discount)) * Double(basket.quantity)
                        
                        self.setTotalPrice(price: self.totalAmount)
                    }
                case .failure(let error):
                    print("Error in switch: \(error.localizedDescription)")
                }
            }
        }
        
        
        let nib = UINib(nibName: "ReceiptTVCell", bundle: nil)
        receiptTableView.register(nib, forCellReuseIdentifier: receiptCell)
        receiptTableView.dataSource = self
    }
    /*
     Used to creat Label for total price as tableView Footer
     */
    func setTotalPrice(price: Double) {
        let footerView = Component(frame: .zero)
        footerView.configure(text: "Total sum ", price: String(price))
        
        receiptTableView.tableFooterView = footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: receiptCell,for: indexPath) as! ReceiptTVCell
        
        let item = items[indexPath.row]
        let quantity =  item.quantity
        
        let name = items[indexPath.row].name
        
        let price = item.price
        let priceTotal = Double(price) * Double(quantity)
        
        let discount = item.discount
        
        let discountTotal = Double(discount) * Double(quantity)
        let costTotal = priceTotal - discountTotal
        
        cell.itemLabel.text = String(name)
        cell.priceLabel.text = String(costTotal)
        cell.quantityLabel.text = String(quantity)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
  
    @IBAction func backToBasket(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func goToNextScene(cell: UITableViewCell) {
        performSegue(withIdentifier: productDiscountSegue, sender: self)
    }
    /*
     Get image from using URL
     */
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
        }.resume()
    }
    /*
     Set height of tableView Footer which we created above
     */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: receiptTableView.tableHeaderView)
        updateHeaderViewHeight(for: receiptTableView.tableFooterView)
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width - 32.0, height: 0)).height
    }
    
}

