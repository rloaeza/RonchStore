//
//  InicioSesionVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class InicioSesionVC: UIViewController {
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var clave: UITextField!
    
    @IBAction func botonSalir(_ sender: Any) {
        exit(1)
    }
    @IBAction func botonAcceder(_ sender: Any) {
        Auth.auth().signIn(withEmail: usuario.text!, password: clave.text!) { (user, error) in
            if error == nil {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                var isAdmin: Int = 0
                ref.child(Configuraciones.keyUsuarios).observeSingleEvent(of: .value) { (DataSnapshot) in
                    
                    for child in DataSnapshot.children {
                        if let snap = child as? DataSnapshot {
                            let dic = snap.value as? NSDictionary
                            if dic?.value(forKey: Configuraciones.keyNombre) as! String == self.usuario.text! {
                                let admin = dic?.value(forKey: Configuraciones.keyAdmin) as! Bool
                                if admin {
                                    isAdmin = 1
                                }
                                else {
                                    isAdmin = 2
                                    
                                }
                                break
                                
                            }
                        }
                    }
                    switch isAdmin {
                    case 1: self.performSegue(withIdentifier: "InicioSesion_Principal", sender: nil)
                    case 2: self.performSegue(withIdentifier: "InicioSesion_Cobrador", sender: nil)
                    default: Configuraciones.alert(Titulo: "Error", Mensaje: "Este usuario ya no es válido", self, popView: false)
                    }
                    
                    
                }
               
            }
            else {
                Configuraciones.alert(Titulo: "Error", Mensaje: "Usuario no registrado", self, popView: false)
            }
            
        }
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
