//
//  MapaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 15/06/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase


class MapaVC: UIViewController {

    @IBOutlet weak var Mapa: MKMapView!
    
    var codigo: String? = nil
    var nombre: String? = nil
    var lat1: Double? = nil
    var coord1: Double? = nil
    var ref: DatabaseReference!
    var cliente: NSDictionary? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if let lat = cliente!.value(forKey: Configuraciones.keyLat) as? String,
           let long = cliente!.value(forKey: Configuraciones.keyLong) as? String {
            self.lat1 = Double( lat ) ?? 0.0
            self.coord1 = Double( long ) ?? 0.0
        }
        
        
        
        if lat1 != nil {
        
            let PIN = MKPointAnnotation()
            PIN.title = nombre ?? "Casa"
                        
            
            let location = CLLocationCoordinate2D(latitude: lat1!, longitude:  coord1!)
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region =  MKCoordinateRegion(center: location, span: span)
            self.Mapa.setRegion(region, animated: true)
            
            PIN.coordinate = location
            self.Mapa.removeAnnotations(Mapa.annotations)
            self.Mapa.addAnnotation(PIN)
        }


        // Do any additional setup after loading the view.
    }
    
    @IBAction func fijarPIN(_ sender: UILongPressGestureRecognizer) {
        let loc = sender.location(in: self.Mapa)
        
        let coord = self.Mapa.convert(loc, toCoordinateFrom: self.Mapa)
        
        let PIN = MKPointAnnotation()
        PIN.title = nombre ?? "Casa"
        PIN.coordinate = coord
        self.Mapa.removeAnnotations(Mapa.annotations)
        self.Mapa.addAnnotation(PIN)
        
        
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyLat, Value: "\(coord.latitude)")
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyLong, Value: "\(coord.longitude)")
        
        cliente?.setValue("\(coord.latitude)", forKey: Configuraciones.keyLat)
        cliente?.setValue("\(coord.longitude)", forKey: Configuraciones.keyLong)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
