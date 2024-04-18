//
//  HomeViewController.swift
//  LoginIOS
//
//  Created by Mañanas on 18/4/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var wellcomeMessage: UILabel!
    var userNameParam:String="PruebaUser"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wellcomeMessage.text="Wellcome \(userNameParam)"
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
