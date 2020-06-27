//
//  PagoNuevoVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 26/06/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit


protocol PagoNuevoVCDelegate {
    func pagoNuevo(monto: Double, concepto: String)
}


class PagoNuevoVC: UIViewController {
    
    @IBOutlet weak var lblCliente: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAdeudo: UILabel!
    @IBOutlet weak var tfMonto: UITextField!
    @IBOutlet weak var btnConcepto: UIButton!
    
    
    var delegate: PagoNuevoVCDelegate?
    var venta: NSDictionary? = nil
    var adeudo: Double = 0
    var concepto: String = ""
    
    @IBAction func btnAplicar(_ sender: Any) {
        if !(tfMonto.text?.isEmpty ?? true) {
            let monto: Double = Double( tfMonto.text! )!
            if monto <= 0 ||  monto > adeudo{
                Configuraciones.alert(Titulo: "Error", Mensaje: "Error en el valor introducido", self, popView: false)
                return
            }
            else {
                self.navigationController?.popViewController(animated: true)
                delegate?.pagoNuevo(monto: monto, concepto: concepto)
                

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if venta != nil {
            let cliente: NSDictionary = venta?.value(forKey: Configuraciones.keyCliente) as! NSDictionary
            let total: Double = venta?.value(forKey: Configuraciones.keyTotal) as? Double ?? 0
            let pagos: [NSDictionary] = venta?.value(forKey: Configuraciones.keyPagos) as! [NSDictionary]
            let pagoInicial: Double = venta?.value(forKey: Configuraciones.keyPagoInicialV) as? Double ?? 0
            
            adeudo = total - (Configuraciones.calcularTotalPagos(Pagos: pagos) + pagoInicial)
            
            lblCliente.text = cliente.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            lblTotal.text = String( total )
            lblAdeudo.text = String( adeudo )
            
        }

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ConceptoPagoDesdePagoNuevo",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.ordenarPor = Configuraciones.keyNombre
            vc.title = "Concepto de pago"
            vc.detalleKey = Configuraciones.keyDatosConceptoPago
        }
        
    }    
}


extension PagoNuevoVC: DetallesProductoListaVCDelegate {
    func valorSeleccionado(nombre: String, detalle: String) {
        switch detalle {
            
        case Configuraciones.keyDatosConceptoPago:
            concepto = nombre
            btnConcepto.setTitle(concepto, for: .normal)
            break
        default:
            break
        }
    }
    
    
    
}
