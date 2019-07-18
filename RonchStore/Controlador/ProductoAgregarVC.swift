//
//  ProductoAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProductoAgregarVC: UIViewController {
    
    var producto: NSDictionary? = nil
    var codigo: String? = nil
    
    @IBOutlet weak var botonEliminar: UIButton!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var marca: UITextField!
    @IBOutlet weak var talla: UITextField!
    @IBOutlet weak var costo: UITextField!
    @IBOutlet weak var costoVenta: UITextField!
    @IBOutlet weak var existencia: UITextField!
    
    @IBAction func botonEliminar(_ sender: Any) {
        let alert = UIAlertController(title: "¿Eliminar?", message: "¿Esta seguro de eliminar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (UIAlertAction) in
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(self.codigo!).setValue(nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
    }
    @IBAction func botonGuardar(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let newKey: DatabaseReference!
        if codigo == nil {
            newKey = ref.child(Configuraciones.keyProductos).childByAutoId()
        }
        else {
            newKey = ref.child(Configuraciones.keyProductos).child(codigo!)
        }
        newKey.setValue([
            Configuraciones.keyNombre:nombre.text,
            Configuraciones.keyMarca:marca.text,
            Configuraciones.keyTalla:talla.text,
            Configuraciones.keyCosto:costo.text,
            Configuraciones.keyCostoVenta:costoVenta.text,
            Configuraciones.keyExistencia:existencia.text
            ])
        codigo = newKey.key
        
        Configuraciones.alert(Titulo: "Productos", Mensaje: "Producto guardado", self, popView: true)

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if producto != nil {
            codigo =  producto!.value(forKey: Configuraciones.keyId) as? String
            nombre.text = producto!.value(forKey: Configuraciones.keyNombre) as? String
            marca.text = producto!.value(forKey: Configuraciones.keyMarca) as? String
            talla.text = producto!.value(forKey: Configuraciones.keyTalla) as? String
            costo.text = producto!.value(forKey: Configuraciones.keyCosto) as? String
            costoVenta.text = producto!.value(forKey: Configuraciones.keyCostoVenta) as? String
            existencia.text = producto!.value(forKey: Configuraciones.keyExistencia) as? String
            botonEliminar.isHidden = false
            producto = nil
            
        }
        else {
            codigo = nil
            nombre.text = ""
            marca.text = ""
            talla.text = ""
            costo.text = ""
            costoVenta.text = ""
            existencia.text = ""
            nombre.select(nil)
            botonEliminar.isHidden = true
        }
    }
    

}
