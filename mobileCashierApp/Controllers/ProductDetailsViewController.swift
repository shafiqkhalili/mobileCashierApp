//
//  AddProductViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-27.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase


class ProductDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //Initial values, used if updating product
    var prodInitName : String?
    var prodInitPrice : String?
    var prodInitImageUrl : String?
    var prodExists : Bool = false
    var prodImageIsNew : Bool = true
    
    var prodKey: String?
   
    let ref = Database.database().reference()
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if let prodKey = prodKey{
            ref.keepSynced(true)
            ref.child("product-items").child(prodKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    if let snapshot = snapshot as? DataSnapshot{
                        if let productItem = ProductItem(snapshot: snapshot){
                            //Set
                            self.prodExists = true
                            self.prodInitImageUrl = productItem.image
                            
                            //TextFields value
                            self.productName.text = productItem.name
                            self.productPrice.text = productItem.price
                            if let imageURL = self.prodInitImageUrl{
                                self.getImage(url: imageURL) { photo in
                                    if photo != nil {
                                        DispatchQueue.main.async {
                                            self.productImageView.image = photo
                                            self.prodImageIsNew = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else{
                    print("Snapshot is: \(snapshot.exists() ? true : false)")
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            productImageView.contentMode = .scaleAspectFit
            productImageView.image = pickedImage
            self.prodImageIsNew = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addProduct(_ sender: Any) {
        
        if let prodKey = prodKey {
            addItem()
        }
        else{
            editItem()
        }
        
        performSegue(withIdentifier: "fromProductAdd", sender: nil)
    }
    
    func itemExists() -> Bool{
        if let prodKey = prodKey{
            //ref.keepSynced(true)
            ref.child("product-items").child(prodKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists(){
                    if let snapshot = snapshot as? DataSnapshot{
                        if let productItem = ProductItem(snapshot: snapshot){
                            self.getImage(url: productItem.image) { photo in
                                if photo != nil {
                                    DispatchQueue.main.async {
                                        self.productImageView.image = photo
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
        return false
    }
    
    func editItem() {
        
    }
    
    func addItem() {
        let randomID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "product-images/\(randomID).jpg")
        guard let imageData = productImageView.image?.jpegData(compressionQuality: 0.75) else{return}
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        guard let name = productName.text,
            let price = productPrice.text else { return }
        
        // Upload the file to the path "images/rivers.jpg"
        _ = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                //
                let productItem = ProductItem(name: name, price: price,imageURL: downloadURL.absoluteString)
                //Add item to DB by auto ID
                let productItemRef = self.ref.childByAutoId()
                
                productItemRef.setValue(productItem.toAnyObject())
            }
        }
        
        
    }
    
    func putImage(url: String, completion: @escaping (UIImage?) -> ()) {
        
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
