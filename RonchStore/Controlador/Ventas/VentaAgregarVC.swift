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
    var descuentoPorcentaje: Bool = true
    var fechaFijada: Bool = false
    var premium: Bool = false
    
    var descuento: Double = 0.0
    var pagoInicialP: Double = 30.0
    var pagoInicialV: Double = 0.0
    var pagoSemanas: Int = 6
    var pagoSemanasV: Double = 0.0
    var pagoDemora1: Double = 0.0
    var pagoDemora2: Double = 0.0

    
    var subTotalVenta: Double = 0
    var totalVenta: Double = 0
    var venta: NSDictionary? = nil
    var ref: DatabaseReference!
    var codigo: String? = nil
    var contador: Int? = nil
    
    var cliente: NSDictionary? = nil
    
    @IBOutlet weak var tfDescuento: UITextField!
    @IBOutlet weak var tfSubTotal: UITextField!
    @IBOutlet weak var tfPagoInicialP: UITextField!
    @IBOutlet weak var tfPagoInicialV: UITextField!
    @IBOutlet weak var tfPagoSemanas: UITextField!
    @IBOutlet weak var tfPagoSemanasV: UITextField!
    @IBOutlet weak var tfPagoDemora1: UITextField!
    @IBOutlet weak var tfPagoDemora2: UITextField!
    @IBOutlet weak var labelDemora1: UILabel!
    @IBOutlet weak var labelDemora2: UILabel!
    @IBOutlet weak var labelDescripcionFinal: UILabel!
    
    @IBOutlet weak var labelPremium: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelTicket: UILabel!
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBOutlet weak var pagado: UITextField!
    @IBOutlet weak var pickerViewClientes: UIPickerView!
    @IBOutlet weak var pickerViewProductos: UIPickerView!
    
    @IBOutlet weak var botonCliente: UIButton!
    //@IBOutlet weak var botonProductos: UIButton!
    
    @IBOutlet weak var botonProductos: UIBarButtonItem!
    
    @IBOutlet weak var botonFinalizar: UIButton!
    @IBOutlet weak var botonEditar: UIButton!
    @IBOutlet weak var botonVerPagos: UIButton!
    @IBOutlet weak var tipoDescuento: UIButton!
    @IBOutlet weak var viewDetalleCredito: UIView!
    
    
    
    @IBAction func cambiarTipoDescuento(_ sender: Any) {
        descuentoPorcentaje = !descuentoPorcentaje
        
        if descuentoPorcentaje {
            tipoDescuento.setTitle("Desc (%)", for: .normal)
        }
        else {
            tipoDescuento.setTitle("Desc ($)", for: .normal)
        }
        calcularCostos(Guardar: true)
    }
    
    
    @IBAction func finalizarVenta(_ sender: Any) {
        finalizarStatusVenta(Finalizar: true)
        
      
        var mensajePremium: String  = Configuraciones.txtMensajeVenta
        
        mensajePremium = mensajePremium.replacingOccurrences(of: "$ticket", with: "\(contador!)")
        mensajePremium = mensajePremium.replacingOccurrences(of: "$fecha", with: labelFecha.text!)
        
        mensajePremium = mensajePremium.replacingOccurrences(of: "$cliente", with: cliente?.value(forKey: Configuraciones.keyApellidos) as? String ?? "Mostrador")
        
        var productosMSG: String = ""
        for p in productosVenta {
            let pNombre: String = p.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            let pCostoVenta: String = p.value(forKey: Configuraciones.keyCostoVenta) as? String ?? ""
            let pCostoDescuento: String = p.value(forKey: Configuraciones.keyCostoConDescuento) as? String ?? ""
            
            productosMSG += "  1 x \(pNombre) $ \(pCostoVenta)\(!pCostoDescuento.isEmpty ? " / $ \(pCostoDescuento)" : "" )\n"
        }
        mensajePremium = mensajePremium.replacingOccurrences(of: "$productos", with: productosMSG)
        
        
        if descuento != 0 {
            mensajePremium = mensajePremium.replacingOccurrences(of: "$subtotal", with: "\n SubTotal: \(tfSubTotal.text!)\n")
            mensajePremium = mensajePremium.replacingOccurrences(of: "$descuento", with:"Descuento: \(descuentoPorcentaje ? "%" : "$") \(tfDescuento.text!)")
        }
        else {
            mensajePremium = mensajePremium.replacingOccurrences(of: "$subtotal", with: "")
            mensajePremium = mensajePremium.replacingOccurrences(of: "$descuento", with: "")
        }
        mensajePremium = mensajePremium.replacingOccurrences(of: "$total", with: total.text!)
        
        let diaCobro: String = cliente?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "x"
        mensajePremium = mensajePremium.replacingOccurrences(of: "$diaCobro", with: diaCobro)
        
        
        let saldo: Double = totalVenta - pagoInicialV
        mensajePremium = mensajePremium.replacingOccurrences(of: "$anticipo", with: premium ? "" : " Anticipo: $ \(tfPagoInicialV.text!)\n")
        mensajePremium = mensajePremium.replacingOccurrences(of: "$saldo", with: premium ? "" :  "    Saldo: $ \(String(saldo))")
        
        
        if !premium {
            mensajePremium += "\n\nDespues de \(labelDemora1.text!): \(tfPagoDemora1.text!)\n"
            mensajePremium += "Despues de \(labelDemora2.text!): \(tfPagoDemora2.text!)\n"
        }
        
       
        
        

        
        
        if MFMessageComposeViewController.canSendText() {
            //let nProductos = productosVenta.count
            
            /*
            var mensaje = "\(Configuraciones.Titulo) \n"
            
            for p in productosVenta {
                mensaje += "  1 x \(p.value(forKey: Configuraciones.keyNombre)!) [$\(p.value(forKey: Configuraciones.keyCostoVenta)!)]\n"
            }
            
            mensaje += "Total: $\(totalVenta)\n"
            mensaje += "Anticipo: $\(tfPagoInicialV.text!)\n\n"
            mensaje += "Despues de \(labelDemora1.text!): \(tfPagoDemora1.text!)\n"
            mensaje += "Despues de \(labelDemora2.text!): \(tfPagoDemora2.text!)\n"
            
            
            
            
            
            
            */
            
            let messageVC = MFMessageComposeViewController()
            messageVC.body = mensajePremium
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
    
    
    @IBAction func actualizarDescuento(_ sender: Any) {
        calcularDescuento()
        calcularCostos(Guardar: true)
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        subTotalVenta = 0
        
        productosVenta.removeAll()
        
        if venta != nil {
            fechaFijada = true
            codigo = venta?.value(forKey: Configuraciones.keyId) as? String
            contador = venta?.value(forKey: Configuraciones.keyContador) as? Int ?? 0
            labelTicket.text = "Ticket \(contador!)"
            labelFecha.text = Configuraciones.fechaReducida(Fecha: venta?.value(forKey: Configuraciones.keyFecha) as? String ?? "2020-01-01 00:00")
            cliente = venta?.value(forKey: Configuraciones.keyCliente) as? NSDictionary
            botonCliente.setTitle(cliente?.value(forKey: Configuraciones.keyNombre) as? String, for: .normal)
            
            tfDescuento.text = String(venta?.value(forKey: Configuraciones.keyDescuento) as? Double ?? 0.0)
            
            premium = cliente?.value(forKey: Configuraciones.keyPremium) as? Bool ?? false
            
            if premium {
                viewDetalleCredito.isHidden = true
                tfPagoInicialV.text = "0"
                tfPagoInicialP.text = "0"
                labelPremium.isHidden = false
            }
            else {
                viewDetalleCredito.isHidden = false
                labelPremium.isHidden = true
            }
            descuentoPorcentaje = Bool( venta?.value(forKey: Configuraciones.keyDescuentoTipo) as? Bool ?? true )
            if descuentoPorcentaje {
                tipoDescuento.setTitle("Desc (%)", for: .normal)
            }
            else {
                tipoDescuento.setTitle("Desc ($)", for: .normal)
            }
            
            productosVenta = venta?.value(forKey: Configuraciones.keyProductos) as? [NSDictionary] ?? []
            
            calcularSubTotal()
            
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
            
            // Aqui vamos
            
            
            
            

        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClienteDesdeNuevaVenta",
            let vc = segue.destination as? ClienteVC {
            vc.delegate = self
        }
        
        if segue.identifier == "ProductoDesdeNuevaVenta",
            let vc = segue.destination as? ProductosListaVC {
            let montoMaximo: Double = Double( cliente?.value(forKey: Configuraciones.keyMontoMaximo) as? String ?? "0" )!
            vc.montoDisponible = montoMaximo - totalVenta
            vc.validarCantidades = true
            vc.delegate = self
        }
        
        
        if segue.identifier == "PagosDesdeNuevaVenta",
            let vc = segue.destination as? PagosListaVC {
            vc.venta = venta
        }
        
        if segue.identifier == "ProductoDescuentoDesdeNuevaVenta",
            let vc = segue.destination as? ProductoDescuentoVC {
            vc.producto = self.productosVenta[ self.tableViewProductos.indexPathForSelectedRow!.row ]
            vc.delegate = self
        }
        
        if segue.identifier == "DetallesCobroDesdeNuevaVenta",
            let vc = segue.destination as? DetalleDeCobroVC {
            vc.venta = venta            
        }
        
        //
    }
    
    
    func ocultarModoCredito(Ocultar ocultar: Bool) {
        
    }
    
    func finalizarStatusVenta(Finalizar finalizar: Bool) {
        ventaFinalizada = finalizar
        if finalizar {
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyVentaFinalizada, Value: true)
            
        }
        else {
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyVentaFinalizada, Value: false)
            
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagosFinalizados, Value: false)
            venta?.setValue(false, forKey: Configuraciones.keyPagosFinalizados)
        }
        
        
        
        labelDescripcionFinal.isHidden = !finalizar
        
        botonFinalizar.isHidden = finalizar
        botonFinalizar.isEnabled = !finalizar
        
        botonEditar.isHidden = !finalizar
        botonEditar.isEnabled = finalizar
        botonVerPagos.isHidden = !finalizar
        botonVerPagos.isEnabled = finalizar
        
        
        
        tfDescuento.isEnabled = !finalizar
        botonCliente.isEnabled = !finalizar
        botonProductos.isEnabled = !finalizar
        
        calcularTotales()
        
        
    }
    
    
    func calcularCostos(Guardar guardar: Bool) {
        tfSubTotal.text = "$ \(subTotalVenta)"
        
        
        calcularDescuento()
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
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyProductos, Value: productosVenta)
        venta?.setValue(productosVenta, forKey: Configuraciones.keyProductos)
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagoSemanas, Value: pagoSemanas)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagoInicialP, Value: pagoInicialP)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagoInicialV, Value: pagoInicialV)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyTotal, Value: totalVenta)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyDescuento, Value: descuento)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyDescuentoTipo, Value: descuentoPorcentaje)
        
        if !fechaFijada {
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyFecha, Value: Configuraciones.fecha())
            fechaFijada = true
            
        }
        
        if !ventaFinalizada {
            /*
            var primerCobro = venta!.value(forKey: Configuraciones.keyOmitirFechaPrimerCobro) as? Bool ?? false

            
            var fechaSig: Date = Date()
            let tipoPago = venta?.value(forKey: Configuraciones.keyTipoPago) as? String ?? Configuraciones.keyTipoPagoSemanal
            
            
            primerCobro = !primerCobro
            repeat {
                switch tipoPago {
                case Configuraciones.keyTipoPagoSemanal:
                    
                    var diaSemana: Int = 1
                    for dia in Funciones.diasSemana {
                        if venta?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "Domingo" == dia {
                            break
                        }
                        diaSemana = diaSemana + 1
                    }
                    fechaSig = Funciones.buscarSiguienteDia(Fecha: fechaSig, Dia: diaSemana )
                    codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.fechaAString(Fecha: fechaSig ))
                    break
                case Configuraciones.keyTipoPagoQuincenal:
                    fechaSig = Funciones.buscarSiguienteQuincena(Fecha: fechaSig)
                    codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.fechaAString(Fecha: fechaSig) )
                    break
                case Configuraciones.keyTipoPagoMensual:
                    fechaSig = Funciones.buscarSiguienteFecha(Fecha: fechaSig, Dia: Int(venta?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "1") ?? 1 )
                    codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.fechaAString(Fecha: fechaSig ) )
                    break
                default:
                    break
                }
                primerCobro = !primerCobro
            } while( primerCobro )
 */
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.siguienteFechaInicial(Venta: venta) )
            
        }
        
        
        if contador == nil {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyContador).observeSingleEvent(of: .value) { (DataSnapshot) in
                let dic  = DataSnapshot.value as! NSDictionary
                self.contador = dic.value(forKey: "Venta") as? Int ?? 0
                self.contador = self.contador! + 1
                self.codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: self.codigo, KeyValue: Configuraciones.keyContador, Value: self.contador! )
                
                Configuraciones.guardarValorDirecto(Reference: ref, KeyNode: Configuraciones.keyContador, KeyValue: "Venta", Value: self.contador!)
                
                
                
                
                self.labelTicket.text = "Ticket \(self.contador!)"
             
                
            }
            
        }
        
    }
    
    func calcularSubTotal() {
        subTotalVenta = 0
        for producto in productosVenta {
            if let costo: String = producto.value(forKey: Configuraciones.keyCostoConDescuento) as? String {
                subTotalVenta += Double( costo )!
            }
            else {
                subTotalVenta += Double( producto.value(forKey: Configuraciones.keyCostoVenta) as! String )!
            }
        }
    }
    

    func calcularDescuento() {
        
        if !tfDescuento.text!.isEmpty {
            
            descuento = Double(tfDescuento.text!) ?? 0.0
            if descuentoPorcentaje {
                totalVenta = subTotalVenta - ((subTotalVenta*Double(tfDescuento.text!)!)/100)
            }
            else {
                totalVenta = subTotalVenta - Double(tfDescuento.text!)!
            }
        }
        else {
            descuento = 0.0
            totalVenta = subTotalVenta
        }
        
        total.text = "$ \(totalVenta)"
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
        //let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
    
        let nombre = productosVenta[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String
        let marca = productosVenta[indexPath.row].value(forKey: Configuraciones.keyMarca) as! String
        let talla = productosVenta[indexPath.row].value(forKey: Configuraciones.keyTalla) as! String
        let costoVenta = productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String
        let costoConDescuento = productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoConDescuento) as? String ?? ""
        let fecha = productosVenta[indexPath.row].value(forKey: Configuraciones.keyFecha) as? String ?? ""
        
        //celda.textLabel?.text = String(indexPath.row + 1) + ") \(nombre) (\(marca)/\(talla))"
        //celda.detailTextLabel?.text = costo
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath) as! VentaProductoCell
        celda.nombre.text = nombre
        celda.marca.text = marca
        celda.talla.text = talla
        celda.fecha.text = fecha
        
        celda.costoVenta.text = "$ \(Double(costoVenta) ?? 0.0)"
        if !costoConDescuento.isEmpty {
            celda.costoConDescuento.text = "$ \(Double(costoConDescuento) ?? 0.0)"
        }
        else {
            celda.costoConDescuento.text = ""
        }
        celda.imagen.image = UIImage(named: "no_imagen")
        Configuraciones.cargarImagen(KeyNode: Configuraciones.keyProductos, Child: (productosVenta[indexPath.row].value(forKey: Configuraciones.keyId) as? String)!, Image: celda.imagen)
        
        
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if self.ventaFinalizada {
                Configuraciones.alert(Titulo: "Error", Mensaje: "Venta finalizada, no se puede editar", self, popView: false)
            }else {
                //subTotalVenta -= Double(productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String)!
                productosVenta.remove(at: indexPath.row)                
                self.tableViewProductos.reloadData()
                calcularSubTotal()
                calcularCostos(Guardar: true)
            }
        }
    }
    
}


extension VentaAgregarVC: ClienteVCDelegate {
    func clienteSeleccionado(cliente: NSDictionary) {
        botonCliente.setTitle(cliente.value(forKey: Configuraciones.keyNombre) as? String , for: .normal)
        self.cliente = cliente
        self.premium = cliente.value(forKey: Configuraciones.keyPremium) as? Bool ?? false
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyCliente, Value: cliente)
        
        if premium {
            viewDetalleCredito.isHidden = true
            tfPagoInicialV.text = "0"
            tfPagoInicialP.text = "0"
            labelPremium.isHidden = false
        }else {
            viewDetalleCredito.isHidden = false            
            tfPagoInicialP.text = "30"
            labelPremium.isHidden = true
        }
        
        calcularCostos(Guardar: true)
    }
}



extension VentaAgregarVC: ProductosListaVCDelegate {
    func productoSeleccionado(productos: [NSDictionary]) {
        for producto in productos {
            let p: NSDictionary = producto.mutableCopy() as! NSDictionary
            p.setValue(Configuraciones.fecha(), forKey: Configuraciones.keyFecha)
            productosVenta.append(p)
            self.tableViewProductos.reloadData()
            calcularSubTotal()
            calcularCostos(Guardar: true)
        }
        
    }
}

extension VentaAgregarVC: ProductoConDescuentoVCDelegate {
    func productoConDescuento(tipoDescuento: Bool, descuento: Double, costoConDescuento: Double) {
        let indice = self.tableViewProductos.indexPathForSelectedRow!.row
        
        let producto: NSDictionary = productosVenta[indice]
        producto.setValue(tipoDescuento, forKey: Configuraciones.keyDescuentoTipo)
        producto.setValue(String(descuento), forKey: Configuraciones.keyDescuento)
        producto.setValue(String(costoConDescuento), forKey: Configuraciones.keyCostoConDescuento)
        print( "Costo con descuento: \(costoConDescuento)" )
        //productosVenta.remove(at: indice)
        //productosVenta.insert(producto, at: indice)
        calcularSubTotal()
        calcularCostos(Guardar: true)
        self.tableViewProductos.reloadData()
    }
}
