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
            ref.child("Productos").child(self.codigo!).setValue(nil)
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
            newKey = ref.child("Productos").childByAutoId()
        }
        else {
            newKey = ref.child("Productos").child(codigo!)
        }
        newKey.setValue([
            "nombre":nombre.text,
            "marca":marca.text,
            "talla":talla.text,
            "costo":costo.text,
            "costoVenta":costoVenta.text,
            "existencia":existencia.text
            ])
        codigo = newKey.key
        
        let alert = UIAlertController(title: "Productos", message: "Producto guardado.", preferredStyle: .actionSheet)
        self.present(alert, animated: true)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if producto != nil {
            codigo =  producto!.value(forKey: "codigo") as? String
            nombre.text = producto!.value(forKey: "nombre") as? String
            marca.text = producto!.value(forKey: "marca") as? String
            talla.text = producto!.value(forKey: "talla") as? String
            costo.text = producto!.value(forKey: "costo") as? String
            costoVenta.text = producto!.value(forKey: "costoVenta") as? String
            existencia.text = producto!.value(forKey: "existencia") as? String
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
