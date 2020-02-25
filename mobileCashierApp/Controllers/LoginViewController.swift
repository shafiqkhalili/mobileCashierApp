//
//  LoginViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-24.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class LoginViewController: UIViewController {
    
    var auth : Auth!
    
    let loginToProducts = "LoginToProducts"
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        auth = Auth.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = self.auth.currentUser{
            self.performSegue(withIdentifier: loginToProducts, sender: self)
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        signIn()
    }
    func signIn() {
        guard let email = email.text else{return}
        guard let password = password.text else {return}
        
        auth.signIn(withEmail: email, password: password){
            user , error in
            if error != nil{
                print("Error on logging in \(error?.localizedDescription)")
            }
            if user != nil{
                if self.auth.currentUser != nil{
                    self.performSegue(withIdentifier: self.loginToProducts, sender: self)
                }}
            
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
