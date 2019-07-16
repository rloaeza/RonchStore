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
    var valores: [NSDictionary] = []
    
    @IBOutlet weak var tableViewClientes: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Clientes")
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    self.valores.append(dic!)
                }
            }
            self.tableViewClientes.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClienteAgregarSegue",
        let vc = segue.destination as? ClienteAgregarVC {
            vc.cliente = sender as? NSDictionary
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
extension ClientesVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ClienteCelda", for: indexPath)
        celda.textLabel?.text = valores[indexPath.row].value(forKey: "nombre") as? String
        celda.detailTextLabel?.text = valores[indexPath.row].value(forKey: "telefono") as? String
        return celda
    }
    
    
}

extension ClientesVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ClienteAgregarSegue", sender: valores[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
