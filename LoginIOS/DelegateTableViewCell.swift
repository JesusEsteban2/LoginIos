//
//  DelegateTableViewCell.swift
//  LoginIOS
//
//  Created by Mañanas on 30/4/24.
//

import UIKit

class DelegateTableViewCell: UITableViewCell {

    

    @IBOutlet weak var vc1Texto: UILabel!
    @IBOutlet weak var vc1Fecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render (tipo:Int,userId:String,texto:String,fecha:Date){
        
        vc1Texto.text=texto
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm"

        let formattedDate = dateFormatter.string(from: fecha)
        
        vc1Fecha.text=formattedDate
        
    }
}

