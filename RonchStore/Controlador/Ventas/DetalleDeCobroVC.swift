//
//  DetalleDeCobroVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 11/07/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetalleDeCobroVC: UIViewController {
    @IBOutlet weak var swSemanal: UISwitch!
    @IBOutlet weak var swQuincenal: UISwitch!
    @IBOutlet weak var swMensual: UISwitch!
    @IBOutlet weak var swOmitirPrimerCobro: UISwitch!
    @IBOutlet weak var botonDiaCobro: UIButton!
    @IBOutlet weak var botonHoraCobro: UIButton!
    
    var venta: NSDictionary? = nil
    var codigo: String? = nil
    var ref: DatabaseReference!
    var opcionTipoPago: String = Configuraciones.keyTipoPagoSemanal

    
    func seleccionaTipoDia(Semanal semanal: Bool, Quincenal quincenal: Bool, Mensual mensual: Bool, TipoPago tipoPago:String, TextoBoton txtBoton: String,  Valor valor: String?) {
        swSemanal.setOn(semanal, animated: true)
        swQuincenal.setOn(quincenal, animated: true)
        swMensual.setOn(mensual, animated: true)
        opcionTipoPago = tipoPago
        botonDiaCobro.setTitle(txtBoton, for: .normal)
        
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyDiaCobro, Value: valor)
       
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyTipoPago, Value: tipoPago)
        
        venta?.setValue(valor, forKey: Configuraciones.keyDiaCobro)
        venta?.setValue(tipoPago, forKey: Configuraciones.keyTipoPago)
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.siguienteFechaInicial(Venta: venta) )
        venta?.setValue(Funciones.siguienteFechaInicial(Venta: venta), forKey: Configuraciones.keyFechaCobro)
        
        if quincenal {
            botonDiaCobro.isEnabled = false
        }
        else {
            botonDiaCobro.isEnabled = true
        }
    }
    
    @IBAction func seleccionOmitirPrimerCobro(_ sender: Any) {
        let omitir = swOmitirPrimerCobro.isOn
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyOmitirFechaPrimerCobro, Value: omitir)
        venta?.setValue(omitir, forKey: Configuraciones.keyOmitirFechaPrimerCobro)
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.siguienteFechaInicial(Venta: venta) )
        
        venta?.setValue(Funciones.siguienteFechaInicial(Venta: venta), forKey: Configuraciones.keyFechaCobro)

    }
    @IBAction func seleccionSemanal(_ sender: Any) {
           seleccionaTipoDia(Semanal: true, Quincenal: false, Mensual: false, TipoPago: Configuraciones.keyTipoPagoSemanal, TextoBoton: Configuraciones.txtSeleccionaDiaSemana, Valor: nil)
       }
       @IBAction func seleccionQuincenal(_ sender: Any) {
           seleccionaTipoDia(Semanal: false, Quincenal: true, Mensual: false, TipoPago: Configuraciones.keyTipoPagoQuincenal, TextoBoton: Configuraciones.txtSeleccionaDiaQuincenal, Valor: Configuraciones.txtSeleccionaDiaQuincenal)
       }
       @IBAction func seleccionMensual(_ sender: Any) {
           seleccionaTipoDia(Semanal: false, Quincenal: false, Mensual: true, TipoPago: Configuraciones.keyTipoPagoMensual, TextoBoton: Configuraciones.txtSeleccionaDiaMensual, Valor: nil)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference()
        if venta != nil {
            codigo = venta?.value(forKey: Configuraciones.keyId) as? String
            var pagos: [NSDictionary] = []
            
            if let ps = venta?.value(forKey: Configuraciones.keyPagos) as? [NSDictionary] {
                pagos = ps
            }
            
            if pagos.count > 0 {
                botonHoraCobro.isEnabled = false
                botonDiaCobro.isEnabled = false
                swOmitirPrimerCobro.isEnabled = false
                swSemanal.isEnabled = false
                swQuincenal.isEnabled = false
                swMensual.isEnabled = false
            }
            opcionTipoPago = venta?.value(forKey: Configuraciones.keyTipoPago) as? String ?? Configuraciones.keyTipoPagoSemanal
            let diaCobro = venta!.value(forKey: Configuraciones.keyDiaCobro) as? String
            
           
            
            switch opcionTipoPago {
            case Configuraciones.keyTipoPagoSemanal:
                seleccionaTipoDia(Semanal: true, Quincenal: false, Mensual: false, TipoPago: Configuraciones.keyTipoPagoSemanal, TextoBoton: diaCobro == nil ? Configuraciones.txtSeleccionaDiaSemana : diaCobro!, Valor: diaCobro)
                break
            case Configuraciones.keyTipoPagoQuincenal:
                seleccionaTipoDia(Semanal: false, Quincenal: true, Mensual: false, TipoPago: Configuraciones.keyTipoPagoQuincenal, TextoBoton: Configuraciones.txtSeleccionaDiaQuincenal, Valor: diaCobro)
                break
            case Configuraciones.keyTipoPagoMensual:
                seleccionaTipoDia(Semanal: false, Quincenal: false, Mensual: true, TipoPago: Configuraciones.keyTipoPagoMensual, TextoBoton: diaCobro == nil ? Configuraciones.txtSeleccionaDiaMensual : diaCobro!, Valor: diaCobro)
                break
            default:
                break
                    
            }
            
            let horaCobro = venta!.value(forKey: Configuraciones.keyHoraCobro) as? String
            botonHoraCobro.setTitle(horaCobro == nil ? Configuraciones.txtSeleccionaHora : horaCobro!, for: .normal)
            
            
            let primerCobro = venta!.value(forKey: Configuraciones.keyOmitirFechaPrimerCobro) as? Bool ?? false
            swOmitirPrimerCobro.setOn(primerCobro, animated: true)
        }

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        
        if segue.identifier == "HoraCobroDesdeDetalleCobro",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.ordenarPor = nil
            vc.title = "Hora de cobro"
            vc.detalleKey = Configuraciones.keyDatosHoraCobro
        }
        
        if segue.identifier == "DiaCobroDesdeDetalleCobro",
                 let vc = segue.destination as? DetallesProductoListaVC {
            
            if opcionTipoPago == Configuraciones.keyTipoPagoSemanal {
                 vc.delegate = self
                 vc.title = "Días de cobro semanal"
                 vc.ordenarPor = nil
                 vc.detalleKey = Configuraciones.keyDatosDiaCobroSemanal
            }
            else if opcionTipoPago == Configuraciones.keyTipoPagoMensual {
                vc.delegate = self
                vc.title = "Días de cobro mensual"
                vc.ordenarPor = nil
                vc.detalleKey = Configuraciones.keyDatosDiaCobroMensual
             }
        
        }
    }
    

}

extension DetalleDeCobroVC: DetallesProductoListaVCDelegate {
    func valorSeleccionado(nombre: String, detalle: String) {
        
        switch detalle {
            
        case Configuraciones.keyDatosHoraCobro:
             botonHoraCobro.setTitle(nombre, for: .normal)
             codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyHoraCobro, Value: nombre)
             venta?.setValue(nombre, forKey: Configuraciones.keyHoraCobro)

             break
        case Configuraciones.keyDatosDiaCobroSemanal:
            botonDiaCobro.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyDiaCobro, Value: nombre)
            venta?.setValue(nombre, forKey: Configuraciones.keyDiaCobro)
            
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.siguienteFechaInicial(Venta: venta) )

            break
        case Configuraciones.keyDatosDiaCobroMensual:
            botonDiaCobro.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyDiaCobro, Value: nombre)
            venta?.setValue(nombre, forKey: Configuraciones.keyDiaCobro)
            
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyVentasBorrador, Child: codigo, KeyValue: Configuraciones.keyFechaCobro, Value: Funciones.siguienteFechaInicial(Venta: venta) )
            
            break
        default:
            break
        }
    }
}
