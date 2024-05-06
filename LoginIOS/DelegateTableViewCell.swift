//
//  DelegateTableViewCell.swift
//  LoginIOS
//
//  Created by Mañanas on 30/4/24.
//

import UIKit

class DelegateTableViewCell: UITableViewCell {


    @IBOutlet weak var vc1Fecha: UILabel!
    @IBOutlet weak var cv1Texto: UILabel!
    @IBOutlet weak var vc2Fecha: UILabel!
    @IBOutlet weak var vc2Texto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render (tipo:Int,userId:String,texto:String,fecha:Date){
        
        if tipo==1 {
            print ("celda 1")
            cv1Texto.text=texto
            vc1Fecha.text=fecha.ISO8601Format()
        }
        
        print ("celda 2")
        vc2Texto.text=texto
        vc2Fecha.text=fecha.ISO8601Format()
        
    }
}

