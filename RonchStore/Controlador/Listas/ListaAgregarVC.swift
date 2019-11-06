//
//  ListaAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 06/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListaAgregarVC: UIViewController {

    var cliente: NSDictionary = [:]
    var codigo: String? = nil
    var ref: DatabaseReference!


    
    @IBOutlet weak var botonCliente: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClienteDesdeNuevaLista",
               let vc = segue.destination as? ClienteVC {
               vc.delegate = self

           }
    }
    

}

extension ListaAgregarVC: ClienteVCDelegate {
    func clienteSeleccionado(cliente: NSDictionary) {
        botonCliente.setTitle(cliente.value(forKey: Configuraciones.keyNombre) as? String , for: .normal)
        self.cliente = cliente
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyListas, Child: codigo, KeyValue: Configuraciones.keyCliente, Value: cliente)
 
        
    }
}
