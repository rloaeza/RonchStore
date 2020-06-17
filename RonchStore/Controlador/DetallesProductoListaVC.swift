//
//  DetallesProductoListaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 16/06/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol DetallesProductoListaVCDelegate {
    func valorSeleccionado(nombre: String, detalle: String)
}


class DetallesProductoListaVC: UIViewController {
    var delegate: DetallesProductoListaVCDelegate?
    var valores: [NSDictionary] = []
    
    var titulo: String? = nil
    var detalleKey: String? = nil
    

    @IBOutlet weak var tablaValores: UITableView!
    
    @IBAction func botonAgregar(_ sender: Any) {
        var valor: String = ""
        var alert: UIAlertController
        alert = UIAlertController(title: self.title, message: "Introduce el nuevo valor", preferredStyle: .alert)
        alert.addTextField { (textField) in
            //textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Guardar", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            valor = textField!.text!
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let newKey: DatabaseReference!
            
            newKey = ref.child(self.detalleKey!).childByAutoId()
            
            newKey.setValue([
                Configuraciones.keyNombre:valor
                ])
            
            
            Configuraciones.alert(Titulo: self.title!, Mensaje: "Valor guardado", self, popView: false)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive) { (alertAction) in })
        
        present(alert, animated: true)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference().child(detalleKey!).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.tablaValores.reloadData()
        }
        
    }
    
    
}


extension DetallesProductoListaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        celda.textLabel?.text = "\(nombre!)"
        celda.detailTextLabel?.text = valores[indexPath.row].value(forKey: detalleKey!) as? String
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(detalleKey!).child(valores[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
}


extension DetallesProductoListaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        delegate?.valorSeleccionado(nombre: valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String, detalle: self.detalleKey!)
        self.navigationController?.popViewController(animated: true)
        
    }
}





