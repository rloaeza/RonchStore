//
//  GastoVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 05/05/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import Firebase


class GastoVC: UIViewController {

    var valores: [NSDictionary] = []
    var codigo: String? = nil


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference().child(Configuraciones.keyGastos).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.tableView.reloadData()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func agregarGasto(_ sender: Any) {
        var usuario: String = ""
        
        var alert: UIAlertController
        alert = UIAlertController(title: "Gasto", message: "Introduce el nomnbre del nuevo gasto", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .emailAddress
            
        }
        
        alert.addAction(UIAlertAction(title: "Agregar", style: .default, handler: { [weak alert] (_) in
            let tfUsuario = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            usuario = tfUsuario!.text!
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
             
            
            self.codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyGastos, Child: self.codigo, KeyValue: Configuraciones.keyNombre, Value: usuario)
             
             Configuraciones.alert(Titulo: "Usuario", Mensaje: "Usuario guardado", self, popView: false)
            
            
            
            
            
            
        }))
                
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive) { (alertAction) in })
        
        present(alert, animated: true)
        
    }
    
    @IBAction func AgregarGastoLista(_ sender: Any) {
        
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
extension GastoVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ListaCelda", for: indexPath)
        
        let cliente: String? = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String ?? nil
        
        if cliente != nil {
            celda.textLabel?.text = cliente ?? ""
        }
        else {
            celda.textLabel?.text =  "Gasto no definido"
        }
        
        
        return celda
        
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
             if (editingStyle == .delete) {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child(Configuraciones.keyGastos).child(valores[indexPath.row].value(forKey: "key") as! String).setValue(nil)
                valores.remove(at: indexPath.row)
                self.tableView.reloadData()
             }
         }
}


