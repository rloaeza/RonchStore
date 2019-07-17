//
//  VentaAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class VentaAgregarVC: UIViewController {
    var clientes: [NSDictionary] = []
    var productos: [NSDictionary] = []
    var productosVenta: [NSDictionary] = []
    var totalVenta: Double = 0

    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBOutlet weak var pickerViewClientes: UIPickerView!
    @IBOutlet weak var pickerViewProductos: UIPickerView!
    
    @IBAction func botonQuitarProducto(_ sender: Any) {
        let index = tableViewProductos.indexPathForSelectedRow?.row
        if index == nil {
            return
        }
        let dic = productosVenta[index!]
        totalVenta -= Double(dic.value(forKey: "costoVenta") as! String)!
        total.text = String( totalVenta )
        productosVenta.remove(at: index!)
        tableViewProductos.reloadData()
        
    }
    @IBAction func botonAgregarProducto(_ sender: Any) {
        let index = pickerViewProductos.selectedRow(inComponent: 0)
        let dic = productos[index]
        productosVenta.append(dic)
        tableViewProductos.reloadData()
        totalVenta += Double(dic.value(forKey: "costoVenta") as! String)!
        total.text = String( totalVenta )
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference().child("Productos").queryOrdered(byChild: "nombre")
        
        ref.observe(.value) { (DataSnapshot) in
            self.productos.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: "codigo")
                    self.productos.append(dic!)
                }
            }
            self.pickerViewProductos.reloadComponent(0)
        }
        
        
        let ref2 = Database.database().reference().child("Clientes").queryOrdered(byChild: "nombre")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewProductos {
            return productos[row].value(forKey: "nombre") as? String
        }
        if pickerView == pickerViewClientes {
            return clientes[row].value(forKey: "nombre") as? String
        }
        return "NO"
    }
}


extension VentaAgregarVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosVenta.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
        celda.textLabel?.text = productosVenta[indexPath.row].value(forKey: "nombre") as? String
        return celda
    }
    
    
}
