//
//  ProductosVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProductosVC: UIViewController {
    var valores: [NSDictionary] = []

    @IBOutlet weak var productosViewControler: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let ref = Database.database().reference().child(Configuraciones.keyProductos).queryOrdered(byChild: Configuraciones.keyMarca)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.productosViewControler.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductoAgregarSegue",
            let vc = segue.destination as? ProductoAgregarVC {
            vc.producto = sender as? NSDictionary
        }
    }
}



extension ProductosVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        let talla = valores[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String
        celda.textLabel?.text = "\(nombre!) (\(talla!))"
        celda.detailTextLabel?.text = valores[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String
        return celda
    }
}


extension ProductosVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

