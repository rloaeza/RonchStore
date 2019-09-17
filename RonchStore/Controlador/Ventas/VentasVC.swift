//
//  VentasVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/17/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VentasVC: UIViewController {
    var ventas: [NSDictionary] = []
    var pagado = 0.0
    @IBOutlet weak var tableViewVentas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child(Configuraciones.keyVentasBorrador).queryOrdered(byChild: "\(Configuraciones.keyCliente)/\(Configuraciones.keyNombre)")
        
        ref.observe(.value) { (DataSnapshot) in
            self.ventas.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as! NSDictionary
                    dic.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.ventas.append(dic)
                }
            }
            self.tableViewVentas.reloadData()
        
        }
        
      
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AgregarVentaSegue",
            let vc = segue.destination as? VentaAgregarVC {
            vc.venta = sender as? NSDictionary
        }
    }
    
}

extension VentasVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ventas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "VentaCelda", for: indexPath)
        
        let cliente = ventas[indexPath.row].value(forKey: Configuraciones.keyCliente) as! NSDictionary
        let fecha = ventas[indexPath.row].value(forKey: Configuraciones.keyFecha) as! String
        
        let index = fecha.index(fecha.startIndex, offsetBy: 9)

        let fecha2 = fecha[...index]
        
        
        celda.textLabel?.text = cliente.value(forKey: Configuraciones.keyNombre) as? String
        celda.detailTextLabel?.text = String( fecha2 )
        return celda
    
    }
}



extension VentasVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AgregarVentaSegue", sender: ventas[indexPath.row] as NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
