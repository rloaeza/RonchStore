//
//  VentasArchivadasVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 12/07/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VentasArchivadasVC: UIViewController {
    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var textoSeleccionado: String = ""
    
    var pagado = 0.0
    var mostrarSoloDeudas: Bool! = false
    @IBOutlet weak var tableViewVentas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let ref = Database.database().reference().child(Configuraciones.keyVentasArchivadas).queryOrdered(byChild: "\(Configuraciones.keyContador)")
        
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
                    if Funciones.ventaAtrasada(Fecha: valor.value(forKey: Configuraciones.keyFechaCobro) as? String ?? "2020-01-01 00:00") > 0 {
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

extension VentasArchivadasVC:UITableViewDataSource {
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
        
        if mostrarSoloDeudas {

            switch Funciones.ventaAtrasada(Fecha: valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyFechaCobro) as? String ?? "2020-01-01 00:00") {
            case 0:
                celda.AlertaOK.isHidden = false
                celda.AlertaHoy.isHidden = true
                celda.AlertaDias.isHidden = true
                
                break
            case 1:
                celda.AlertaOK.isHidden = true
                celda.AlertaHoy.isHidden = false
                celda.AlertaDias.isHidden = true
                break
            case 2:
                celda.AlertaOK.isHidden = true
                celda.AlertaHoy.isHidden = true
                celda.AlertaDias.isHidden = false
                break
            default:
                break
            }
        }
        else {
            celda.AlertaOK.isHidden = true
            celda.AlertaHoy.isHidden = true
            celda.AlertaDias.isHidden = true
        }
        return celda
    
    }
}



extension VentasArchivadasVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
           
           
        let restaurar = UITableViewRowAction(style: .normal, title: Configuraciones.txtRestaurar) { (action, indexPath) in
              
            let alertaConfirmacion = UIAlertController(title: "Advertencia", message: "Restaurar venta # \(self.valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyContador)!)", preferredStyle: UIAlertController.Style.alert)

            alertaConfirmacion.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                
                let ventaArchivada = self.valoresParaMostrar[indexPath.row]
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                Configuraciones.guardarValorDirecto(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, KeyValue: nil, Value: ventaArchivada)
                
                ref.child(Configuraciones.keyVentasArchivadas).child(self.valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
            }))

            alertaConfirmacion.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                return
            }))

            self.present(alertaConfirmacion, animated: true, completion: nil )
            
            
            
            
               
           }
        return [restaurar]
    }

}
extension VentasArchivadasVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
  
  
}
