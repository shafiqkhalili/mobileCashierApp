//
//  FIRFirestoreServices.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-17.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//
/*
import Foundation
import Firebase
import FirebaseFirestore

class FIRFirestoreServices {
    private init(){}
    static let shared = FIRFirestoreServices()
    
//    FIRFirestoreService.shared.read()
    func configue() {
        //FirebaseApp.configure()
    }
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference{
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func create(to collection: FIRCollectionReference, data: Any) {
        
        reference(to: collection).addDocument(data: data as! [String : Any])
    }
    
    func fetchAll(from collection: FIRCollectionReference){
        
        let itemRef = db.collection("items")
        itemRef.addSnapshotListener(){
            (snapshot,error) in
            guard let documents = snapshot?.documents else{ return}
            self.shoppingList.removeAll()
            
            for document in documents {
                let result = Result{
                    try document.data(as: Item.self)
                }
                switch result {
                case .success(let item):
                    if let item = item {
                        self.shoppingList.append(item)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    func read(from collection: FIRCollectionReference) {
        
        var ref: DocumentReference? = nil
        reference(to: collection).addDocument(data: productItem.toAnyObject() as! [String : Any]){
            err in
            if let err = err{
                print("Error adding document \(err)")
            }
            else{
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
    }
    
    func set(to collection: FIRCollectionReference, data: Any) {
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        reference(to: collection).addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func update(in collection: FIRCollectionReference,data: Any) {
        
        var ref: DocumentReference? = nil
        
        reference(to: collection).updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        
    }
}
*/
