//
//  ListasVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 06/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListasVC: UIViewController {

    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var textoSeleccionado: String = ""

    @IBOutlet weak var tableViewLista: UITableView!
    
    @IBOutlet weak var tablaVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child(Configuraciones.keyListas)
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as! NSDictionary
                    dic.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.insert(dic, at: 0)
                }
            }
            self.actualizarDatos()
        
        }
        
        
        
    }
    private func actualizarDatos() {
           valoresParaMostrar = valores
           tablaVC.reloadData()
       }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AgregarListaSegue",
            let vc = segue.destination as? ListaAgregarVC {
            vc.lista = sender as? NSDictionary
        }
    }
    

}

extension ListasVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ListaCelda", for: indexPath)
        
        let cliente: NSDictionary? = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCliente) as? NSDictionary ?? nil
        
        if cliente != nil {
            celda.textLabel?.text = cliente?.value(forKey: Configuraciones.keyNombre) as? String ?? ""
        }
        else {
            celda.textLabel?.text =  "Cliente no definido"
        }
        
        
        return celda
        
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             if (editingStyle == .delete) {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child(Configuraciones.keyListas).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
                
                valoresParaMostrar.remove(at: indexPath.row)
                self.tableViewLista.reloadData()

             }
         }
}

extension ListasVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AgregarListaSegue", sender: valoresParaMostrar[indexPath.row] as NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
