//
//  ConversationsTableViewCell.swift
//  LoginIOS
//
//  Created by Jesus Esteban on 5/5/24.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell {
    
     
    @IBOutlet weak var titleConversation: UILabel!
    
    func render (tit:String){
         //Asignar los datos a la celda.
         titleConversation.text=tit
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
