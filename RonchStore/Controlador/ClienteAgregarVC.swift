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
    
    var cliente: NSDictionary? = nil

    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var botonEliminar: UIButton!
    
    @IBAction func botonGuardar(_ sender: Any) {
        if telefono.text!.isEmpty {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Clientes").child(telefono.text!).setValue(["telefono": telefono.text!, "nombre": nombre.text!, "direccion": direccion.text!,"email": email.text!])
        
        
        let alert = UIAlertController(title: "Clientes", message: "Cliente guardado.", preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)

        }
        
    }
    
  
    func limpiar() {
        telefono.text = ""
        nombre.text = ""
        direccion.text = ""
        email.text = ""
        telefono.select(nil)
    }
    
    @IBAction func botonEliminar(_ sender: Any) {
        let alert = UIAlertController(title: "¿Eliminar?", message: "¿Eliminar a: \(telefono.text!)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (UIAlertAction) in
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("Clientes").child(self.telefono.text!).setValue(nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)

        }))
        
        self.present(alert, animated: true)
        
        
        
        
        
        
        
        
        
        
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if cliente != nil {
            telefono.text = cliente!.value(forKey: "telefono") as? String
            nombre.text = cliente!.value(forKey: "nombre") as? String
            direccion.text = cliente!.value(forKey: "direccion") as? String
            email.text = cliente!.value(forKey: "email") as? String
            telefono.isEnabled = false
            botonEliminar.isHidden = false
            cliente = nil
        }
        else {
            limpiar()
            telefono.isEnabled = true
            botonEliminar.isHidden = true
        }
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
