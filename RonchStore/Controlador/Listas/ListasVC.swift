//
//  ListasVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 06/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListasVC: UIViewController {

    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var textoSeleccionado: String = ""

    
    @IBOutlet weak var tablaVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        valores = Datos.getListas(Patron: "")
        
    }
    private func actualizarDatos() {
           
           valoresParaMostrar = Datos.getProductos(Patron: textoSeleccionado)
           tablaVC.reloadData()
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

extension ListasVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ListaCelda", for: indexPath) as! ProductoCompletoCell
        let cliente: NSDictionary = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCliente) as! NSDictionary
        celda.textLabel?.text = cliente.value(forKey: Configuraciones.keyNombre) as? String ?? ""
        
        
        return celda
        
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
}

