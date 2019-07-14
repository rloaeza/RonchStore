//
//  ClientesVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/13/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClientesVC: UIViewController {
    var clientes: [String] = []
    var detalles: [String] = []
    @IBOutlet weak var tableViewClientes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Clientes")
        
        ref.observe(.value) { (DataSnapshot) in
            //print(DataSnapshot.value as Any)
            var clientesNuevos: [String] = []
            var detallesNuevos: [String] = []
            for child in DataSnapshot.children {
                
                if let snap = child as? DataSnapshot {
                    
                    
                    for field in snap.children {
                        if let val = field as? DataSnapshot {
                            if val.key == "nombre" {
                                clientesNuevos.append(val.value as! String)
                                
                                detallesNuevos.append(snap.key as! String)
                            }
                            
                        }
                    }
                    

                }
                
            }
            self.clientes = clientesNuevos
            
            
            self.detalles = detallesNuevos
            self.tableViewClientes.reloadData()
        }

        // Do any additional setup after loading the view.
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
extension ClientesVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ClienteCelda", for: indexPath)
        
        celda.textLabel?.text = clientes[indexPath.row]
        celda.detailTextLabel?.text = detalles[indexPath.row]
        return celda
    }
    
    
}
