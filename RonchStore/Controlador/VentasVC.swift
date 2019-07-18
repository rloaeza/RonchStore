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
    var ventasFinalizadas: [NSDictionary] = []
    var pagado = 0.0
    
    @IBOutlet weak var tableViewVentasFinalizadas: UITableView!
    @IBOutlet weak var tableViewVentas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference().child(Configuraciones.keyVentasActivas).queryOrdered(byChild: "\(Configuraciones.keyCliente)/\(Configuraciones.keyNombre)")
        
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
            
            
            let ref2 = Database.database().reference().child(Configuraciones.keyVentasFinalizadas).queryOrdered(byChild: "\(Configuraciones.keyCliente)/\(Configuraciones.keyNombre)")
            
            ref2.observe(.value) { (DataSnapshot) in
                self.ventasFinalizadas.removeAll()
                for child in DataSnapshot.children {
                    if let snap = child as? DataSnapshot {
                        let dic = snap.value as! NSDictionary                                               
                        self.ventasFinalizadas.append(dic)
                    }
                }
                self.tableViewVentasFinalizadas.reloadData()
                
            }
            
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AgregarPagoVentaSegue",
            let vc = segue.destination as? VentaAgregarPagoVC {
            
            vc.venta = sender as? NSDictionary
            
        }
    }
    
}

extension VentasVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewVentas {
            return ventas.count
        }
        if tableView == tableViewVentasFinalizadas {
            return ventasFinalizadas.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "VentaCelda", for: indexPath)
        if tableView == tableViewVentas {
            let cliente = ventas[indexPath.row].value(forKey: Configuraciones.keyCliente) as! NSDictionary
            let total = ventas[indexPath.row].value(forKey: Configuraciones.keyTotal) as! Double
            let abonado: Double = ventas[indexPath.row].value(forKey: Configuraciones.keyAbonado) as! Double
            
            celda.textLabel?.text = cliente.value(forKey: Configuraciones.keyNombre) as? String
            celda.detailTextLabel?.text = String( total-abonado )
            return celda
        }
        if tableView == tableViewVentasFinalizadas {
            let cliente = ventasFinalizadas[indexPath.row].value(forKey: Configuraciones.keyCliente) as! NSDictionary
            let abonado = ventasFinalizadas[indexPath.row].value(forKey: Configuraciones.keyAbonado) as! Double
            
            celda.textLabel?.text = cliente.value(forKey: Configuraciones.keyNombre) as? String
            celda.detailTextLabel?.text = String( abonado )
            return celda
        }
        
        return celda
    }
}



extension VentasVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AgregarPagoVentaSegue", sender: ventas[indexPath.row] as NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
