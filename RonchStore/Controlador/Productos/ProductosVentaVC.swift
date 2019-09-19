//
//  ProductosVentaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/19/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import Firebase

class ProductosVentaVC: UIViewController {
    
    var valores: [NSDictionary] = []

    @IBOutlet weak var tablaViewController: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tablaViewController.reloadData()
        
        
    }


}



extension ProductosVentaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
        let nombre = valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        celda.textLabel?.text = "\(indexPath.row + 1)) \(nombre!)"
        celda.detailTextLabel?.text = valores[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String
        return celda
    }
    

}

extension ProductosVentaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        //delegate?.tallaSeleccionada(nombre: valores[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String)
        //self.navigationController?.popViewController(animated: true)
        
    }
}
