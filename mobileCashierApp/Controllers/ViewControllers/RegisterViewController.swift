//
//  RegisterViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-24.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class RegisterViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    var auth: Auth!
    
    let segueId = "registerToProducts"
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var orgNr: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordRepeat: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        auth = Auth.auth()
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        creatUser()
    }
    
    @IBAction func modalDismissed(segue: UIStoryboardSegue) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "LoginViewController")

        show(secondVC, sender: self)
      
//        let storyboard = UIStoryboard(name: "myStoryboardName", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "nextViewController") as UIViewController
//        presentViewController(vc, animated: true, completion: nil)
    }
    
    func creatUser() {
        guard let email = self.email.text,
            let password = self.password.text,
            let organization = self.orgNr.text else {return}
        
        auth.createUser(withEmail: email, password: password){
            result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else{
                let userRef = self.db.collection("users").document()
                
                let user = User(uid: result!.user.uid, email: email, password: password, organization: organization)
                
                do{
                    try userRef.setData(from: user.self){err in
                        if let err = err{
                            print("Error adding document \(err)")
                        }
                    }
                } catch{
                    print("Error")
                }
                if let user = self.auth.currentUser{
                    self.performSegue(withIdentifier: self.segueId, sender: self)
                }
            }
        }
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
