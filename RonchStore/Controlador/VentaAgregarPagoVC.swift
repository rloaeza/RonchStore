//
//  VentaAgregarPagoVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/17/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase


class VentaAgregarPagoVC: UIViewController  {
    var venta: NSDictionary?
    var cliente: NSDictionary?
    var productosVenta: [NSDictionary] = []
    var pagosVenta: [NSDictionary] = []
    var faltante: Double?
    
    @IBOutlet weak var nombreCliente: UITextField!
    @IBOutlet weak var totalVenta: UITextField!
    @IBOutlet weak var abono: UITextField!
    @IBOutlet weak var abonado: UITextField!
    
    @IBOutlet weak var botonGuardar: UIButton!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBOutlet weak var tableViewPagos: UITableView!
    
    @IBAction func botonGuardar(_ sender: Any) {
        
        if faltante == 0 {
            
            let ref = Database.database().reference().child(Configuraciones.keyVentasFinalizadas).child(venta?.value(forKey: Configuraciones.keyId) as! String)
            ref.setValue(venta)
            let ref2 = Database.database().reference().child(Configuraciones.keyVentasActivas).child(venta?.value(forKey: Configuraciones.keyId) as! String)
            ref2.setValue(nil)
            
            Configuraciones.alert(Titulo: "Venta", Mensaje: "Venta finalizada", self, popView: true)
            return
        }
        if abono.text!.count == 0 {
            Configuraciones.alert(Titulo: "Pagos", Mensaje: "No hay abono", self, popView: false)

            return
        }
        
        if faltante! < Double( abono.text! )! {
            Configuraciones.alert(Titulo: "Pagos", Mensaje: "La cantidad es superior", self, popView: false)
            return
        }
        
        pagosVenta.append([Configuraciones.keyPago : Double(abono.text!)!, Configuraciones.keyFecha : Configuraciones.fecha()])
    
        let abonadoDouble = Double( abonado.text! )!
        let abonoDouble = Double ( abono.text! )!
        let abonadoTotal = abonadoDouble + abonoDouble
        let ref = Database.database().reference().child(Configuraciones.keyVentasActivas).child(venta?.value(forKey: Configuraciones.keyId) as! String)
        
        ref.child(Configuraciones.keyPagos).setValue(pagosVenta)
        ref.child(Configuraciones.keyAbonado).setValue(abonadoTotal)
        
        
        Mensajes().sendSMS(Telefono: cliente!.value(forKey: Configuraciones.keyTelefono) as! String, Mensaje: "Pago: \(abono.text!) de \(totalVenta.text!)", self)

        Configuraciones.alert(Titulo: "Pagos", Mensaje: "Pago agregado", self, popView: true)
     
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cliente = venta?.value(forKey: Configuraciones.keyCliente) as? NSDictionary
        productosVenta = venta?.value(forKey: Configuraciones.keyProductos) as! [NSDictionary]
        pagosVenta = venta?.value(forKey: Configuraciones.keyPagos) as! [NSDictionary]
        nombreCliente.text = cliente?.value(forKey: Configuraciones.keyNombre) as? String
        totalVenta.text = String(venta?.value(forKey: Configuraciones.keyTotal) as! Double)
        abonado.text = String(venta?.value(forKey: Configuraciones.keyAbonado) as! Double)
        faltante = (venta?.value(forKey: Configuraciones.keyTotal) as! Double) - (venta?.value(forKey: Configuraciones.keyAbonado) as! Double)
        
        abono.placeholder = String( faltante! )
        
        if faltante == 0 {
            botonGuardar.setTitle("Terminar venta", for: .normal)
        }
        
        
    }

    
}
extension VentaAgregarPagoVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewProductos {
            return productosVenta.count
        }
        
        if tableView == tableViewPagos {
            return pagosVenta.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewProductos {
            let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
            let nombre = productosVenta[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String
            let costo = productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String
            let marca = productosVenta[indexPath.row].value(forKey: Configuraciones.keyMarca) as! String
            let talla = productosVenta[indexPath.row].value(forKey: Configuraciones.keyTalla) as! String
            celda.textLabel?.text = String(indexPath.row + 1) + ") \(nombre) (\(marca)/\(talla))"
            celda.detailTextLabel?.text = costo
            return celda
        }
        if tableView == tableViewPagos {
            let celda = tableView.dequeueReusableCell(withIdentifier: "PagoCelda", for: indexPath)
            let pago = String(pagosVenta[indexPath.row].value(forKey: Configuraciones.keyPago) as! Double)
            let fecha = pagosVenta[indexPath.row].value(forKey: Configuraciones.keyFecha) as! String
            celda.textLabel?.text = String(indexPath.row + 1) + ") " + pago
            celda.detailTextLabel?.text = fecha
            return celda
        }
        return tableView.dequeueReusableCell(withIdentifier: "PagoCelda", for: indexPath)
    }
}
