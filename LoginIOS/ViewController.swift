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
    @IBOutlet weak var saveSessionSwitch: UISwitch!
    
    var isLogin=false
    let null:Bool?=nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        isLogin=UserDefaults.standard.bool(forKey: "IsLogin")
        errorLog.text="El valor de Islogin es: \(isLogin)"
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UserDefaults.standard.set(false, forKey: "IsLogin")
    }

    @IBAction func registerButton(_ sender: Any) {
        
        //Registro con usuario y contraseña.
        // Con esta opción no se verifica que el correo sea válido
        Auth.auth().createUser(withEmail:userName.text!, password: password.text!) { authResult, error in
           
            if error == nil {
                print ("Registro Correcto")
            } else {
                print ("Error en registro: \(String(describing: error?.localizedDescription.debugDescription))")
            }
        }
      
    }
    
    func loginWithMailValidation(){
        /* Validación con un enlace al Correo electrónico */
        // Incompleto falta completar
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
        saveLogin(email: userName.text!)
        errorLog.text="Check your email for link"
        // ...
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: userName.text!, password: password.text!) { [weak self] authResult, error in
            guard self != nil else { return }
          // ...
            if error == nil {
                self?.errorLog.text="Login Correcto"
                self?.saveLogin(email: self!.userName.text!)
                self?.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                print ("Error en Login: \(error?.localizedDescription.debugDescription ?? "Error desconocido") ")
            }
        }
    }
    
    
    @IBAction func loginWithGoole(_ sender: Any) {
        
        let user=googleSignIn()
        errorLog.text="Login con user: \(user?.profile?.email ?? "Usuario no encontrado")"
        

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goToHome" {
            let homeViewControler=segue.destination as! HomeViewController
            
            // no es necesario parametro, se pasa por UserDefaults en saveLogin
            // homeViewControler.userNameParam=userName.text!
        }
    }
    
    // Función para logarse con correo de Google.
    func googleSignIn() -> GIDGoogleUser? {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return nil
        }
        // Create a blank google user for return purposes
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
                    let username = user?.profile?.email
                    self.saveLogin(email: username!)
                    print ("\(username)")
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                } else {
                    let txtError="Error en Login: " + (error?.localizedDescription.debugDescription ?? "Error desconocido")
                    print ("\(txtError)")
                }
            }
        }
        return user
    }

    
    func saveLogin (email:String) {
        
        print ("\(email)")
        
        //If is marked, save user session
        if saveSessionSwitch.isOn {

            UserDefaults.standard.set(email, forKey: "Email")

        }

        // Save active sesion login to go the program.
        UserDefaults.standard.set(true, forKey: "IsLogin")

    }
    
}

