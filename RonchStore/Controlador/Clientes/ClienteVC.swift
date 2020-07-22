//
//  ClienteVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/12/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//


import UIKit
import FirebaseDatabase

protocol ClienteVCDelegate {
    func clienteSeleccionado(cliente: NSDictionary)
}


class ClienteVC: UIViewController {
    
    var delegate: ClienteVCDelegate?
    var valores: [NSDictionary] = []
    
    @IBOutlet weak var clienteViewController: UITableView!
    
    
    @IBAction func botonAgregar(_ sender: Any) {
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let ref = Database.database().reference().child(Configuraciones.userID + Configuraciones.keyClientes).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.clienteViewController.reloadData()
        }
        
    }
    
    
}


extension ClienteVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ClienteCelda", for: indexPath)
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        celda.textLabel?.text = "\(nombre!)"
        celda.detailTextLabel?.text = valores[indexPath.row].value(forKey: Configuraciones.keyTelefono) as? String
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyClientes).child(valores[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
}


extension ClienteVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        delegate?.clienteSeleccionado(cliente: valores[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
}
