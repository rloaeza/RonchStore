//
//  RegistroVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 21/07/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import Firebase


class RegistroVC: UIViewController {
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var correo1: UITextField!
    @IBOutlet weak var correo2: UITextField!
    @IBOutlet weak var clave1: UITextField!
    @IBOutlet weak var clave2: UITextField!
    @IBOutlet weak var encabezado: UITextField!
    @IBOutlet weak var pie: UITextField!
    
    @IBAction func cancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func aceptar(_ sender: Any) {
        if correo1.text?.isEmpty ?? true || clave1.text?.isEmpty ?? true {
            return
        }
        let msg = """
        * Verificar formato de correo
        * La clave debe de ser de mínimo 6 caracteres
        """
        if correo1.text == correo2.text && clave1.text == clave2.text {
            Auth.auth().createUser(withEmail: correo1.text!, password: clave1.text!, completion: { (result, error) in
                if error == nil {
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    let newKey: DatabaseReference!
                   
                    newKey = ref.child(Configuraciones.keyUsuarios).child(result!.user.uid)
                    newKey.setValue( [Configuraciones.keyNombre:self.nombre.text!,
                                      Configuraciones.keyEmail:self.correo1.text!,
                                      Configuraciones.keyTelefono:self.telefono.text!,
                                      Configuraciones.keyAdmin:true,
                                      Configuraciones.keyUsuarioPro:false,
                                      Configuraciones.keyEncabezado:self.encabezado.text!,
                                      Configuraciones.keyPie:self.pie.text!
                                      
                    ])
                    
                    //Configuraciones.alert(Titulo: "Usuario", Mensaje: "Usuario guardado", self, popView: false)
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    Configuraciones.alert(Titulo: Configuraciones.txtError, Mensaje: msg, self, popView: true)
                }
                
                
            })
            
        }
        else {
            Configuraciones.alert(Titulo: Configuraciones.txtError, Mensaje: msg, self, popView: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
