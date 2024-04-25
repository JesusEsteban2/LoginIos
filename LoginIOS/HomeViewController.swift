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
        
        let urlString = "https://www.superherodb.com/pictures2/portraits/10/100/10060.jpg"
            guard let url = URL(string: urlString) else {
                // Manejar el caso de URL inválida
                print("URL inválida: \(urlString)")
                return
            }
            
            // Utiliza una tarea asincrónica para cargar la imagen
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    DispatchQueue.main.async {
                        self.imageProfile.setBackgroundImage(UIImage(data: data), for: .normal, barMetrics: .default)
                    }
                } catch {
                    // Manejar el error en la carga de la imagen
                    print("Error al cargar la imagen: \(error)")
                }
            }
        //imageLoad.loadImage(fromURL:"https://www.superherodb.com/pictures2/portraits/10/100/10060.jpg")

        //Timer(timeInterval: 3, repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)

            
        //imageProfile.image=imageLoad.image
        //navBarr.rightBarButtonItem?.isEnabled
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

