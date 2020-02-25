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

    var db: Firestore!
    
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
    
    func creatUser() {
        guard let email = self.email.text else{return}
        guard let password = self.password.text else {return}
        
        auth.createUser(withEmail: email, password: password){
            result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let user = self.auth.currentUser{
                self.performSegue(withIdentifier: self.segueId, sender: self)
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
