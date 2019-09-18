//
//  PagosListaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit

class PagosListaVC: UIViewController {
    
    var venta: NSDictionary? = nil
    var codigo: String? = nil

    @IBOutlet weak var tableViewController: UITableView!
    @IBOutlet weak var labelDescripcion: UITextView!
    @IBOutlet weak var botonProductos: UIButton!
    @IBOutlet weak var botonCliente: UITextField!
    @IBAction func botonFinalizar(_ sender: Any) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if venta != nil {
            let cliente = venta?.value(forKey: Configuraciones.keyCliente) as! NSDictionary
            botonCliente.text = cliente.value(forKey: Configuraciones.keyNombre) as! String
            
            let productos = venta?.value(forKey: Configuraciones.keyProductos) as! [NSDictionary]
            botonProductos.setTitle("\(productos.count) Productos", for: .normal)
            
            codigo = venta?.value(forKey: Configuraciones.keyId)
            
            
        }


    }
    
    

}
