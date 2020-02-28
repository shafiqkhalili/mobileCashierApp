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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        auth = Auth.auth()
        
        password.isSecureTextEntry = true
        
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.darkGray.cgColor
        loginButton.layer.cornerRadius = 5
        
        registerbutton.layer.borderWidth = 2
        registerbutton.layer.borderColor = UIColor.orange.cgColor
        registerbutton.layer.cornerRadius = 5
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
        
        Auth.auth().currentUser?.uid
        
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
