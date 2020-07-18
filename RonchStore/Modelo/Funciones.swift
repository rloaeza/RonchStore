//
//  Funciones.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 06/07/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import Foundation


class Funciones {
    static let keyDateFormat = "yyyy-MM-dd HH:mm"
    
    static let diasSemana = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
    static let diasMes = [1...31]

    
    static func siguienteFecha(Venta venta: NSDictionary?) -> String {
        let tipoPago = venta?.value(forKey: Configuraciones.keyTipoPago) as? String ?? Configuraciones.keyTipoPagoSemanal
        
        let fecha: String = venta!.value(forKey: Configuraciones.keyFechaCobro) as? String ?? ""
        let index = fecha.index(fecha.startIndex, offsetBy: 10)
        let fecha2 = String( fecha.prefix(upTo: index) ) + " 00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = keyDateFormat
        var fechaSig : Date = dateFormatter.date(from:fecha2)!
    
        switch tipoPago {
        case Configuraciones.keyTipoPagoSemanal:
            
            var diaSemana: Int = 1
            for dia in Funciones.diasSemana {
                if venta?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "Domingo" == dia {
                    break
                }
                diaSemana = diaSemana + 1
            }
            fechaSig = Funciones.buscarSiguienteDia(Fecha: fechaSig, Dia: diaSemana )
            break
        case Configuraciones.keyTipoPagoQuincenal:
            fechaSig = Funciones.buscarSiguienteQuincena(Fecha: fechaSig)
            break
        case Configuraciones.keyTipoPagoMensual:
            fechaSig = Funciones.buscarSiguienteFecha(Fecha: fechaSig, Dia: Int(venta?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "1") ?? 1 )
            break
        default:
            break
        }
        
        return Funciones.fechaAString(Fecha: fechaSig )
    }
    
    static func siguienteFechaInicial(Venta venta: NSDictionary?) -> String {
        var primerCobro = venta?.value(forKey: Configuraciones.keyOmitirFechaPrimerCobro) as? Bool ?? false
        var fechaSig: Date = Date()
        let tipoPago = venta?.value(forKey: Configuraciones.keyTipoPago) as? String ?? Configuraciones.keyTipoPagoSemanal
        
        
        primerCobro = !primerCobro
        repeat {
            switch tipoPago {
            case Configuraciones.keyTipoPagoSemanal:
                
                var diaSemana: Int = 1
                for dia in Funciones.diasSemana {
                    if venta?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "Domingo" == dia {
                        break
                    }
                    diaSemana = diaSemana + 1
                }
                fechaSig = Funciones.buscarSiguienteDia(Fecha: fechaSig, Dia: diaSemana )
                break
            case Configuraciones.keyTipoPagoQuincenal:
                fechaSig = Funciones.buscarSiguienteQuincena(Fecha: fechaSig)
                break
            case Configuraciones.keyTipoPagoMensual:
                fechaSig = Funciones.buscarSiguienteFecha(Fecha: fechaSig, Dia: Int(venta?.value(forKey: Configuraciones.keyDiaCobro) as? String ?? "1") ?? 1 )
                break
            default:
                break
            }
            primerCobro = !primerCobro
        } while( primerCobro )
        
        return Funciones.fechaAString(Fecha: fechaSig )
    }
    
    static func ventaAtrasada(Fecha fecha: String) -> Int{
 
        let index = fecha.index(fecha.startIndex, offsetBy: 10)
        let fecha2 = String( fecha.prefix(upTo: index) ) + " 00:00"
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = keyDateFormat
                
        let dateVenta = dateFormatter.date(from:fecha2)!
        let hoy = Date()
        
        var resultado: Int = 0
        switch compareDate(date1: dateVenta, date2: hoy) {
        case ComparisonResult.orderedSame:
            resultado = 1  // Dia actual
            break
        case ComparisonResult.orderedAscending:
            resultado = 2  // Varios dias de atraso
            break
        case ComparisonResult.orderedDescending:
            resultado = 0  // Aun faltan dias
            break
        default:
            break
        }
        return resultado
    }
    
    
    static func compareDate(date1:Date, date2:Date) -> ComparisonResult {
        
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        return order
    }
    
    static func buscarSiguienteDia(Fecha fecha: Date, Dia dia: Int) -> Date {
        var fechaNueva = fecha.addingTimeInterval(60*60*24)
        var componentes = Calendar.current.dateComponents([.month, .day, .weekday], from: fechaNueva)
        while( componentes.weekday != dia ) {
            fechaNueva = fechaNueva.addingTimeInterval(60*60*24)
            componentes = Calendar.current.dateComponents([.month, .day, .weekday], from: fechaNueva)
        }
        return fechaNueva
    }
    
    static func buscarSiguienteQuincena(Fecha fecha: Date) -> Date {
        var fechaNueva = fecha.addingTimeInterval(60*60*24)
        var componentes = Calendar.current.dateComponents([.month, .day, .weekday], from: fechaNueva)
        while( true ) {
            if componentes.day == 1  || componentes.day == 15 {
                break
            }
            fechaNueva = fechaNueva.addingTimeInterval(60*60*24)
            componentes = Calendar.current.dateComponents([.month, .day, .weekday], from: fechaNueva)
        }
        return fechaNueva
    }
    static func buscarSiguienteFecha(Fecha fecha: Date, Dia dia: Int) -> Date {
        var fechaNueva = fecha.addingTimeInterval(60*60*24)
        var componentes = Calendar.current.dateComponents([.month, .day, .weekday], from: fechaNueva)
        while( componentes.day != dia ) {
            fechaNueva = fechaNueva.addingTimeInterval(60*60*24)
            componentes = Calendar.current.dateComponents([.month, .day, .weekday], from: fechaNueva)
        }
        return fechaNueva
    }
    
    static func fechaAString(Fecha fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = keyDateFormat
        return formatter.string(from: fecha)
    }
    
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
    
    
}
