//
//  ProductoDescuentoVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 22/06/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit

protocol ProductoConDescuentoVCDelegate {
    func productoConDescuento(tipoDescuento: Bool, descuento: Double, costoConDescuento: Double)
}


class ProductoDescuentoVC: UIViewController {
    var delegate: ProductoConDescuentoVCDelegate?

    
    var producto: NSDictionary? = nil
    var descuentoPorcentaje: Bool = true
    var costoVenta: Double = 0
    var costoConDescuento: Double = 0
    var descuento: Double  = 0


    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblCostoVenta: UILabel!
    @IBOutlet weak var lblCostoFinal: UILabel!
    @IBOutlet weak var btnTipoDescuento: UIButton!
    
    @IBOutlet weak var tfDescuento: UITextField!
    
    
    @IBAction func cambiarTipoDescuento(_ sender: Any) {
        descuentoPorcentaje = !descuentoPorcentaje
        if descuentoPorcentaje {
            btnTipoDescuento.setTitle("Descuento (%)", for: .normal)
        }
        else {
            btnTipoDescuento.setTitle("Descuento ($)", for: .normal)
        }
        actualizarDescuento(self)
    }
    
    @IBAction func actualizarDescuento(_ sender: Any) {
        calcularNuevoTotal()
        lblCostoFinal.text = "$ \(costoConDescuento)"
    }
    @IBAction func botonAplicar(_ sender: Any) {
        
        
        //producto?.setValue(descuentoPorcentaje, forKey: Configuraciones.keyDescuentoTipo)
        //producto?.setValue( "\(costoConDescuento)", forKey: Configuraciones.keyCostoConDescuento)
        //producto?.setValue("\(descuento)", forKey: Configuraciones.keyDescuento)
        
        
        delegate?.productoConDescuento(tipoDescuento: descuentoPorcentaje, descuento: descuento, costoConDescuento: costoConDescuento)
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        lblNombre.text = producto?.value(forKey: Configuraciones.keyNombre) as? String ?? ""
        costoVenta = Double (producto?.value(forKey: Configuraciones.keyCostoVenta) as? String ?? "0")!
        lblCostoVenta.text = "$ \(costoVenta)"
        tfDescuento.text = producto?.value(forKey: Configuraciones.keyDescuento) as? String ?? "0"
        
        if producto?.value(forKey: Configuraciones.keyDescuentoTipo) as? Bool ?? true {
            descuentoPorcentaje = false
            cambiarTipoDescuento(self)
        }
        else {
            descuentoPorcentaje = true
            cambiarTipoDescuento(self)
        }
        
        
        Configuraciones.cargarImagen(KeyNode: Configuraciones.keyProductos, Child: producto?.value(forKey: Configuraciones.keyId) as! String, Image: imagen)
        
        
        

        
        // Do any additional setup after loading the view.
    }
    func calcularNuevoTotal() {
        if tfDescuento.text!.isEmpty {
            descuento = 0
        }
        else {
            descuento = Double(tfDescuento.text!)!
        }
        
        if descuentoPorcentaje {
            costoConDescuento = costoVenta - (costoVenta*descuento/100)
        } else {
            costoConDescuento = costoVenta - descuento
        }
        
        
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
