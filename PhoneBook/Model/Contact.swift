//
//  Contact.swift
//  PhoneBook
//
//  Created by SimpuMind on 5/21/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
