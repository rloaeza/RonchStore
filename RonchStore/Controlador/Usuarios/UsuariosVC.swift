//
//  UsuariosVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/19/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import Firebase

class UsuariosVC: UIViewController {
    
    var valores: [NSDictionary] = []
    @IBAction func botonAgregarUsuario(_ sender: Any) {
        
        var usuario: String = ""
        var clave: String = ""
        var alert: UIAlertController
        alert = UIAlertController(title: "Usuario", message: "Introduce el nomnbre del usuario", preferredStyle: .alert)
        alert.addTextField { (textField) in
            //textField.text = ""
            textField.keyboardType = .emailAddress
            
        }
        
        
        
        alert.addTextField { (textField) in
            //textField.text = ""
            textField.isSecureTextEntry = true
            textField.textContentType = .password
        }
        alert.addAction(UIAlertAction(title: "Admin", style: .default, handler: { [weak alert] (_) in
            let tfUsuario = alert?.textFields![0] // Force unwrapping because we know it exists.
            let tfClave = alert?.textFields![1] // Force unwrapping because we know it exists.
            usuario = tfUsuario!.text!
            clave = tfClave!.text!
            Auth.auth().createUser(withEmail: usuario, password: clave, completion: { (result, error) in
                if error == nil {
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    let newKey: DatabaseReference!
                   
                    newKey = ref.child(Configuraciones.keyUsuarios).child(result!.user.uid)
                    newKey.setValue( [Configuraciones.keyNombre:usuario,
                       Configuraciones.keyAdmin:true])
                    
                    Configuraciones.alert(Titulo: "Usuario", Mensaje: "Usuario guardado", self, popView: false)
                }
                
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "User", style: .default, handler: { [weak alert] (_) in
            let tfUsuario = alert?.textFields![0] // Force unwrapping because we know it exists.
            let tfClave = alert?.textFields![1] // Force unwrapping because we know it exists.
            usuario = tfUsuario!.text!
            clave = tfClave!.text!
            //Auth.auth().createUser(withEmail: usuario, password: clave, completion: nil)
            
            Auth.auth().createUser(withEmail: usuario, password: clave, completion: { (result, error) in
                if error == nil {
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    let newKey: DatabaseReference!
                   
                    newKey = ref.child(Configuraciones.keyUsuarios).child(result!.user.uid)
                    newKey.setValue( [Configuraciones.keyNombre:usuario,
                       Configuraciones.keyAdmin:false])
                    
                    Configuraciones.alert(Titulo: "Usuario", Mensaje: "Usuario guardado", self, popView: false)
                }
                
            })
            
            
            
            
         
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive) { (alertAction) in })
        
        present(alert, animated: true)
        
    }
    @IBOutlet weak var tableViewController: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child(Configuraciones.keyUsuarios).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.tableViewController.reloadData()
        }
    }
    

    
}

extension UsuariosVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "UsuarioCelda", for: indexPath)
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        let isAdmin = valores[indexPath.row].value(forKey: Configuraciones.keyAdmin) as? Bool
        celda.textLabel?.text = "\(nombre!)"
        if isAdmin! {
            celda.detailTextLabel?.text = "Admin"
        }
        else {
            celda.detailTextLabel?.text = "User"
        }
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyUsuarios).child(valores[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
}


extension UsuariosVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        //delegate?.tallaSeleccionada(nombre: valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String)
        //self.navigationController?.popViewController(animated: true)
        
    }
}
