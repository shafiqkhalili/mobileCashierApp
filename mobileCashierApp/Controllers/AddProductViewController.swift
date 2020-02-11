//
//  AddProductViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-27.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase

class AddProductViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //    func goToNextScene() {
    //        performSegue(withIdentifier: "addProduct", sender: self)
    //    }
    //
    var prodName : String?
    var prodPrice : String?
    var prodKey: String?
    
    let ref = Database.database().reference(withPath: "product-items")
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    
    @IBOutlet weak var productImage: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        if let key = prodKey{
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.key == key{
                    let value = snapshot.value as? NSDictionary
                    
                    self.prodName = value?["name"] as? String ?? ""
                    self.prodPrice = value?["price"] as? String ?? ""
                    let imageUrl = value?["image"] as? String ?? ""
                }
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        //        productName.text = prodName
        //        productPrice.text = prodPrice
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            productImage.contentMode = .scaleAspectFit
            productImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addProduct(_ sender: Any) {
        let randomID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "product-images/\(randomID).jpg")
        guard let imageData = productImage.image?.jpegData(compressionQuality: 0.75) else{return}
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        guard let name = productName.text,
            let price = productPrice.text else { return }
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("downloadURl \(downloadURL.absoluteString)")
                let productItem = ProductItem(name: name, price: price,imageURL: downloadURL.absoluteString)
                // 3
                let productItemRef = self.ref.childByAutoId()
                
                // 4
                productItemRef.setValue(productItem.toAnyObject())
            }
        }
        performSegue(withIdentifier: "fromProductAdd", sender: nil)
        /*
         storageRef.putData(imageData, metadata: uploadMetaData,completion: {
         (downloadmetaData, error) in
         if let error = error{
         print("Error on uploading imeage \(error.localizedDescription)")
         }
         if let imageURL = downloadmetaData{
         storageRef.downloadURL(completion: { (url, error) in
         if error != nil {
         print("Failed to download url:", error!)
         return
         } else {
         //Do something with url
         }
         
         })
         }
         let productItem = ProductItem(name: name, price: price,image: downloadmetaData.down)
         // 3
         let productItemRef = self.ref.childByAutoId()
         
         // 4
         productItemRef.setValue(productItem.toAnyObject())
         }
         */
        
        
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
