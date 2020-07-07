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
