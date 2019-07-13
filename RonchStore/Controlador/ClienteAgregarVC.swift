//
//  ClienteAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClienteAgregarVC: UIViewController {

    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction func botonAgregar(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
    
        ref.child("Clientes").child(telefono.text!).setValue(["telefono": telefono.text!, "nombre": nombre.text!, "direccion": direccion.text!,"email": email.text!])
        
        
        let alert = UIAlertController(title: "Clientes", message: "Cliente agregado.", preferredStyle: .actionSheet)
        
   
        
        self.present(alert, animated: true)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.botonLimpiar(sender)

        }
        
    }
    
    @IBAction func botonLimpiar(_ sender: Any) {
        telefono.text = ""
        nombre.text = ""
        direccion.text = ""
        email.text = ""
        telefono.select(sender)
    }
    
    @IBAction func botonCancelar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
