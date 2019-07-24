//
//  PedidoAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase


class PedidoAgregarVC: UIViewController {
    var clientes: [NSDictionary] = []
    var productos: [NSDictionary] = []
    var pedido: NSDictionary? = nil

    @IBOutlet weak var cliente: UITextField!
    @IBOutlet weak var botonNotificar: UIButton!
    @IBOutlet weak var botonEliminar: UIButton!
    @IBOutlet weak var producto: UITextField!
    @IBAction func botonNotificar(_ sender: Any) {
        var tel: String
        if pedido == nil {
            tel = (clientes[pickerViewClientes.selectedRow(inComponent: 0)]).value(forKey: Configuraciones.keyTelefono) as! String
        } else {
            tel = (pedido?.value(forKey: Configuraciones.keyCliente) as! NSDictionary).value(forKey: Configuraciones.keyTelefono) as! String
        }
        
        Mensajes().sendSMS(Telefono: tel, Mensaje: "Tu pedido ya esta XD", self)
    }
    @IBAction func botonEliminar(_ sender: Any) {
        let alert = UIAlertController(title: "¿Eliminar?", message: "¿Esta seguro de eliminar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (UIAlertAction) in
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyPedidos).child(self.pedido?.value(forKey: Configuraciones.keyId) as! String).setValue(nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
    }
    @IBOutlet weak var anticipo: UITextField!
    @IBOutlet weak var tableViewProductos: UITableView!
    @IBAction func botonGuardar(_ sender: Any) {
        if productos.count == 0  {
            return
        }
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let newKey: DatabaseReference!
        if pedido == nil {
            newKey = ref.child(Configuraciones.keyPedidos).childByAutoId()
        }
        else {
            newKey = ref.child(Configuraciones.keyPedidos).child(pedido?.value(forKey: Configuraciones.keyId) as! String)
        }
        var cliente: NSDictionary
        if pedido == nil {
            cliente = clientes[pickerViewClientes.selectedRow(inComponent: 0)]
        }
        else {
            cliente = pedido?.value(forKey: Configuraciones.keyCliente) as! NSDictionary
        }
        if anticipo.text!.isEmpty {
            anticipo.text = "0"
        }
        newKey.setValue([
            Configuraciones.keyCliente:cliente,
            Configuraciones.keyProductos:productos,
            Configuraciones.keyAnticipo:Double(anticipo.text!)!
            ])
        
       
      
        Configuraciones.alert(Titulo: "Pedido", Mensaje: "Pedido guardado", self, popView: true)
        
    }
    @IBAction func botonQuitarProducto(_ sender: Any) {
        let index = tableViewProductos.indexPathForSelectedRow?.row
        if index == nil {
            return
        }
        productos.remove(at: index!)
        tableViewProductos.reloadData()
    }
    @IBAction func botonAgregarProducto(_ sender: Any) {
        let producto: NSDictionary = [Configuraciones.keyNombre: self.producto.text!, Configuraciones.keyStatus:"Pendiente"]
        productos.append(producto)
        tableViewProductos.reloadData()
    }
    @IBOutlet weak var pickerViewClientes: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if pedido == nil {
            botonEliminar.isHidden = true
            botonNotificar.isHidden = true
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
            
        } else {
            pickerViewClientes.isHidden = true
            cliente.isHidden = false
            let c = pedido?.value(forKey: Configuraciones.keyCliente) as! NSDictionary
            cliente.text = c.value(forKey: Configuraciones.keyNombre) as? String
            
            productos = pedido?.value(forKey: Configuraciones.keyProductos) as! [NSDictionary]
            tableViewProductos.reloadData()
            anticipo.text = String( pedido?.value(forKey: Configuraciones.keyAnticipo) as! Double)
        }
        
    }

}


extension PedidoAgregarVC:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
            return clientes.count
    }
}

extension PedidoAgregarVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let status = productos[indexPath.row].value(forKey: Configuraciones.keyStatus) as! String
        var newStatus = ""
        if status == "OK" {
            newStatus = "Pendiente"
        }
        else {
            newStatus = "OK"
        }
        let ref = Database.database().reference().child(Configuraciones.keyPedidos).child(pedido?.value(forKey: Configuraciones.keyId) as! String).child(Configuraciones.keyProductos).child(String(indexPath.row)).child(Configuraciones.keyStatus)
        ref.setValue(newStatus)
        productos[indexPath.row].setValue(newStatus, forKey: Configuraciones.keyStatus)
        tableViewProductos.reloadData()
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension PedidoAgregarVC:UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: "System", size: 14)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
 
            pickerLabel?.text =  clientes[row].value(forKey: Configuraciones.keyNombre) as? String
   
        return pickerLabel!
    }
}


extension PedidoAgregarVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
        
        let nombre = productos[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String
        let status = productos[indexPath.row].value(forKey: Configuraciones.keyStatus) as! String
        
        celda.textLabel?.text = String(indexPath.row + 1) + ") \(nombre)"
        celda.detailTextLabel?.text = status
        return celda
    }
    
    
}
