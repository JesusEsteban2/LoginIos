//
//  ViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 18/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorLog: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func registerButton(_ sender: Any) {
        
        /* Validación con un enlace al Correo electrónico */
        
        // Parte para envio del enlace.
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://loginios-e440d.firebaseapp.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.example.android",
                                                 installIfNotAvailable: false, minimumVersion: "12")
        
        // Parte de verificación del registro.
        Auth.auth().sendSignInLink(toEmail: userName.text!,
                                   actionCodeSettings: actionCodeSettings) { [self] error in
        // Si se ha producido un error visualizar.
        if let error = error {
            errorLog.text=("Error: " + error.localizedDescription)
        return
        }
        // The link was successfully sent. Inform the user.
        // Save the email locally so you don't need to ask the user for it again
        // if they open the link on the same device.
        UserDefaults.standard.set(userName.text, forKey: "Email")
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
                self?.errorLog.text="Login Correcto"
                self?.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                print ("Error en Login: \(error?.localizedDescription.debugDescription)")
            }
        }
    }
    
    
    
    @IBAction func loginWithGoole(_ sender: Any) {
        
        let user=googleSignIn()
        errorLog.text="Login con user: \(user?.profile?.email)"
        

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToHome" {
            let homeViewControler=segue.destination as! HomeViewController
            homeViewControler.userNameParam=userName.text!
        }
    }
    
    func googleSignIn() -> GIDGoogleUser? {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return nil
        }
        
        var user:GIDGoogleUser?  = nil
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                self.errorLog.text=error?.localizedDescription
                return
            }
            
            user = result?.user
            let idToken = user?.idToken?.tokenString ?? nil
            if idToken == nil {
                self.errorLog.text=error?.localizedDescription
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                           accessToken: user!.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if error == nil {
                    self.errorLog.text="Login Correcto"
                    UserDefaults.standard.set(user?.profile?.email, forKey: "Email")
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                } else {
                    print ("Error en Login: \(error?.localizedDescription.debugDescription)")
                }
            }
        }
        return user
    }
    
}

