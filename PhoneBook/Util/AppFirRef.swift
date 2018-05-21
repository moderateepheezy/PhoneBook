//
//  AppFirRef.swift
//  PhoneBook
//
//  Created by SimpuMind on 5/21/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import UIKit
import RealmSwift

final class AppFirRef {
    
    static let baseRef = Database.database().reference()
    
    static var contactRef = baseRef.child("phonebook")
    
    static var userId: String{
        guard let userId = UserDefaults.standard.string(forKey: "uiid") else {
            UIApplication.shared.keyWindow?.rootViewController = ViewController()
            return ""
        }
        return userId
    }
    
    static func logout(){
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "firstTime")
        prefs.removeObject(forKey: "uiid")
        let loginVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginVc
    }
}

