//
//  ClientesVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/13/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ClientesVC: UIViewController {
    
    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var textoSeleccionado: String = ""
    
    
    @IBOutlet weak var tableViewClientes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child(Configuraciones.keyClientes)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.actualizarDatos()
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClienteAgregarSegue",
        let vc = segue.destination as? ClienteAgregarVC {
            vc.cliente = sender as? NSDictionary
        }
    }
    
    private func actualizarDatos() {
        valoresParaMostrar.removeAll()
        
        for valor in valores {
            let nombre: String = valor.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            let telefono: String = valor.value(forKey: Configuraciones.keyTelefono) as? String ?? ""
            
            
            if nombre.lowercased().contains(textoSeleccionado.lowercased())||telefono.lowercased().contains(textoSeleccionado.lowercased())||textoSeleccionado.isEmpty{
                valoresParaMostrar.append(valor)
            }
        }
        
        tableViewClientes.reloadData()
    }

}
extension ClientesVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ClienteCelda", for: indexPath)
        celda.textLabel?.text = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        celda.detailTextLabel?.text = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyTelefono) as? String
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyClientes).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
            
         
            
            
            Configuraciones.eliminarFoto(Reference: Storage.storage().reference(), KeyNode: Configuraciones.keyClientes, Child: valores[indexPath.row].value(forKey: "key") as! String)
            Configuraciones.eliminarFoto(Reference: Storage.storage().reference(), KeyNode: Configuraciones.keyCasas, Child: valores[indexPath.row].value(forKey: "key") as! String)
            
            
            
        }
    }
    
}

extension ClientesVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ClienteAgregarSegue", sender: valoresParaMostrar[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ClientesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
  
  
}
