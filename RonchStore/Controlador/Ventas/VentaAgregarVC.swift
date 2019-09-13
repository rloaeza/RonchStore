//
//  VentaAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VentaAgregarVC: UIViewController  {
    var clientes: [NSDictionary] = []
    var productos: [NSDictionary] = []
    var productosVenta: [NSDictionary] = []
    
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
    
    var cliente: NSDictionary? = nil
    
    @IBOutlet weak var tfPagoInicialP: UITextField!
    @IBOutlet weak var tfPagoInicialV: UITextField!
    @IBOutlet weak var tfPagoSemanas: UITextField!
    @IBOutlet weak var tfPagoSemanasV: UITextField!
    @IBOutlet weak var tfPagoDemora1: UITextField!
    @IBOutlet weak var tfPagoDemora2: UITextField!
    @IBOutlet weak var labelDemora1: UILabel!
    @IBOutlet weak var labelDemora2: UILabel!
    
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBOutlet weak var pagado: UITextField!
    @IBOutlet weak var pickerViewClientes: UIPickerView!
    @IBOutlet weak var pickerViewProductos: UIPickerView!
    
    @IBOutlet weak var botonCliente: UIButton!
    
    
    
    
    
    
    @IBAction func actualizarPagoInicial(_ sender: Any) {
        tfPagoInicialV.text = ""
        calcularCostos()
    }
    
    @IBAction func actualizarPagoInicialV(_ sender: Any) {
        tfPagoInicialP.text = ""
        calcularCostos()
    }
    
    @IBAction func actualizarSemanas(_ sender: Any) {
        calcularCostos()
    }
    
    
    
    @IBAction func botonFinalizarVenta(_ sender: Any) {
        
    }
    
    
    
    
    @IBAction func botonGuardar(_ sender: Any) {
        if productosVenta.count == 0 || pagado.text!.isEmpty {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let newKey: DatabaseReference!
        if venta == nil {
            newKey = ref.child(Configuraciones.keyVentasActivas).childByAutoId()
        }
        else {
            newKey = ref.child(Configuraciones.keyVentasActivas).child(venta?.value(forKey: Configuraciones.keyId) as! String)
        }
        
        var pagos: [NSDictionary] = []
        pagos.append([Configuraciones.keyPago : Double(pagado.text!)!, Configuraciones.keyFecha : Configuraciones.fecha()])
        
        let cliente = clientes[pickerViewClientes.selectedRow(inComponent: 0)]
        newKey.setValue([
            Configuraciones.keyCliente:cliente,
            Configuraciones.keyProductos:productosVenta,
            Configuraciones.keyTotal:totalVenta,
            Configuraciones.keyPagos:pagos,
            Configuraciones.keyAbonado:Double(pagado.text!)!
            ])
        
        Mensajes().sendSMS(Telefono:cliente.value(forKey: Configuraciones.keyTelefono) as! String, Mensaje: "Pago: \(pagado.text!) de \(total.text!)", self)
        
        Configuraciones.alert(Titulo: "Venta", Mensaje: "Venta agregada", self, popView: true)

    }
    
    
    @IBAction func botonQuitarProducto(_ sender: Any) {
        let index = tableViewProductos.indexPathForSelectedRow?.row
        if index == nil {
            return
        }
        let dic = productosVenta[index!]
        totalVenta -= Double(dic.value(forKey: Configuraciones.keyCostoVenta) as! String)!
        total.text = String( totalVenta )
        productosVenta.remove(at: index!)
        tableViewProductos.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()

        totalVenta = 0
        productosVenta.removeAll()
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
    }
    
    func calcularCostos() {
        total.text = "$ \(totalVenta)"
        calcularPagoInicial()
        tfPagoInicialV.text = "\(String(format: "%.1f",pagoInicialV))"
        tfPagoInicialP.text = "\(pagoInicialP)"
        calcularSemanas()
        tfPagoSemanasV.text = "$ \(String(format: "%.1f", pagoSemanasV))"
        tfPagoDemora1.text = "$ \(String(format: "%.1f", pagoDemora1))"
        tfPagoDemora2.text = "$ \(String(format: "%.1f", pagoDemora2))"
        
        
        let d1 = Configuraciones.txtMensajeDemora.replacingOccurrences(of: "#", with: String(pagoSemanas))
        let d2 = Configuraciones.txtMensajeDemora.replacingOccurrences(of: "#", with: String(pagoSemanas + 3))
        
        
        
        labelDemora1.text = Configuraciones.fechaMasDias( Semanas: Double(pagoSemanas) )
        labelDemora2.text = Configuraciones.fechaMasDias( Semanas: Double(pagoSemanas + 3) )
        
        guardarValores()
    }
    
    func guardarValores() {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyProductos, Value: productosVenta)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagoSemanas, Value: pagoSemanas)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagoInicialP, Value: pagoInicialP)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyPagoInicialV, Value: pagoInicialV)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyTotal, Value: totalVenta)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyFecha, Value: Configuraciones.fecha())
        
        
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
            totalVenta -= Double(productosVenta[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String)!
            productosVenta.remove(at: indexPath.row)
            self.tableViewProductos.reloadData()
            calcularCostos()
        }
    }
    
}


extension VentaAgregarVC: ClienteVCDelegate {
    func clienteSeleccionado(cliente: NSDictionary) {
        botonCliente.setTitle(cliente.value(forKey: Configuraciones.keyNombre) as! String , for: .normal)
        self.cliente = cliente
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyCliente, Value: cliente)
    }
}



extension VentaAgregarVC: ProductosListaVCDelegate {
    func productoSeleccionado(producto: NSDictionary) {
        productosVenta.append(producto)
        self.tableViewProductos.reloadData()
        totalVenta += Double(producto.value(forKey: Configuraciones.keyCostoVenta) as! String)!
        calcularCostos()

        
        //codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasActivas, Child: codigo, KeyValue: Configuraciones.keyCliente, Value: cliente)
    }
}
