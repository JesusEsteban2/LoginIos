//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 18/4/24.
//

import UIKit
import FirebaseAuth

class RegisterViewContoller: UIViewController {

    @IBOutlet weak var nombreEdit: UITextField!
    @IBOutlet weak var apellidoEdit: UITextField!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenEdit: UITextField!
    
    // Variable para almacenar el perfil
    var usuario:Usuario?=nil
    
    // Datos de login
    var userNameParam = UserDefaults.standard.string(forKey: "Email")
    var userId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = Auth.auth().currentUser?.uid
        
        if userId != nil {
            usuario = Usuario(idUser: userId!)
            Task {
                await usuario = readData(doc:userId!)
                nombreEdit.text=usuario?.nombre
                apellidoEdit.text=usuario?.apellidos
                imagenEdit.text=usuario?.imagenPerfil
                if (usuario!.imagenPerfil.isEmpty) {
                    imagen.image=UIImage(systemName:"person.circle")
                } else {
                    imagen.loadImage(fromURL:usuario!.imagenPerfil)
                }
            }
            
            

        } else {
            exit(0)
        }
        
        
        if userNameParam == nil {
            userNameParam="Anonimo"
        }
        
        // Hacer imagen redonda
        imagen.layer.borderWidth=1.0
        imagen.layer.masksToBounds = false
        imagen.layer.borderColor = UIColor.black.cgColor
        imagen.layer.cornerRadius = imagen.frame.size.height/2
        imagen.clipsToBounds = true
        
    }
    @IBAction func savePerfil(_ sender: Any) {
        
        usuario = Usuario(idUser: userId!)
        // Actualizar valores
        usuario?.nombre=nombreEdit.text!
        usuario?.apellidos=apellidoEdit.text!
        usuario?.imagenPerfil=imagenEdit.text!
        
        // Guardar usuario
        saveData(doc:userId!,user:usuario!)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
