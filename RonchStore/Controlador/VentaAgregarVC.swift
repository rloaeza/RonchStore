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
    var totalVenta: Double = 0
    var venta: NSDictionary? = nil

    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBOutlet weak var pagado: UITextField!
    @IBOutlet weak var pickerViewClientes: UIPickerView!
    @IBOutlet weak var pickerViewProductos: UIPickerView!
    
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
    @IBAction func botonAgregarProducto(_ sender: Any) {
        let index = pickerViewProductos.selectedRow(inComponent: 0)
        let dic = productos[index]
        productosVenta.append(dic)
        tableViewProductos.reloadData()
        totalVenta += Double(dic.value(forKey: Configuraciones.keyCostoVenta) as! String)!
        total.text = String( totalVenta )
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference().child(Configuraciones.keyProductos).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.productos.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.productos.append(dic!)
                }
            }
            self.pickerViewProductos.reloadComponent(0)
        }
        
        
        let ref2 = Database.database().reference().child(Configuraciones.keyClientes).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref2.observe(.value) { (DataSnapshot) in
            self.clientes.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    self.clientes.append(dic!)
                }
            }
            self.pickerViewClientes.reloadComponent(0)
        }
        
        
        totalVenta = 0
        productosVenta.removeAll()
    }

}

extension VentaAgregarVC:UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewProductos {
            return productos.count
        }
        if pickerView == pickerViewClientes {
            return clientes.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
}
extension VentaAgregarVC:UIPickerViewDelegate {
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "System", size: 14)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        
        if pickerView == pickerViewProductos {
            let nombre = productos[row].value(forKey: Configuraciones.keyNombre) as! String
            let costo = productos[row].value(forKey: Configuraciones.keyCostoVenta) as! String
            let marca = productos[row].value(forKey: Configuraciones.keyMarca) as! String
            let talla = productos[row].value(forKey: Configuraciones.keyTalla) as! String
            pickerLabel?.text =  "\(nombre) ( \(marca)/\(talla) ) $\(costo)"
        }
        if pickerView == pickerViewClientes {
            pickerLabel?.text =  clientes[row].value(forKey: Configuraciones.keyNombre) as? String
        }

        return pickerLabel!
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
    
    
}
