//
//  InicioSesionVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseAuth

class InicioSesionVC: UIViewController {
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var clave: UITextField!
    
    @IBAction func botonSalir(_ sender: Any) {
        exit(1)
    }
    @IBAction func botonAcceder(_ sender: Any) {
        
        print("Usuario: "+usuario.text!)
        print("Clave: "+clave.text!)
        
        Auth.auth().signIn(withEmail: usuario.text!, password: clave.text!) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "InicioSesion_Principal", sender: nil)
            }
            
        }
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
