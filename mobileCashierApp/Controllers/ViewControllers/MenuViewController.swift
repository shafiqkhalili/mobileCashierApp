//
//  MenuViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-24.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class MenuViewController: UIViewController {
    
    var auth: Auth!
    
    let segueId = "MenuToLogin"
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    var menuOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        auth = Auth.auth()
    }
    
    
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        if menuOut == false{
            leading.constant = 150
            trailing.constant = -150
            menuOut = true
        }
        else{
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func singOut(_ sender: UIButton) {
        if auth.currentUser != nil {
            do {
                try auth.signOut()
                if auth.currentUser == nil {
                   self.performSegue(withIdentifier: self.segueId, sender: self)
                }
            }
            catch {
                print("Failed to sign out")
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
