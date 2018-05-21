//
//  ViewController.swift
//  PhoneBook
//
//  Created by SimpuMind on 5/20/18.
//  Copyright © 2018 SimpuMind. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        if usernameTextField.text == "" {
            self.setAlert(title: "Error", message: "Please enter your email and password")
        } else {
            guard let email = usernameTextField.text, let password = passwordTextField.text else {
                activityIndicator.alpha = 0
                activityIndicator.stopAnimating()
                return
            }
            self.signUpWith(email: email, password: password)
        }
    }
    
    private func signUpWith(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            self.activityIndicator.alpha = 0
            self.activityIndicator.stopAnimating()
            if error == nil {
                print("You have successfully signed up")
                //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                guard let user = user else {return}
                //Go to the HomeViewController if the login is sucessful
                self.completeSignUp(user: user)
                
            } else {
                if (error?.localizedDescription.contains("already"))! {
                    self.loginWith(email: email, password: password)
                    return
                }
                self.setAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    private func loginWith(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                
                //Print into the console if successfully logged in
                print("You have successfully logged in")
                guard let user = user else {return}
                //Go to the HomeViewController if the login is sucessful
                self.completeSignUp(user: user)
                
            } else {
                
                //Tells the user that there is an error and then gets firebase to tell them the error
                self.setAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    private func completeSignUp(user: User){
        UserDefaults.standard.set(true, forKey: "firstTime")
        UserDefaults.standard.set(user.uid, forKey: "uiid")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        let navVc = UINavigationController(rootViewController: vc!)
        UIApplication.shared.keyWindow?.rootViewController = navVc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension UIViewController {
    func setAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

