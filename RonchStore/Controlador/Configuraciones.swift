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
    static var datosProductoNuevo: NSDictionary = [Configuraciones.keyNombre:""]
    static let ventasLibres = 3
    static var usuarioPro: Bool = false
    static let keyUsuarioPro: String = "Usuario Pro"
    static var userID : String = ""
    static let Titulo = " .::RonchStore::."
    static let keyVentasActivas = "Ventas Activas"
    static let keyVentaFinalizada = "Venta Finalizada"
    static let keyVentasArchivadas = "Ventas Archivadas"
    static let keyProductos = "Productos"
    static let keyClientes = "Clientes"
    static let keyPedidos = "Pedidos"
    static let keyCasas = "Casas"
    static let keyCategorias = "Categorias"
    static let keyUsuarios = "Usuarios"
    static let keyAdmin = "Administrador"
    static let keyGastos = "Gastos"
    
    static let keyNombre = "Nombre"
    static let keyTelefono = "Telefono"
    static let keyEmail = "Email"
    static let keyCalle = "Calle"
    static let keyColonia = "Colonia"
    static let keyCiudad = "Ciudad"
    static let keyPais = "Pais"
    static let keyMontoMaximo = "MaximoCredito"
    static let keyPremium = "Premium"
    static let keyApellidos = "Apellidos"
    static let keyTipoPago = "Tipo de pago"
    static let keyTipoPagoSemanal = "Semanal"
    static let keyTipoPagoQuincenal = "Quincenal"
    static let keyTipoPagoMensual = "Mensual"
    
    
    
    static let keyLat = "Lat"
    static let keyLong = "Long"
    static let keyBarCode = "BarCode"
    static let keyMarca = "Marca"
    static let keyTalla = "Talla"
    static let keyCosto = "Costo"
    static let keyCostoVenta = "CostoVenta"
    static let keyCostoConDescuento = "Costo con descuento"
    static let keyExistencia = "Existencia"
    static let keyId = "key"
    static let keyCliente = "Cliente"
    static let keyTotal = "Total"
    static let keyDateFormat = "yyyy-MM-dd HH:mm"
    
    static let keyDescuentoTipo = "DescuentoTipo"
    static let keyDescuento = "Descuento"
    static let keyDateFormatReducido = "dd/MM/yy"
    static let keyDateFormatExte = "yyyy-MM-dd HH:mm:ss"
    static let keyPagos = "Pagos"
    static let keyPago = "Pago"
    static let keyPagoMensajeEnviado = "Pago mensaje enviado"
    static let keyAbonado = "Abonado"
    static let keyFecha = "Fecha"
    static let keyFechaCobro = "Fecha de cobro"
    static let keyStatus = "Status"
    static let keyAnticipo = "Anticipo"
    static let keyPagoInicialP = "Pago Inicial Porcentaje"
    static let keyPagoInicialV = "Pago Inicial Valor"
    static let keyPagoSemanas = "Pago Semanas"
    static let keyPagosFinalizados = "Pagos Finalizados"
    static let keyOmitirFechaPrimerCobro = "Omitir fecha primer cobro"
    
    static let keyListas = "Listas"
    
    
    
    static let keyDatosDetalleProductoCategoria = "Datos/ProductoDetalle/Categoria"
    static let keyDatosDetalleProductoMarca = "Datos/ProductoDetalle/Marca"
    static let keyDatosDetalleProductoTalla = "Datos/ProductoDetalle/Talla"
    static let keyDatosDetalleProductoNombre = "Datos/ProductoDetalle/Nombre"
    static let keyDatosDetalleProductoCosto = "Datos/ProductoDetalle/Costo"
    static let keyDatosDetalleProductoCostoVenta = "Datos/ProductoDetalle/CostoVenta"
    static let keyDatosDetalleProductoExistencia = "Datos/ProductoDetalle/Existencia"
    
    
    static let keyDatosDiaCobroSemanal = "Datos/Dias de cobro semanal"
    static let keyDatosDiaCobroMensual = "Datos/Dias de cobro mensual"
    static let keyDatosHoraCobro = "Datos/Horas de cobro"
    static let keyDatosConceptoPago = "Datos/Conceptos de pago"
    
    static let keyDiaCobro = "Dias de cobro"
    static let keyHoraCobro = "Horas de cobro"
    static let keyConceptoPago = "Concepto de pago"

    
    
    static let keyContador = "Contador"
    
    
    static let txtAdeudo = "Adeudo"
    
    
    static let txtSeleccionarNombre = "Seleccionar nombre"
    static let txtSeleccionarCosto = "Seleccionar costo"
    static let txtSeleccionarCostoVenta = "Seleccionar costo de venta"
    static let txtSeleccionarExistencia = "Seleccionar existencias"
    static let txtSeleccionarMarca = "Seleccionar marca"
    static let txtSeleccionarTalla = "Seleccionar talla"
    static let txtSeleccionarCategoria = "Seleccionar categoria"
    static let txtMensajeDemora = "Total despues de  # semanas"
    static let txtSeleccionaDiaSemana = "Selecciona día de la semana"
    static let txtSeleccionaDiaQuincenal = "1 y 15"
    static let txtSeleccionaDiaMensual = "Selecciona día del mes"
    static let txtSeleccionaHora = "Selecciona hora"
    
    static let txtArchivar = "Archivar"
    static let txtRestaurar = "Restaurar"
    static let txtGuardar = "Guardar"
    static let txtCancelar = "Cancelar"
    static let txtIntroduzcaNuevoValor = "Introduzca nuevo valor"
    static let txtValorGuardado = "Valor guardado"
    static let txtBarCodeSearch = "Coloque el código de barras dentro de la ventana para escanear. La búsqueda comenzará automáticamente."
    
    static let txtError = "Error"
    static let txtErrorLlenarCampos = "Favor de llenar los campos"
    static let txtErrorLimiteVentas = "Límite de ventas libres superado, favor de migrar a versión PRO"
    
    
    
    static let txtMensajeVenta = """
      .::RonchStore::.
Ticket: $ticket, Fecha: $fecha
Cliente: $cliente

Produtos
$productos$subtotal$descuento
    Total: $total
$anticipo$saldo
Dia de cobro: $diaCobro
"""
    static let txtMensajeAbono = """
      .::RonchStore::.
Ticket: $ticket, Fecha: $fecha
Cliente: $cliente

Confirmación de pago por $ $abono. Realizado el $fAbono

 Total: $total
Abonos: $totAbonos
 Saldo: $saldo
"""
    
    
    static let storageRef = Storage.storage().reference()
    
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
    
    static func fechaReducida(Fecha fecha: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = keyDateFormat
        let date = dateFormatter.date(from:fecha)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = keyDateFormat
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        return formatter.string(from: date)
        
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
    
    static func guardarValor(Reference ref: DatabaseReference!, KeyNode keyNode: String, Child child: String?, KeyValue keyValue: String, Value val: Any?) -> String {
        var newData: DatabaseReference!
        
        if child == nil {
            newData = ref.child(userID + keyNode).childByAutoId()
        }
        else {
            newData = ref.child(userID + keyNode).child(child!)
        }
        newData.child(keyValue).setValue(val)
        
        return newData.key!
    }
    
    static func guardarValorDirecto(Reference ref: DatabaseReference!, KeyNode keyNode: String, KeyValue keyValue: String?, Value val: Any) {
        var newData: DatabaseReference!    
        newData = ref.child(userID + keyNode)
        
        if keyValue == nil {
            newData.childByAutoId().setValue(val)
        }
        else {
            newData.child(keyValue!).setValue(val)
        }
        
    }
    static func calcularTotalPagos(Pagos pagos: [NSDictionary]) -> Double {
        var total: Double = 0.0
        for p in pagos {
            total += Double(p.value(forKey: Configuraciones.keyPago) as! String)!
        }        
        return total
    }
    static func eliminarImagen(Reference ref: StorageReference, KeyNode key: String, Child child: String) {
        ref.child(userID + key).child(child).delete(completion: nil)
        eliminarImagenLocal(KeyNode: key, Child: child)
    }
    
    
    static func guardarImagenLocal(KeyNode key: String, Child child: String, Data data: NSData) {
        UserDefaults.standard.set(data, forKey: "\(userID)-\(key)-\(child)")
        
    }
    
    
    
    static func eliminarImagenLocal(KeyNode key: String, Child child: String){
        UserDefaults.standard.removeObject(forKey: "\(userID)-\(key)-\(child)")
    }
    
    static func cargarImagen(KeyNode key: String, Child child: String, Image image: UIImageView){
        
        
        let dataIMG = UserDefaults.standard.object(forKey: "\(userID)-\(key)-\(child)") as? NSData
        if dataIMG != nil {
            image.image =  UIImage(data: dataIMG! as Data)
        }
        else {
            let userRef = storageRef.child(userID + key).child(child)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    image.image = UIImage(data: data!)
                    guardarImagenLocal(KeyNode: key, Child: child, Data: data! as NSData)
                }
            }
        }
        
    }
    
    
    static func cargarImagenEnBoton(KeyNode key: String, Child child: String, Boton boton: UIButton){
           
           
           let dataIMG = UserDefaults.standard.object(forKey: "\(userID)-\(key)-\(child)") as? NSData
           if dataIMG != nil {
            boton.setImage(UIImage(data: dataIMG! as Data), for: .normal)
           }
           else {
               let userRef = storageRef.child(userID + key).child(child)
               userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                   if error == nil {
                       boton.setImage(UIImage(data: data! as Data), for: .normal)
                       guardarImagenLocal(KeyNode: key, Child: child, Data: data! as NSData)
                   }
               }
           }
           
       }
    
    static func actualizarProducto(Reference ref2: DatabaseReference, IdProducto idProducto: String, Existencia existencia: Int) {
        let ruta = userID+"\(keyProductos)/\(idProducto)"
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()

        ref.child( ruta ).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            
            let existenciaActual: Int =  Int(value!.value(forKey: Configuraciones.keyExistencia) as? String ?? "0") ?? 0
            
            
            
            Configuraciones.guardarValorDirecto(Reference: ref, KeyNode: "\(Configuraciones.keyProductos)/\(idProducto)", KeyValue: Configuraciones.keyExistencia, Value: "\(existenciaActual + existencia)")
            
            print( "idProducto: \(idProducto)  Existencia: \(existenciaActual) Nuevo: \(existenciaActual + existencia)" )
            
        }) {(error) in
            
        }
        
        
    }
 
    
}
