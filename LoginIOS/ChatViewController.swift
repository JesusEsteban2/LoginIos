//
//  ChatViewController.swift
//  LoginIOS
//
//  Created by Jesus on 29/4/24.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var conversacionParam:Dialog?=nil
    var userIdParam:String=""
    var mensajes:[Mensaje]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        
        if (conversacionParam == nil) {
            print ("No existe conversación.")
            self.navigationController?.popViewController(animated: true)
            
        } else {
            Task{
                let doc=conversacionParam!.dialogId
                let conve=conversacionParam!.conversacion
                mensajes=try await readMensajes(doc:doc,conve:conve)
                if (mensajes.isEmpty) {
                    print ("La lista de mensajes está vacía")
                    print ("En la conversación \(conversacionParam!.dialogId)")
                }
                print ("Mensaje: \(mensajes[0].texto)")
                tableView.reloadData()
            }
        }
    }
    
    // numero de elemntos de los datos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mensajes.count
    }
    
    // Render de filas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fila = mensajes[indexPath.row]
        
        if (fila.remitente==userIdParam) {
            let cell2:DelegateTableViewCell=tableView.dequeueReusableCell(withIdentifier:"ViewCell2", for: indexPath) as! DelegateTableViewCell
            cell2.render(tipo:2,userId:fila.remitente,texto:fila.texto,fecha:fila.fecha)
            return cell2
        }
        
        let cell1:DelegateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ViewCell1", for:indexPath) as! DelegateTableViewCell
        cell1.render(tipo:1,userId: fila.remitente, texto: fila.texto, fecha: fila.fecha)
        return cell1
    }
      
}
