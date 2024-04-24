//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 18/4/24.
//

import UIKit

class VerifyViewContoller: UIViewController {

    @IBOutlet weak var nombreEdit: UITextField!
    @IBOutlet weak var apellidoEdit: UITextField!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenEdit: UITextField!
    
    // Variable para almacenar el perfil
    var usuario:Usuario?=nil
    
    // Datos de login
    var userNameParam = UserDefaults.standard.string(forKey: "Email")
    let userId:String=UserDefaults.standard.string(forKey: "IdUser")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userNameParam == nil {
            userNameParam="Anonimo"
        }
        
        Task {
            usuario = await readData(doc:userId)
        }
        
        // Hacer imagen redonda
        imagen.layer.borderWidth=1.0
        imagen.layer.masksToBounds = false
        imagen.layer.borderColor = UIColor.black.cgColor
        imagen.layer.cornerRadius = imagen.frame.size.height/2
        imagen.clipsToBounds = true
        
        
        if userId != nil {
            usuario = Usuario(idUser: userId!)
            //var urlImage = UserDefaults.standard.string(forKey: "ImageUser")
            // usuario.imagenPerfil=urlImage
        } else{ return }
        
        // wellcomeMessage.text="Wellcome \(userNameParam!)"
    }
    @IBAction func savePerfil(_ sender: Any) {
        
        // Actualizar valores
        usuario?.nombre=nombreEdit.text!
        usuario?.apellidos=apellidoEdit.text!
        usuario?.imagenPerfil=imagenEdit.text!
        
        // Guardar usuario
        saveData(doc:userId!,user:usuario!)
        
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
