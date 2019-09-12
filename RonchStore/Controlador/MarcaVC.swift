//
//  MarcaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/9/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol MarcaVCDelegate {
    func marcaSeleccionada(nombre: String)
}


class MarcaVC: UIViewController {
    
    var delegate: MarcaVCDelegate?
    
    @IBOutlet weak var marcaViewController: UITableView!
    
    var valores: [NSDictionary] = []

    @IBAction func botonAgregar(_ sender: Any) {
        var marca: String = ""
        
        
        var alert: UIAlertController
        
        
        alert = UIAlertController(title: "Marca", message: "Introduce el nomnbre de la marca", preferredStyle: .alert)
        
        
        alert.addTextField { (textField) in
            //textField.text = "Marca"
        }
      
        alert.addAction(UIAlertAction(title: "Guardar", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            marca = textField!.text!
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let newKey: DatabaseReference!
            
            newKey = ref.child(Configuraciones.keyMarca).childByAutoId()
            
            newKey.setValue([
                Configuraciones.keyNombre:marca
                ])
            
            
            Configuraciones.alert(Titulo: "Marcas", Mensaje: "Marca guardada", self, popView: false)
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive) { (alertAction) in })
        
        present(alert, animated: true)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let ref = Database.database().reference().child(Configuraciones.keyMarca).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.marcaViewController.reloadData()
        }

    }
    

}


extension MarcaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "MarcaCelda", for: indexPath)
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        celda.textLabel?.text = "\(nombre!)"
        celda.detailTextLabel?.text = valores[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyMarca).child(valores[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
}


extension MarcaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        delegate?.marcaSeleccionada(nombre: valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String)
        self.navigationController?.popViewController(animated: true)

        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}
