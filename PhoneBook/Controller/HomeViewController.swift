//
//  HomeViewController.swift
//  PhoneBook
//
//  Created by SimpuMind on 5/21/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift


class HomeViewController: UIViewController {

    var realm : Realm!
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactList: Results<Contact> {
        get {
            return realm.objects(Contact.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()

        view.backgroundColor = .white
        
        let addContactBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddContact))
        navigationItem.rightBarButtonItem = addContactBarButton
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem = logoutBarButton
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        populateTable()
    }
    
    private func populateTable(){
        AppFirRef.contactRef.child(AppFirRef.userId).observe(.childAdded) { (snapshot) in
            
            print(snapshot)
            let result = snapshot.value as! [String: Any]
            print(result)
            let name = result["name"] as! String
            let email = result["email"] as! String
            let id = result["id"] as! String
            let contact = Contact()
            contact.name = name
            contact.id = id
            contact.email = email
            
            
            try! self.realm.write {
                self.realm.add(contact, update: true)
                self.tableView.reloadData()
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc private func handleAddContact(){
        self.createInputs()
    }
    
    private func createInputs(){
        let alertController = UIAlertController(title: "Add New Contact", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField) in
            textField.placeholder = "User Name"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "User Email"
                textField.keyboardType = .emailAddress
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let emailTextField = alertController.textFields![1] as UITextField
            guard let name = nameTextField.text, let email = emailTextField.text, email != "", name != "" else {
                return
            }
            self.addContact(name: name, email: email)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func addContact(name: String, email: String){
        let key = AppFirRef.contactRef.childByAutoId().key
        let contact = [
            "id": key,
            "name": name,
            "email": email
        ]
        let userRef = AppFirRef.contactRef.child(AppFirRef.userId)
        userRef.child(key).setValue(contact)
    }
    
    @objc private func handleLogout(){
        AppFirRef.logout()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = contactList[indexPath.item]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.email
        return cell
    }
}
