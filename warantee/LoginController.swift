//
//  LoginController.swift
//  warantee
//
//  Created by Fidel Lim on 12/7/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
// login scene
class LoginController: UIViewController {

    //variables
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // login to if successful login
      Auth.auth().addStateDidChangeListener
      { (auth, user) in
          
          if user != nil {
            self.goToMenu()
          }
          
      }
        
      GIDSignIn.sharedInstance()?.presentingViewController = self
      // Automatically sign in the user.
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // Do any additional setup after loading the view.
    }
    
    //login
    @IBAction func login(_ sender: Any) {
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
           print(authResult)
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                return
            }
            print("login success")
            //self?.goToMenu()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // got to menu
    func goToMenu(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC:ViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! ViewController
        
        //go to new screen in fullscreen
        menuVC.modalPresentationStyle = .fullScreen
        self.present(menuVC, animated: true, completion: nil)
    }

}
