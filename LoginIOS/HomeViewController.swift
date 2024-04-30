//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 23/4/24.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageProView: UIImageView!
    
    var usuario:Usuario?=nil
    var userId:String?
    var isLogin=false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProView=redondearImagen(imagen:imageProView)
        isLogin = (Auth.auth().currentUser != nil)
        
        if isLogin {
            Task {
                print ("Usuario Logado")
                userId=Auth.auth().currentUser?.uid
                var dialog:Dialog? = await buscarDialog(userId:userId!) ?? nil
                usuario = await readUser(doc:userId!)
                if (usuario!.imagenPerfil.isEmpty) {
                    imageProView.image=UIImage(systemName:"person.circle")
                } else {
                    imageProView.loadImage(fromURL:usuario!.imagenPerfil)
                }
            }
            
        }
        
        
                
        //navBarr.rightBarButtonItem?.isEnabled
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userId=Auth.auth().currentUser?.uid
        
        Task {
            usuario = await readUser(doc:userId!)
            
            
            if isLogin {
                if ((usuario?.imagenPerfil.isEmpty) != nil) {
                    imageProView.loadImage(fromURL:usuario!.imagenPerfil)
                } else {
                    imageProView.image=UIImage(systemName:"person.circle")
                }
                // Seguir con la lógica.
            } else {
                goToLogin()
            }
        }
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

