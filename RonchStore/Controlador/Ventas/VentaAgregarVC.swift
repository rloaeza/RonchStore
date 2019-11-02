//
//  VentaAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

import MessageUI


class VentaAgregarVC: UIViewController , MFMessageComposeViewControllerDelegate {
    var clientes: [NSDictionary] = []
    var productos: [NSDictionary] = []
    var productosVenta: [NSDictionary] = []
    var ventaFinalizada: Bool = false
    
    var pagoInicialP: Double = 30.0
    var pagoInicialV: Double = 0.0
    var pagoSemanas: Int = 6
    var pagoSemanasV: Double = 0.0
    var pagoDemora1: Double = 0.0
    var pagoDemora2: Double = 0.0
    
    var totalVenta: Double = 0
    var venta: NSDictionary? = nil
    var ref: DatabaseReference!
    var codigo: String? = nil
    var contador: Int? = nil
    
    var cliente: NSDictionary? = nil
    
    @IBOutlet weak var tfPagoInicialP: UITextField!
    @IBOutlet weak var tfPagoInicialV: UITextField!
    @IBOutlet weak var tfPagoSemanas: UITextField!
    @IBOutlet weak var tfPagoSemanasV: UITextField!
    @IBOutlet weak var tfPagoDemora1: UITextField!
    @IBOutlet weak var tfPagoDemora2: UITextField!
    @IBOutlet weak var labelDemora1: UILabel!
    @IBOutlet weak var labelDemora2: UILabel!
    @IBOutlet weak var labelDescripcionFinal: UILabel!
    
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBOutlet weak var pagado: UITextField!
    @IBOutlet weak var pickerViewClientes: UIPickerView!
    @IBOutlet weak var pickerViewProductos: UIPickerView!
    
    @IBOutlet weak var botonCliente: UIButton!
    @IBOutlet weak var botonProductos: UIButton!
    
    
    @IBOutlet weak var botonFinalizar: UIButton!
    @IBOutlet weak var botonEditar: UIButton!
    @IBOutlet weak var botonVerPagos: UIButton!
    
    
    @IBAction func finalizarVenta(_ sender: Any) {
        finalizarStatusVenta(Finalizar: true)
        
        if MFMessageComposeViewController.canSendText() {
            //let nProductos = productosVenta.count
            
            
            var mensaje = "\(Configuraciones.Titulo) \n"
            
            for p in productosVenta {
                mensaje += "  1 x \(p.value(forKey: Configuraciones.keyNombre)!) [$\(p.value(forKey: Configuraciones.keyCostoVenta)!)]\n"
            }
            
            mensaje += "Total: $\(totalVenta)\n"
            mensaje += "Anticipo: $\(tfPagoInicialV.text!)\n\n"
            mensaje += "Despues de \(labelDemora1.text!): \(tfPagoDemora1.text!)\n"
            mensaje += "Despues de \(labelDemora2.text!): \(tfPagoDemora2.text!)\n"
            
            
            let messageVC = MFMessageComposeViewController()
            messageVC.body = mensaje
            messageVC.recipients = [cliente?.value(forKey: Configuraciones.keyTelefono) as! String]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        }
        else {
            Configuraciones.alert(Titulo: "Alerta", Mensaje: "No es posible enviar mensajes", self, popView: false)
        }
        

    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var msg = ""
        switch (result) {
        case .cancelled:
            msg = "Mensaje cancelado"
        case .failed:
            msg = "Error al enviar"
        case .sent:
            msg = "Mensaje enviado satisfactoriamente"
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
        Configuraciones.alert(Titulo: "Mensaje", Mensaje: msg, self, popView: true)
    
    }
    
    
    @IBAction func editarVenta(_ sender: Any) {
        finalizarStatusVenta(Finalizar: false)
    }
    
    
    @IBAction func actualizarPagoInicial(_ sender: Any) {
        tfPagoInicialV.text = ""
        calcularCostos(Guardar: true)
    }
    
    @IBAction func actualizarPagoInicialV(_ sender: Any) {
        tfPagoInicialP.text = ""
        calcularCostos(Guardar: true)
    }
    
    @IBAction func actualizarSemanas(_ sender: Any) {
        calcularCostos(Guardar: true)
    }
    
    
    
    @IBAction func botonFinalizarVenta(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        totalVenta = 0
        productosVenta.removeAll()
        
        if venta != nil {
            codigo = venta?.value(forKey: Configuraciones.keyId) as? String
            contador = venta?.value(forKey: Configuraciones.keyContador) as? Int
            cliente = venta?.value(forKey: Configuraciones.keyCliente) as? NSDictionary
            botonCliente.setTitle(cliente?.value(forKey: Configuraciones.keyNombre) as? String, for: .normal)
            productosVenta = venta?.value(forKey: Configuraciones.keyProductos) as? [NSDictionary] ?? []
            
            for p in productosVenta {
                totalVenta += Double(p.value(forKey: Configuraciones.keyCostoVenta) as! String)!
            }
            tableViewProductos.reloadData()
            
            tfPagoInicialP.text = String(venta?.value(forKey: Configuraciones.keyPagoInicialP) as? Double ?? 0.0)
            tfPagoInicialV.text = String(venta?.value(forKey: Configuraciones.keyPagoInicialV) as? Double ?? 0.0)
            
            calcularCostos(Guardar: false)
            
            if let vf = venta?.value(forKey: Configuraciones.keyVentaFinalizada) as? Bool {
                ventaFinalizada = vf
            }
            else {
                ventaFinalizada = false
            }
            finalizarStatusVenta(Finalizar: ventaFinalizada)

        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClienteDesdeNuevaVenta",
            let vc = segue.destination as? ClienteVC {
            vc.delegate = self
        }
        
        if segue.identifier == "ProductoDesdeNuevaVenta",
            let vc = segue.destination as? ProductosListaVC {
            vc.delegate = self
        }
        
        
        if segue.identifier == "PagosDesdeNuevaVenta",
            let vc = segue.destination as? PagosListaVC {
            vc.venta = venta
        }
    }
    
    func finalizarStatusVenta(Finalizar finalizar: Bool) {
        ventaFinalizada = finalizar
        if finalizar {
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyVentaFinalizada, Value: true)
        }
        else {
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyVentaFinalizada, Value: false)
            
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagosFinalizados, Value: false)
            venta?.setValue(false, forKey: Configuraciones.keyPagosFinalizados)
        }
        
        labelDescripcionFinal.isHidden = !finalizar
        
        botonFinalizar.isHidden = finalizar
        botonFinalizar.isEnabled = !finalizar
        
        botonEditar.isHidden = !finalizar
        botonEditar.isEnabled = finalizar
        botonVerPagos.isHidden = !finalizar
        botonVerPagos.isEnabled = finalizar
        
        
        
        
        botonCliente.isEnabled = !finalizar
        botonProductos.isEnabled = !finalizar
        
        calcularTotales()
        
        
    }
    
    
    func calcularCostos(Guardar guardar: Bool) {
        total.text = "$ \(totalVenta)"
        calcularPagoInicial()
        tfPagoInicialV.text = "\(String(format: "%.1f",pagoInicialV))"
        tfPagoInicialP.text = "\(pagoInicialP)"
        calcularSemanas()
        tfPagoSemanasV.text = "$ \(String(format: "%.1f", pagoSemanasV))"
        tfPagoDemora1.text = "$ \(String(format: "%.1f", pagoDemora1))"
        tfPagoDemora2.text = "$ \(String(format: "%.1f", pagoDemora2))"
        
        
        //let d1 = Configuraciones.txtMensajeDemora.replacingOccurrences(of: "#", with: String(pagoSemanas))
        //let d2 = Configuraciones.txtMensajeDemora.replacingOccurrences(of: "#", with: String(pagoSemanas + 3))
        
        
        
        labelDemora1.text = Configuraciones.fechaMasDias( Semanas: Double(pagoSemanas) )
        labelDemora2.text = Configuraciones.fechaMasDias( Semanas: Double(pagoSemanas + 3) )
        if guardar {
            guardarValores()
        }
    }
    
    func guardarValores() {
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyProductos, Value: productosVenta)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagoSemanas, Value: pagoSemanas)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagoInicialP, Value: pagoInicialP)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyPagoInicialV, Value: pagoInicialV)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyTotal, Value: totalVenta)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFecha, Value: Configuraciones.fecha())
        
        if contador == nil {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyContador).observeSingleEvent(of: .value) { (DataSnapshot) in
                let dic  = DataSnapshot.value as! NSDictionary
                self.contador = dic.value(forKey: "Venta") as? Int ?? 0
                self.contador = self.contador! + 1
                self.codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: self.codigo, KeyValue: Configuraciones.keyContador, Value: self.contador! )
                
                Configuraciones.guardarValorDirecto(Reference: ref, KeyNode: Configuraciones.keyContador, KeyValue: "Venta", Value: self.contador!)
            }
            
        }
        
    }
    
    func calcularPagoInicial() {
        if tfPagoInicialP.text!.isEmpty {
            if tfPagoInicialV.text!.isEmpty {
                pagoInicialP = 30.0
                pagoInicialV = ( totalVenta * pagoInicialP ) / 100
            }
            else {
                pagoInicialV = Double( tfPagoInicialV.text!)!
                pagoInicialP = ( pagoInicialV * 100 ) / totalVenta
            }
        }
        else {
            pagoInicialP = Double( tfPagoInicialP.text!)!
            pagoInicialV = ( totalVenta * pagoInicialP ) / 100
        }
        
        
        
    }

    func calcularSemanas() {
        if tfPagoSemanas.text!.isEmpty {
            pagoSemanas = 6
        } else {
            pagoSemanas = Int( tfPagoSemanas.text! )!
        }
        pagoSemanasV = (totalVenta - pagoInicialV) / Double( pagoSemanas )
        
        pagoDemora1 = totalVenta * 1.2
        pagoDemora2 = pagoDemora1 * 1.2
    }
    
    func calcularFechas() {
        let formatter = DateFormatter()
        formatter.dateFormat = Configuraciones.keyDateFormat
        
        let someDateTime = formatter.date(from: "2019/11/09 22:31")
        let d = someDateTime?.addingTimeInterval(60*60*24*7)
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let dateTime = formatter.string(from: d!)
        
        Configuraciones.alert(Titulo: "Hora", Mensaje: dateTime, self, popView: false)
    }
    
    
    func calcularTotales() {
        var pagos: [NSDictionary] = []
        if let ps = venta?.value(forKey: Configuraciones.keyPagos) as?  [NSDictionary] {
            pagos = ps
        }
        
        let totalPagos = Configuraciones.calcularTotalPagos(Pagos: pagos)
        let anticipo = pagoInicialV
        
        labelDescripcionFinal.text = "Actualmente se han pagado $\(totalPagos+anticipo) de un total de $\(totalVenta)"
        
    }
    
    
}





extension VentaAgregarVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosVenta.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
        
        let nombre = productosVenta[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String
        let marca = productosVenta[indexPath.row].value(forKey: Configuraciones.keyMarca) as! String
        let talla = productosVenta[indexPath.row].value(forKey: Configuraciones.keyTalla) as! String
        let costo = productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String
        celda.textLabel?.text = String(indexPath.row + 1) + ") \(nombre) (\(marca)/\(talla))"
        celda.detailTextLabel?.text = costo
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if self.ventaFinalizada {
                Configuraciones.alert(Titulo: "Error", Mensaje: "Venta finalizada, no se puede editar", self, popView: false)
            }else {
                totalVenta -= Double(productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String)!
                productosVenta.remove(at: indexPath.row)
                self.tableViewProductos.reloadData()
                calcularCostos(Guardar: true)
            }
        }
    }
    
}


extension VentaAgregarVC: ClienteVCDelegate {
    func clienteSeleccionado(cliente: NSDictionary) {
        botonCliente.setTitle(cliente.value(forKey: Configuraciones.keyNombre) as? String , for: .normal)
        self.cliente = cliente
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyCliente, Value: cliente)
        calcularCostos(Guardar: true)
    }
}



extension VentaAgregarVC: ProductosListaVCDelegate {
    func productoSeleccionado(producto: NSDictionary) {
        productosVenta.append(producto)
        self.tableViewProductos.reloadData()
        totalVenta += Double(producto.value(forKey: Configuraciones.keyCostoVenta) as! String)!
        calcularCostos(Guardar: true)
    }
}
