//
//  FooterViewController.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-27.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit

protocol CustomViewDelegate: class {
    // make this class protocol so you can create `weak` reference
    func goToNextScene()
}

class FooterViewController: UIView {
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Do any additional setup after loading the view.
    //    }
    
    //    @IBAction func buttonAdd(_ sender: UIButton) {
    //        performSegue(withIdentifier: segueToDisplayId, sender: self)
    //    }
    weak var delegate: CustomViewDelegate?   // make this `weak` to avoid strong reference cycle b/w view
    
    @IBAction func buttonAdd(_ sender: Any) {
        
        delegate?.goToNextScene()
        
    }
    
    @IBAction func buttonDiscount(_ sender: Any) {
        
    }
    @IBAction func buttonShoppingLIst(_ sender: Any) {
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

extension UIView {
    /// Eventhough we already set the file owner in the xib file, where we are setting the file owner again because sending nil will set existing file owner to nil.
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self))
            .loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
                return nil
        }
        return contentView
    }
}
