//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 23/4/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIBarButtonItem!
    let imageLoad:UIImageView=UIImageView(image: UIImage(systemName: "person.circle"))
    
    var isLogin=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navBarr.rightBarButtonItem?.isEnabled
        //imageLoad.loadImage(fromURL:"https://www.superherodb.com/pictures2/portraits/10/100/10060.jpg")

        imageProfile.image=imageLoad.image
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isLogin = (Auth.auth().currentUser != nil)
        
        if isLogin {
            // Ir a appcontroler.
        } else {
            goToLogin()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //UserDefaults.standard.set(false, forKey: "IsLogin")
    }

    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            isLogin = (Auth.auth().currentUser != nil)
            goToLogin()
        } catch {
            print ("Fallo en Logout de Firebase")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToLogin":
            let destinationViewControler=segue.destination as! LoginViewController
        default:
            return
        }
    }
    
    func goToLogin(){
            
            performSegue(withIdentifier: "goToLogin", sender: self)
        }

}

