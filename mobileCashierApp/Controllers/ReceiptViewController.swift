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
    var prodPrice : Double?
    
    @IBOutlet weak var receiptTableView: UITableView!
    
    // MARK: Products array
    var items: [BasketItem] = []
    
    var itemKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ReceiptTVCell", bundle: nil)
        receiptTableView.register(nib, forCellReuseIdentifier: shoppingCellID)
        receiptTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell.textLabel?.text = String(persons[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: shoppingCellID,for: indexPath) as! ReceiptTVCell
        
        cell.itemLabel.text = items[indexPath.row].name
        
        let priceTotal: Double = Double(items[indexPath.row].price) * Double(items[indexPath.row].quantity)
        
        let discountTotal = Double(items[indexPath.row].discount) * Double(items[indexPath.row].quantity)
        
        let costTotal = priceTotal - discountTotal
        cell.priceLabel.text = String(costTotal)
        cell.quantityLabel.text = String(items[indexPath.row].quantity)
        
//        cell.layer.borderColor = UIColor.orange.cgColor
//        cell.layer.borderWidth = 2.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == productDiscountSegue {
//            guard  let destinationVC = segue.destination as? DiscountViewController else {return}
//            destinationVC.prodName = prodName
//            //destinationVC.prodPrice = prodPrice
//        }
    }
    
    @IBAction func backToBasket(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

