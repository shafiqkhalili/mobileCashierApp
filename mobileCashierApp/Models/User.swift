//
//  User.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-01-26.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import Foundation
import Firebase

struct User: Codable {
    
    let uid: String
    let email: String
    let password: String
    let organization: String
    
    enum CodingKeys: CodingKey{
        case uid
        case email
        case password
        case organization
    }

    init(uid: String = "", email: String,password: String,organization: String) {
        self.uid = uid
        self.email = email
        self.password = password
        self.organization = organization
    }
}
