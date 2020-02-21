//
//  DiscountViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-29.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class DiscountViewController: UIViewController {
    
    var prodKey : String?
    
    var prodName : String?
    var prodPrice : Double?
    var prodImageView: UIImage?
    var discountType : Int?
    
    var prodItem : BasketItem?
    
    //Firestore ref
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var ref: DocumentReference? = nil
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var discountAmount: UITextField!
    @IBOutlet weak var productImagView: UIImageView!
    
    @IBOutlet weak var currentDiscount: UILabel!
    @IBAction func cancelDiscount(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var discountChanged: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let prodKey = prodKey else{return}
        
        let docRef = db.collection("product-basket").document(prodKey)
        
        docRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: BasketItem.self)
                
            }
            switch result {
            case .success(let item):
                if let item = item {
                    self.prodItem = item
                    self.fetchData()
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding: \(error)")
            }
        }
    }
    
    func fetchData() {
        productName.text = prodItem?.name
        productPrice.text = String(prodItem?.price ?? 0)
        prodPrice = prodItem?.price
        currentDiscount.text = String(prodItem?.discount as! Double)
        
        //discountAmount.text = String(prodItem?.discount ?? 0)
        
        guard let imageURL = prodItem?.image, !imageURL.isEmpty else{ return}
        
        self.getImage(url: imageURL) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    self.productImagView.image = photo
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.fetchData()
    }
    
    @IBAction func discountType(_ sender: UISegmentedControl) {
        switch discountChanged.selectedSegmentIndex
        {
        case 0:
           discountType = 0
            break
        case 1:
            discountType = 1
            break
        default:
            break
        }
    }
    
    @IBAction func applyDiscount(_ sender: UIButton) {
        
        guard let prodKey = prodKey else{return}
        
        var discount : Double = 0.0
        let userInput = discountAmount.text
       
        if let disc = userInput {
            discount = (disc as NSString).doubleValue
        }
        
        if self.discountType == 0 {
            if let price = prodPrice{
                discount = (discount / 100) * price
            }
        }
        
        
        let basketRef = db.collection("product-basket").document(prodKey)
        
        // Set the "capital" field of the city 'DC'
        basketRef.updateData(["discount": discount]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
