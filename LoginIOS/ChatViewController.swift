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
    var mensajes:[Mensaje]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource=self
        
        if (conversacionParam == nil) {
            print ("No existe conversación.")
            self.navigationController?.popViewController(animated: true)
            
        } else {
            Task{
                let doc=conversacionParam!.dialogId
                let conve=conversacionParam!.conversacion
                mensajes=try await readMensajes(doc:doc,conve:conve)
                if !(mensajes.isEmpty) {
                    //Todo logica
                    tableView.reloadData()
                } else {
                    print ("La lista de mensajes está vacía")
                    print ("En la conversación \(conversacionParam!.dialogId)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
