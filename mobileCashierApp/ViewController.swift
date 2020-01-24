//
//  ViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-23.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    var products = [Product]()
    let productCellId = "ProductCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        products.append(Product(description: "Iphone11", price: 9500))
        products.append(Product(description: "AppleWatch", price: 2300))
        products.append(Product(description: "Surfplata", price: 5000))
        products.append(Product(description: "IphoneX", price: 12000))
        
        let nib = UINib(nibName: "ProductCVCell", bundle: nil)
        productCollectionView.register(nib, forCellWithReuseIdentifier: productCellId)
        productCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: productCellId,for: indexPath) as! ProductCVCell
        cell.productPrice.text = String(products[indexPath.row].price)
        cell.productDescription.text = products[indexPath.row].discription
        
        return cell
    }
}
