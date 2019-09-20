//
//  VentasListadoCobradorVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/19/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit

import UIKit
import FirebaseDatabase

class VentasListadoCobradorVC: UIViewController {
    var ventas: [NSDictionary] = []
    var pagado = 0.0
    
    @IBOutlet weak var tableViewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let ref = Database.database().reference().child(Configuraciones.keyVentasBorrador).queryOrdered(byChild: "\(Configuraciones.keyCliente)/\(Configuraciones.keyNombre)")
        
        let ref = Database.database().reference().child(Configuraciones.keyVentasBorrador).queryOrdered(byChild: "\(Configuraciones.keyCliente)/\(Configuraciones.keyNombre)")
        
        
        ref.observe(.value) { (DataSnapshot) in
            self.ventas.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as! NSDictionary
                    if !(dic.value(forKey: Configuraciones.keyVentaFinalizada) as! Bool) {
                        continue
                    }
                    dic.setValue(snap.key, forKey: Configuraciones.keyId)
                    
                    self.ventas.append(dic)
                }
            }
            self.tableViewController.reloadData()
            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PagosDesdeVentaCobrador",
            let vc = segue.destination as? PagosListaVC {
            vc.venta = sender as? NSDictionary
            vc.isAdmin = false
        }
    }
    
}

extension VentasListadoCobradorVC:UITableViewDataSource {
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



extension VentasListadoCobradorVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PagosDesdeVentaCobrador", sender: ventas[indexPath.row] as NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
