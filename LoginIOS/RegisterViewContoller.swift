//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 18/4/24.
//

import UIKit
import FirebaseAuth

class RegisterViewContoller: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

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
        
        // Hacer imagen redonda
        imagen=redondear(imagen: imagen)
        
        //Tomar id del usuario logado
        userId = Auth.auth().currentUser?.uid
        
        // Si no es nulo, crear objeto usuario nuevo con el id.
        if userId != nil {
            usuario = Usuario(idUser: userId!)
            Task {
                // Recuperar los datos de firebase
                usuario = await readData(doc:userId!)
                // Visualizar los datos
                render()
            }

        } else {
            // Si ha habido error salir.
            exit(0)
        }
        
        
        if userNameParam == nil {
            userNameParam="Anonimo"
        }
        
        
        
    }
    
    // Guardar los datos del perfil en firebase
    @IBAction func savePerfil(_ sender: Any) {
        
        usuario = Usuario(idUser: userId!)
        // Actualizar valores
        usuario?.nombre=nombreEdit.text!
        usuario?.apellidos=apellidoEdit.text!
        usuario?.imagenPerfil=imagenEdit.text!
        
        // Guardar usuario
        saveData(doc:userId!,user:usuario!)
        
        // Volver a HomeView
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func selecImage(_ sender: Any) {
        let picker = UIImagePickerController()
        
        //Si quieres tomar la imagen desde la cámara
        //picker.sourceType=.camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        Task {
            do {
                let urlString:String=try await subirArchivo(image:image,user: usuario!)
                
                print ("url recibida: \(urlString)")
                usuario?.imagenPerfil=urlString
                //imagen.image = image

                render()
            }catch {
                print ("Error subiendo archivo")
            }
        }
    
        dismiss(animated: true)
    }
    
    func render () {
        nombreEdit.text=usuario?.nombre
        apellidoEdit.text=usuario?.apellidos
        imagenEdit.text=usuario?.imagenPerfil
        if (usuario!.imagenPerfil.isEmpty) {
            imagen.image=UIImage(systemName:"person.circle")
        } else {
            imagen.loadImage(fromURL:usuario!.imagenPerfil)
        }
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
