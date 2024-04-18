//
//  ViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 18/4/24.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLog: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
// Prueba
    @IBAction func registerButton(_ sender: Any) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://www.example.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.example.android",
                                                 installIfNotAvailable: false, minimumVersion: "12")
        
        
        
        
        
        Auth.auth().sendSignInLink(toEmail: userName.text!,
                                   actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
                errorLog.text=(error.localizedDescription)
              return
            }
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            UserDefaults.standard.set(email, forKey: "Email")
            errorLog.text="Check your email for link"
            // ...
        }
        
        
        
        
        /*Registro con usuario y contraseña.
        Auth.auth().createUser(withEmail:userName.text!, password: password.text!) { authResult, error in
           ...
            if error == nil {
                print ("Registro Correcto")
            } else {
                print ("Error en registro: \(String(describing: error?.localizedDescription.debugDescription))")
            }
        }
         */
    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: userName.text!, password: password.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
            if error == nil {
                print ("Login Correcto")
                self?.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                print ("Error en Login: \(error?.localizedDescription.debugDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToHome" {
            let homeViewControler=segue.destination as! HomeViewController
            homeViewControler.userNameParam=userName.text!
        }
    }
    
    func actionCodeSettings(){
        
    }
    
}

