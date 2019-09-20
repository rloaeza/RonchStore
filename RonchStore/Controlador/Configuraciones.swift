//
//  Configuraciones.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class Configuraciones{
    static let Titulo = " .::RonchStore::."
    static let keyVentasBorrador = "Ventas Borrador"
    static let keyVentaFinalizada = "Venta Finalizada"
    static let keyProductos = "Productos"
    static let keyClientes = "Clientes"
    static let keyPedidos = "Pedidos"
    static let keyCasas = "Casas"
    static let keyCategorias = "Categorias"
    static let keyUsuarios = "Usuarios"
    static let keyAdmin = "Administrador"
    
    
    static let keyNombre = "Nombre"
    static let keyTelefono = "Telefono"
    static let keyEmail = "Email"
    static let keyCalle = "Calle"
    static let keyColonia = "Colonia"
    static let keyCiudad = "Ciudad"
    static let keyPais = "Pais"
    
    static let keyLat = "Lat"
    static let keyLong = "Long"
    static let keyMarca = "Marca"
    static let keyTalla = "Talla"
    static let keyCosto = "Costo"
    static let keyCostoVenta = "CostoVenta"
    static let keyExistencia = "Existencia"
    static let keyId = "key"
    static let keyCliente = "Cliente"
    static let keyTotal = "Total"
    static let keyDateFormat = "yyyy-MM-dd HH:mm"
    static let keyDateFormatExte = "yyyy-MM-dd HH:mm:ss"
    static let keyPagos = "Pagos"
    static let keyPago = "Pago"
    static let keyAbonado = "Abonado"
    static let keyFecha = "Fecha"
    static let keyStatus = "Status"
    static let keyAnticipo = "Anticipo"
    static let keyPagoInicialP = "Pago Inicial Porcentaje"
    static let keyPagoInicialV = "Pago Inicial Valor"
    static let keyPagoSemanas = "Pago Semanas"
    static let keyPagosFinalizados = "Pagos Finalizados"
    
    
    
    
    static let txtSeleccionarMarca = "Seleccionar marca"
    static let txtSeleccionarTalla = "Seleccionar talla"
    static let txtSeleccionarCategoria = "Seleccionar categoria"
    static let txtMensajeDemora = "Total despues de  # semanas"
    
    static func fecha() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = keyDateFormat
        return formatter.string(from: Date())
    }
    
    
    static func fechaMasDias(Semanas semanas: Double) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = keyDateFormat
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        return formatter.string(from: Date().addingTimeInterval(semanas*60*60*24*7))
    }
    
    
    
    
    static func alert(Titulo titulo: String, Mensaje mensaje: String, _ view: UIViewController, popView pop: Bool) {
        var alert: UIViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            
        } else {
            alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .actionSheet)
        }
        
        view.present(alert, animated: true)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            if pop {
                
                view.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    static func guardarValor(Reference ref: DatabaseReference!, KeyNode keyNode: String, Child child: String?, KeyValue keyValue: String, Value val: Any) -> String {
        var newData: DatabaseReference!
        
        if child == nil {
            newData = ref.child(keyNode).childByAutoId()
        }
        else {
            newData = ref.child(keyNode).child(child!)
        }
        newData.child(keyValue).setValue(val)
        
        return newData.key!
    }
    
    
    static func calcularTotalPagos(Pagos pagos: [NSDictionary]) -> Double {
        var total: Double = 0.0
        for p in pagos {
            total += Double(p.value(forKey: Configuraciones.keyPago) as! String)!
        }        
        return total
    }
    static func eliminarFoto(Reference ref: StorageReference, KeyNode key: String, Child child: String) {
        ref.child(key).child(child).delete(completion: nil)
    }
    
    
}
