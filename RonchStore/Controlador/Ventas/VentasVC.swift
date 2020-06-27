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
    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var textoSeleccionado: String = ""
    
    var pagado = 0.0
    var mostrarSoloDeudas: Bool! = false
    @IBOutlet weak var tableViewVentas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let ref = Database.database().reference().child(Configuraciones.keyVentasBorrador).queryOrdered(byChild: "\(Configuraciones.keyContador)")
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as! NSDictionary
                    dic.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.insert(dic, at: 0)
                }
            }
            self.actualizarDatos()
        
        }
        
      
    }
    
    @IBAction func mostrarSinFinalizar(_ sender: Any) {
        let select: UISwitch! = sender  as? UISwitch
        mostrarSoloDeudas = select.isOn
        actualizarDatos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AgregarVentaSegue",
            let vc = segue.destination as? VentaAgregarVC {
            vc.venta = sender as? NSDictionary
        }
    }
    
    private func actualizarDatos() {
        valoresParaMostrar.removeAll()
        
        for valor in valores {
            let cliente: NSDictionary = (valor.value(forKey: Configuraciones.keyCliente) as? NSDictionary)!
            
            let nombre: String = cliente.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            let telefono: String = cliente.value(forKey: Configuraciones.keyTelefono) as? String ?? ""
            let ventaTerminada: Bool = valor.value(forKey: Configuraciones.keyPagosFinalizados) as? Bool ?? false
            if nombre.lowercased().contains(textoSeleccionado.lowercased())||telefono.lowercased().contains(textoSeleccionado.lowercased())||textoSeleccionado.isEmpty{
                if mostrarSoloDeudas {
                    if !ventaTerminada {
                        valoresParaMostrar.append(valor)
                    }
                }
                else {
                    valoresParaMostrar.append(valor)
                }
                
            }
        }
        
        tableViewVentas.reloadData()
    }
    
}

extension VentasVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "VentaCelda", for: indexPath) as! VentaCell
        
        let cliente = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCliente) as! NSDictionary
        let fecha = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyFecha) as! String
        let pagosFinalizados = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyPagosFinalizados) as? Bool ?? false
        
        let nVenta = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyContador) as? Int ?? -1
        
        let index = fecha.index(fecha.startIndex, offsetBy: 9)

        let fecha2 = fecha[...index]
        
        
        //celda.textLabel?.text = cliente.value(forKey: Configuraciones.keyNombre) as? String
        //celda.detailTextLabel?.text = String( fecha2 )
        
        let total: Double = (valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyTotal) as! Double)
        
        var adeudo: Double = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyPagoInicialV) as! Double
        
        
        
        
        if let pagos = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyPagos) as? [NSDictionary] {
            for pago in pagos {
                adeudo = adeudo + (Double(pago.value(forKey: Configuraciones.keyPago) as! String)!)
            }
        }
        
        
        
        
        celda.Titulo.text = cliente.value(forKey: Configuraciones.keyNombre) as? String
        celda.Fecha.text = String( fecha2 )
        celda.Adeudo.text = "\(Configuraciones.txtAdeudo): \(String( total - adeudo ))"
        celda.Total.text = "\(Configuraciones.keyTotal): \(String( total ))"
        celda.NumVenta.text = "# \(nVenta)"
        
        celda.Adeudo.textColor = UIColor.black
        if adeudo<total&&(!pagosFinalizados) {
            celda.Adeudo.textColor = UIColor.red
        }
        
        return celda
    
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyVentasBorrador).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
        
    }
}



extension VentasVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "AgregarVentaSegue", sender: valoresParaMostrar[indexPath.row] as NSDictionary)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension VentasVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
  
  
}
