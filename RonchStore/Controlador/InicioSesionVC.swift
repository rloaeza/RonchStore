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
                //Datos.cargarClientes()
                Datos.cargarProductos()
                Datos.cargarListas()
                
                
                //var valores: [NSDictionary] = []
                //valores = Datos.getListas(Patron: "")

                
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("\(Configuraciones.keyUsuarios)/\(user!.user.uid)").observeSingleEvent(of: .value) { (DataSnapshot) in
                    let dic  = DataSnapshot.value as! NSDictionary
                    switch dic.value(forKey: Configuraciones.keyAdmin) as! Int {
                    case 1: self.performSegue(withIdentifier: "InicioSesion_Principal", sender: nil)
                    case 0: self.performSegue(withIdentifier: "InicioSesion_Cobrador", sender: nil)
                    default: Configuraciones.alert(Titulo: "Error", Mensaje: "Este usuario ya no es válido", self, popView: false)
                    }
                }
            }
            else {
                Configuraciones.alert(Titulo: "Error", Mensaje: "Usuario o contraseñano válida", self, popView: false)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
