//
//  AddProductViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-27.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ProductDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //Initial values, used if updating product
    var prodItem : ProductItem?
    var prodImageView: UIImage?
    
    var prodExists : Bool = false
    var prodImageIsNew : Bool = true
    
    var prodKey: String?
    
    //Real time ref
    //let ref = Database.database().reference()
    
    //Firestore ref
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var ref: DocumentReference? = nil
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        guard let prodKey = prodKey else{return}
        
        let docRef = db.collection("product-items").document(prodKey)
        
        docRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: ProductItem.self)
//                try document.flatMap {
//                    try $0.data(as: ProductItem.self)
//                }
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
                print("Error decoding city: \(error)")
            }
        }
        
        /*
         // [Firebase real time database]
         if let prodKey = prodKey{
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
         }) { (error) in
         print(error.localizedDescription)
         }
         }
         */
    }
    
    func fetchData() {
        productName.text = prodItem?.name
        productPrice.text = prodItem?.price
        
        guard let imageURL = prodItem?.image, !imageURL.isEmpty else{ return}
        
        self.getImage(url: imageURL) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    self.productImageView.image = photo
                    self.prodImageIsNew = false
                }
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
        
        if self.prodKey != nil {
            editItem()
        }
        else{
            addItem()
        }
        
        performSegue(withIdentifier: "fromProductAdd", sender: nil)
    }
    
    func editItem() {
        
        //image Storage setup
        let randomID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "product-images/\(randomID).jpg")
        guard let imageData = productImageView.image?.jpegData(compressionQuality: 0.50) else{return}
        
        // Upload the file to the path "images/rivers.jpg"
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
            }
            
            // You can also access to download URL after upload.
            storageRef.downloadURL{ (url, error) in
                if error != nil{
                    print("EEError: \(String(describing: error))")
                }
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                let productItem = ProductItem(name: "test2", price: "2500",imageURL: downloadURL.absoluteString)
                
                //Add to Firebase Firestore
                do{
                    self.ref = try self.db.collection("product-items").addDocument(from: productItem ){
                        err in
                        if let err = err{
                            print("Error adding document \(err)")
                        }
                        else{
                            print("Document added with ID: \(self.ref!.documentID)")
                        }
                    }
                }catch{
                    print("")
                }
            }
        }
    }
    
    func addItem() {
        guard let name = productName.text,
            let price = productPrice.text else { return }
        
        //Check if image is new
        
        //let imgURL = uploadImage()
        //Add to Firebase Firestore
        //guard let imageURL = imgURL else{return}
        
        //image Storage setup
        let randomID = UUID.init().uuidString
        let storageRef = storage.reference(withPath: "product-images/\(randomID).jpg")
        let imageData = productImageView.image?.jpegData(compressionQuality: 0.25)
        
        if let imgData = imageData {
            storageRef.putData(imgData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Error on uploading impage: \(error?.localizedDescription)")
                }
                guard metadata != nil else {
                    return
                }
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {return}
                    
                    do{
                        let prodColl = self.db.collection("product-items")
                        let prodRef = prodColl.document()
                        
                        //Create productitem Type
                        let productItem = ProductItem(name: name, price: price,imageURL: downloadURL.absoluteString,key: prodRef.documentID)
                        try prodRef.setData(from: productItem.self){err in
                            if let err = err{
                                print("Error adding document \(err)")
                            }
                            else{
                                print("Document added with ID: \(self.ref!.documentID)")
                            }
                        }
                    }catch{
                        print("Error on adding document")
                    }
                }
            }
        }
        
        
        /*
         //image Storage setup
         let randomID = UUID.init().uuidString
         let storageRef = Storage.storage().reference(withPath: "product-images/\(randomID).jpg")
         guard let imageData = productImageView.image?.jpegData(compressionQuality: 0.25) else{return}
         
         let uploadMetaData = StorageMetadata.init()
         uploadMetaData.contentType = "image/jpeg"
         
         
         // Upload the file to the path "images/rivers.jpg"
         
         storageRef.putData(imageData, metadata: nil) { (metadata, error) in
         guard metadata != nil else {
         // Uh-oh, an error occurred!
         return
         }
         // You can also access to download URL after upload.
         storageRef.downloadURL { (url, error) in
         
         }
         }*/
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
    
    func deleteImage(imageUrl : String) -> Bool {
        return true
    }
    
    func uploadImage() -> String {
        var imageUrl: String = ""
        
        //image Storage setup
        let randomID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "product-images/\(randomID).jpg")
        let imageData = productImageView.image?.jpegData(compressionQuality: 0.25)
        
        if let imgData = imageData {
            storageRef.putData(imgData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Error on uploading impage: \(error?.localizedDescription)")
                }
                guard metadata != nil else {
                    return
                }
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {return}
                    imageUrl = downloadURL.absoluteString
                }
            }
        }
        
        return imageUrl
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
