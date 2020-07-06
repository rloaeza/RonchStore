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

    static func hoy(Fecha fecha: String) -> Void{
        
        var fecha2 = "2020-07-03 22:55"
        fecha2 = fecha
        
        let index = fecha2.index(fecha2.startIndex, offsetBy: 10)
        fecha2 = String( fecha2.prefix(upTo: index) ) + " 00:00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = keyDateFormat
        
        
        var dateVenta = dateFormatter.date(from:fecha2)!
                
        
        print( "La fecha Original es:\(fecha) \n\n")
        print( "La fecha en 0's es:\(fecha2) \n\n")
        print( "La fecha es:\(dateVenta) \n\n")
    
                
        dateVenta = buscarSiguienteDia(Fecha: dateVenta, Dia: 1)
        print( buscarSiguienteDia(Fecha: dateVenta, Dia: 1) )
        
        
    
        print( "\n\n" )
            
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
