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

    static func hoy(Fecha fecha: String) -> Void{
        
        var fecha2 = "2020-07-06 22:55"
        fecha2 = fecha
        
        let index = fecha2.index(fecha2.startIndex, offsetBy: 10)
        fecha2 = String( fecha2.prefix(upTo: index) ) + " 00:00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = keyDateFormat
        
        
        var dateVenta = dateFormatter.date(from:fecha2)!
                
        dateVenta = buscarSiguienteDia(Fecha: dateVenta, Dia: 1)
        
        let hoy = Date()
        
        
        switch compareDate(date1: dateVenta, date2: hoy) {
        case ComparisonResult.orderedSame:
            print ( "Es hoy" )
            break
        case ComparisonResult.orderedAscending:
            print( "Ya se paso" )
            break
        case ComparisonResult.orderedDescending:
            print( "Aun faltan dias" )
            break
        default:
            break
        }
            
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
