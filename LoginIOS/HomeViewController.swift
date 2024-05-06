//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Jesus on 23/4/24.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var imageProView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var dialogos:[Dialog] = []
    var usuario:Usuario?=nil
    var userId:String?
    var isLogin=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProView=redondearImagen(imagen:imageProView)
        
        
        self.tableView.dataSource=self
        //navBarr.rightBarButtonItem?.isEnabled
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isLogin = (Auth.auth().currentUser != nil)
        // Si el usuario esta logado.
        if isLogin {
            Task {
                print ("Usuario Logado")
                // Recuperar el user Id
                userId=Auth.auth().currentUser?.uid
                // Recuperar los datos para user id
                usuario = await readUser(doc:userId!)
                // Cargar la imagen de perfil del usuario o la imagen por defecto.
                if (usuario!.imagenPerfil.isEmpty) {
                    imageProView.image=UIImage(systemName:"person.circle")
                } else {
                        imageProView.loadImage(fromURL:usuario!.imagenPerfil)
                }
                // Buscar conversaciones abiertas para el usuario Id
                dialogos = try await buscarDialog(userId:userId!)
                tableView.reloadData()
                print ("Conversaciones encontradas: \(dialogos.count)")
                // Falta visualizar las conversaciones disponibles
            }
            // Seguir con la lógica.
            
        } else {
            // Si el usuario no está logado ir a pantalla de loguin.
            goToLogin()
        }
        
        
    }
    
    /**
     Función de Logout del perfil actual llevará obligatoriamente a pantalla de loguin
     */
    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            isLogin = (Auth.auth().currentUser != nil)
            goToLogin()
        } catch {
            print ("Fallo en Logout de Firebase")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dialogos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ConversationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for:indexPath) as! ConversationsTableViewCell
               
        let fila = dialogos[indexPath.row]
           
        cell.render(tit:fila.titulo)
               
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /**
     segues para navegación entre pantallas.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToLogin":
            let destinationViewControler=segue.destination as! LoginViewController
        case "goToChat":
            let destinationViewControler=segue.destination as! ChatViewController
            let fila=tableView.indexPathForSelectedRow
            print ("La fila seleccionada es: \(fila!.row)")
            destinationViewControler.conversacionParam=dialogos[fila!.row]
        default:
            return
        }
    }
    
    /**
        Ir a Pantalla de Loguin
     */
    func goToLogin(){
            
        performSegue(withIdentifier: "goToLogin", sender: self)
    }

}

