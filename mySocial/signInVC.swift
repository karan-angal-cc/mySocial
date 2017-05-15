//
//  ViewController.swift
//  mySocial
//
//  Created by Karan Angal on 05/05/17.
//  Copyright © 2017 KaranAngal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class signInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JESS: unable to authenticate with FB - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("JESS: user dcancelled fb authentication")
            } else {
                
                print("JESS: successfully authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuth(credential)
                
            }
        }
            
    }
    
    func fireBaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("JESS: unable to auth with firebase-\(error)")
            } else {
                print("JESS: successfully auth with firebase")
            }
        })
    }
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error ==  nil {
                    print("JESS: user authenticated with firebase with email")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS:user auth with firebase failed using email")
                        } else {
                            print("JESS: successfully authenitcated")
                        }
                    })
                }
            })
        }
    }

}

