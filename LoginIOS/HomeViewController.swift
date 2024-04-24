//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 23/4/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    var isLogin=UserDefaults.standard.bool(forKey: "IsLogin")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isLogin=UserDefaults.standard.bool(forKey: "IsLogin")
        print ("El valor de Islogin es: \(isLogin)")
        
        if isLogin {
            // Ir a appcontroler.
        } else {
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
        
        //navBarr.rightBarButtonItem?.isEnabled
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UserDefaults.standard.set(false, forKey: "IsLogin")
    }

    @IBAction func logOut(_ sender: Any) {
        // Auth.auth().settings.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="goToLogin" {
            let loginViewControler=segue.destination as! LoginViewController
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
