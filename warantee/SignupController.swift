//
//  SignupController.swift
//  warantee
//
//  Created by Fidel Lim on 12/7/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
// sign up page
class SignupController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // lsign up user
    @IBAction func signin(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        // create a user with firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                return
            }
            
            //if success, logout and go to login
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                print("user logged out")
                self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
           
        }
        
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

}
