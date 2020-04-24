//
//  Datos.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 04/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
// 

import Foundation
import FirebaseDatabase

class Datos {
    
    
    
    // MARK: - Clientes
    
    static var Clientes: [NSDictionary] = []
    
    static func cargarClientes() {
        
        let ref: DatabaseReference! = Database.database().reference().child(Configuraciones.keyClientes)
        
        ref.observe(.value) { (DataSnapshot) in
            Datos.Clientes.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    Datos.Clientes.append(dic!)
                }
            }
        }
    }
    
    static func getClientes(Patron patron: String)->[NSDictionary] {
        var ClientesConPatron: [NSDictionary] = []
        for cliente in Datos.Clientes {
            let nombre: String = cliente.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            let telefono: String = cliente.value(forKey: Configuraciones.keyTelefono) as? String ?? ""
            
            if nombre.lowercased().contains(patron)||telefono.lowercased().contains(patron)||patron.isEmpty {
                ClientesConPatron.append(cliente)
            }
        }
        return ClientesConPatron
    }
    
    // MARK: - Productos
    
    static var ProductosCargaInicial: Bool = true
    static var Productos: [NSDictionary] = []
    static var ProductosFotos:Dictionary = [String:Any]()
    
    static func cargarProductos() {
        
        let ref: DatabaseReference! = Database.database().reference().child(Configuraciones.keyProductos)
        ref.observe(.value) { (DataSnapshot) in
            Datos.Productos.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    Datos.Productos.append(dic!)
                    if ProductosCargaInicial {
                        let ruta: String = "\(Configuraciones.keyProductos)/\(dic!.value(forKey: Configuraciones.keyId)! as! String)"
                        NetworkManager.isReachableViaWiFi { (NetworkManager) in
                            let userRef = Configuraciones.storageRef.child(ruta)
                            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                               if error == nil {
                                ProductosFotos[snap.key] = data
                                }
                           }
                        }
                    }
                }
            }
            ProductosCargaInicial = false
        }
    }
    
    static func getProductos(Patron pattern: String)->[NSDictionary] {
        let patron = pattern.lowercased()
        var ProductosConPatron: [NSDictionary] = []
        for producto in Datos.Productos {
            let nombre: String = (producto.value(forKey: Configuraciones.keyNombre) as? String ?? "").lowercased()
            let marca: String = (producto.value(forKey: Configuraciones.keyMarca) as? String ?? "").lowercased()
            let categoria: String = (producto.value(forKey: Configuraciones.keyCategorias) as? String ?? "").lowercased()
            let talla: String = (producto.value(forKey: Configuraciones.keyTalla) as? String ?? "").lowercased()
            
            if nombre.contains(patron)||marca.contains(patron)||categoria.contains(patron)||talla.contains(patron)||patron.isEmpty {
                ProductosConPatron.append(producto)
            }
        }
        return ProductosConPatron
    }
    
    // MARK: - Listas
    
    static var Listas: [NSDictionary] = []
    
    static func cargarListas() {
        
        let ref: DatabaseReference! = Database.database().reference().child(Configuraciones.keyListas)
        
        ref.observe(.value) { (DataSnapshot) in
            Datos.Listas.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    Datos.Listas.append(dic!)
                }
            }
        }
    }
    
    static func getListas(Patron patron: String)->[NSDictionary] {
        var ListasConPatron: [NSDictionary] = []
        for lista in Datos.Listas {
            let cliente: NSDictionary = lista.value(forKey: Configuraciones.keyCliente) as? NSDictionary ?? [:]
            
            //let nombre: String = cliente.value(forKey: Configuraciones.keyCliente) as? String ?? ""
            
            let nombre: String = cliente.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            if nombre.lowercased().contains(patron)||patron.isEmpty {
                ListasConPatron.append(lista)
            }
        }
        return ListasConPatron
    }
}
