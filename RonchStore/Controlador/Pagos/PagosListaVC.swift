//
//  PagosListaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MessageUI

class PagosListaVC: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var ref: DatabaseReference!
    var venta: NSDictionary? = nil
    var cliente: NSDictionary? = nil
    var pagos: [NSDictionary] = []
    var codigo: String? = nil
    var pagosFinalizados: Bool = false
    var pagoActual: NSDictionary? = nil
    var totalPagos: Double = 0.0
    var anticipo: Double = 0.0
    var totalVenta: Double = 0.0
    var isAdmin: Bool = true
    var idPagoEnviarMensaje: Int? = nil
    
    @IBOutlet weak var tableViewController: UITableView!
    @IBOutlet weak var labelDescripcion: UITextView!
    @IBOutlet weak var botonProductos: UIButton!
    //@IBOutlet weak var botonCliente: UITextField!
    @IBOutlet weak var botonFinalizar: UIButton!
    @IBOutlet weak var botonCliente: UIButton!
    
    @IBAction func botonEnviarPago(_ sender: Any) {
        if pagoActual != nil {
            enviarPagoSMS(Pago: pagoActual!)
        }
    }
    @IBAction func botonFinalizar(_ sender: Any) {
        if !pagosFinalizados {
            botonFinalizar.isHidden = true
            pagosFinalizados = true
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagosFinalizados, Value: pagosFinalizados)
            venta?.setValue(true, forKey: Configuraciones.keyPagosFinalizados)
        }
    }
    
    func enviarPagoSMS(Pago pago: NSDictionary) {
        if MFMessageComposeViewController.canSendText() {
            let fechaVenta = Configuraciones.fechaReducida(Fecha: venta?.value(forKey: Configuraciones.keyFecha) as? String ?? "2020-01-01 00:00")

            let ticket = String(self.venta?.value(forKey: Configuraciones.keyContador) as? Int ?? 0)
            let total = self.venta?.value(forKey: Configuraciones.keyTotal) as! Double
            let fechaPago = pago.value(forKey: Configuraciones.keyFecha)
            let monto = pago.value(forKey: Configuraciones.keyPago)
            let apellidos = cliente?.value(forKey: Configuraciones.keyApellidos) as? String ?? "Mostrador"
        
            totalPagos = Configuraciones.calcularTotalPagos(Pagos: pagos)
            let saldo: Double = total - (totalPagos + anticipo)
            var mensaje: String = Configuraciones.txtMensajeAbono
            mensaje = mensaje.replacingOccurrences(of: "$fecha", with: fechaVenta)
            mensaje = mensaje.replacingOccurrences(of: "$ticket", with: ticket)
            mensaje = mensaje.replacingOccurrences(of: "$cliente", with: apellidos)
            mensaje = mensaje.replacingOccurrences(of: "$abono", with: "\(monto!)")
            mensaje = mensaje.replacingOccurrences(of: "$fAbono", with: "\(fechaPago!)")
            mensaje = mensaje.replacingOccurrences(of: "$total", with: String(total) )
            mensaje = mensaje.replacingOccurrences(of: "$totAbonos", with: String(totalPagos+anticipo) )
            mensaje = mensaje.replacingOccurrences(of: "$saldo", with: String(saldo) )

            let messageVC = MFMessageComposeViewController()
            messageVC.body = mensaje
            let cliente = self.venta?.value(forKey: Configuraciones.keyCliente) as! NSDictionary
            messageVC.recipients = [cliente.value(forKey: Configuraciones.keyTelefono) as! String]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
            

        }
        else {
            Configuraciones.alert(Titulo: "Alerta", Mensaje: "No es posible enviar mensajes", self, popView: false)
            pagoActual?.setValue(false, forKey: Configuraciones.keyPagoMensajeEnviado)
            _ = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagos, Value: pagos)
            tableViewController.reloadData()
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var msg = ""
        switch (result) {
        case .cancelled:
            msg = "Mensaje cancelado"
            pagoActual?.setValue(false, forKey: Configuraciones.keyPagoMensajeEnviado)
        case .failed:
            msg = "Error al enviar"
            pagoActual?.setValue(false, forKey: Configuraciones.keyPagoMensajeEnviado)
        case .sent:
            msg = "Mensaje enviado satisfactoriamente"
            pagoActual?.setValue(true, forKey: Configuraciones.keyPagoMensajeEnviado)
            
        default:
            break
        }
        
         _ = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagos, Value: pagos)
        tableViewController.reloadData()

        dismiss(animated: true, completion: nil)
        Configuraciones.alert(Titulo: "Mensaje", Mensaje: msg, self, popView: false)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if venta != nil {
            botonFinalizar.isHidden = !isAdmin
            
            cliente = venta?.value(forKey: Configuraciones.keyCliente) as? NSDictionary
            botonCliente.setTitle(cliente?.value(forKey: Configuraciones.keyNombre) as? String, for: .normal)
            
            let productos = venta?.value(forKey: Configuraciones.keyProductos) as! [NSDictionary]
            botonProductos.setTitle("\(productos.count) Productos", for: .normal)
            
            codigo = venta?.value(forKey: Configuraciones.keyId) as? String
            
            pagosFinalizados = false
            if let f = venta?.value(forKey: Configuraciones.keyPagosFinalizados) as? Bool {
                pagosFinalizados = f
            } else {
             codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagosFinalizados, Value: pagosFinalizados)
            }
            if pagosFinalizados {
                botonFinalizar.isHidden = true
            }
            if let ps = venta?.value(forKey: Configuraciones.keyPagos) as? [NSDictionary] {
                pagos = ps
            }
            calcularTotales()
        }
    }
    
    func calcularTotales() {
        totalPagos = Configuraciones.calcularTotalPagos(Pagos: pagos)
        anticipo = venta?.value(forKey: Configuraciones.keyPagoInicialV) as! Double
        totalVenta = venta?.value(forKey: Configuraciones.keyTotal) as! Double
        
        labelDescripcion.text = "Actualmente se han pagado $\(totalPagos+anticipo) de un total de $\(totalVenta)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductosVendidosDesdePagosListaSegue",
            let vc = segue.destination as? ProductosVentaVC {
            vc.valores = venta?.value(forKey: Configuraciones.keyProductos) as! [NSDictionary]
        }
        
        if segue.identifier == "UbicacionClienteDesdePagosListaSegue",
            let vc = segue.destination as? ClienteUbicacionVC {
            vc.cliente = venta?.value(forKey: Configuraciones.keyCliente) as? NSDictionary            
        }
        
        if segue.identifier == "PagoNuevoDesdePagosRealizados",
            let vc = segue.destination as? PagoNuevoVC {
            //vc.lblCliente.text = cliente?.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            vc.venta = venta
            vc.delegate = self
            
            
        }
    }
}
extension PagosListaVC:PagoNuevoVCDelegate {
    func pagoNuevo(monto: Double, concepto: String) {
        let fechaPago = Configuraciones.fecha()

        self.pagoActual = [Configuraciones.keyPago:String(monto), Configuraciones.keyFecha:fechaPago, Configuraciones.keyConceptoPago:concepto, Configuraciones.keyPagoMensajeEnviado:true]
        self.pagos.append(self.pagoActual!)

        _ = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagos, Value: pagos)
        self.venta?.setValue(self.pagos, forKey: Configuraciones.keyPagos)
        self.idPagoEnviarMensaje = self.pagos.count - 1
        self.enviarPagoSMS(Pago: self.pagoActual!)
        self.calcularTotales()
        self.tableViewController.reloadData()
    }
    
    
}


extension PagosListaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "PagoCelda", for: indexPath) as! PagoCell
        let monto = "$ \(pagos[indexPath.row].value(forKey: Configuraciones.keyPago) as? String ?? "0") "
        let fecha = pagos[indexPath.row].value(forKey: Configuraciones.keyFecha) as? String
        let concepto = pagos[indexPath.row].value(forKey: Configuraciones.keyConceptoPago) as? String
        let pagoMensajeEnviado = pagos[indexPath.row].value(forKey: Configuraciones.keyPagoMensajeEnviado) as? Bool ?? false
        
        celda.Monto.text = monto
        celda.Fecha.text = fecha
        celda.Descripcion.text = concepto
        
        if pagoMensajeEnviado {
            celda.Mensaje.isHidden = true
        }
        else {
            celda.Mensaje.isHidden = false
        }
        return celda
    }
    
   
}


extension PagosListaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pagoActual = pagos[indexPath.row]
    }
}
