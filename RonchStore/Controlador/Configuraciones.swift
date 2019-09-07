//
//  Configuraciones.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit

class Configuraciones{
    static let keyVentasActivas = "Ventas Activas"
    static let keyVentasFinalizadas = "Ventas Finalizadas"
    static let keyProductos = "Productos"
    static let keyClientes = "Clientes"
    static let keyPedidos = "Pedidos"
    static let keyCasas = "Casas"
    
    static let keyNombre = "Nombre"
    static let keyTelefono = "Telefono"
    static let keyDireccion = "Direccion"
    static let keyEmail = "Email"
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
    static let keyDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let keyPagos = "Pagos"
    static let keyPago = "Pago"
    static let keyAbonado = "Abonado"
    static let keyFecha = "Fecha"
    static let keyStatus = "Status"
    static let keyAnticipo = "Anticipo"
    
    static func fecha() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = keyDateFormat
        return formatter.string(from: Date())
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
    
}
