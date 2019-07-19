//
//  PedidosVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PedidosVC: UIViewController {
    @IBOutlet weak var tableViewPedidos: UITableView!
    var pedidos: [NSDictionary] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                let ref = Database.database().reference().child(Configuraciones.keyPedidos).queryOrdered(byChild: "\(Configuraciones.keyCliente)/\(Configuraciones.keyNombre)")
        ref.observe(.value) { (DataSnapshot) in
            self.pedidos.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as! NSDictionary
                    dic.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.pedidos.append(dic)
                }
            }
            self.tableViewPedidos.reloadData()
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AgregarPedidoSegue",
            let vc = segue.destination as? PedidoAgregarVC {
            vc.pedido = sender as? NSDictionary
        }
        
    }

}



extension PedidosVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "PedidoCelda", for: indexPath)
        
        
        let cliente = pedidos[indexPath.row].value(forKey: Configuraciones.keyCliente) as! NSDictionary
        let productos = pedidos[indexPath.row].value(forKey: Configuraciones.keyProductos) as! [NSDictionary]
    
        var listos = 0
        for producto: NSDictionary  in productos {
            if producto.value(forKey: Configuraciones.keyStatus) as! String == "OK" {
                listos += 1
            }
        }
    
    
        celda.textLabel?.text = cliente.value(forKey: Configuraciones.keyNombre) as? String
        celda.detailTextLabel?.text = "\(listos) / \(productos.count) "
        return celda
    }
}


extension PedidosVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AgregarPedidoSegue", sender: pedidos[indexPath.row] as NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
