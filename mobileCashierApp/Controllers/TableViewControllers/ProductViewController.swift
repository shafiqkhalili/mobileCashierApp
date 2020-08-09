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
import AVFoundation

class ProductViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,DiscountDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var barcodeBtn: UIButton!
    
    //Scanner setup
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //Realtime ref
    //var ref: DatabaseReference!
    
    //Firestore ref
    let db = Firestore.firestore().collection("users")
    
    var auth: Auth!
    
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
    
    @IBAction func barcodeBtnClicked(_ sender: UIButton) {
        //Scanner setup
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
            } else {
                self.failed()
                return
            }
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.avPreviewLayer)
            self.avCaptureSession.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
                
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        auth = Auth.auth()
        
        //Retreive all data from Firestore
        //Firestore ref
        let dbRef = db.document(auth.currentUser!.uid)
        var ref: DocumentReference? = nil
        
        dbRef.collection("products").addSnapshotListener(){(querySnapshot,error) in
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
       
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ProductTVCell", bundle: nil)
        productsTableView.register(nib, forCellReuseIdentifier: productCellID)
        productsTableView.dataSource = self
        
    }
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
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
        
        let dbRef = db.document(auth.currentUser!.uid)
        let basketRef = dbRef.collection("products").document(prodItem.key)
        
        basketRef.getDocument { (document, error) in
            let result = Result {
                try document?.data(as: ProductItem.self)
            }
            switch result {
            case .success(let item):
                //If already exist
                if item != nil {
                    basketRef.updateData([
                        "quantity": FieldValue.increment(Int64(1))
                    ])
                }
            case .failure(let error):
                print("Error decoding: \(error)")
                print(error.localizedDescription)
            }
        }
    }
    //Delete product
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let prodItem = items[indexPath.row]
            
            let itemKey = prodItem.key
            
            let dbRef = db.document(auth.currentUser!.uid)
            
            let itemRef = dbRef.collection("products").document(itemKey)
            
            //let basketRef = dbRef.collection("product-basket").document(itemKey)
            
            //Delete item
            itemRef.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    //If success, delete basket
                    /*
                    basketRef.delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }*/
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
    
    @IBAction func logOut(_ sender: Any) {
        if auth.currentUser != nil{
            do {
                try auth.signOut()
                if auth.currentUser == nil {
                    print("Signed out !")
                    self.performSegue(withIdentifier: "productToSignin", sender: self)
                }
            }
            catch {
                print("Failed to sign out")
            }
        }
    }
    @IBAction func addProduct(_ sender: UIBarButtonItem) {
        clickedItemKey = nil
        performSegue(withIdentifier: prodDetailsSegue, sender: self)
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
extension ProductViewController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
//        let alert = UIAlertController(title: "Barcode", message: "Your scanned barcode is: \(code)", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//       
        print("Barcode: \(code)")
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
