//
//  ClienteUbicacionVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/20/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage


class ClienteUbicacionVC: UIViewController {
    @IBOutlet weak var fotoPersona: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var direccion: UITextView!
    @IBOutlet weak var mapa: MKMapView!
    
    var cliente: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cliente != nil {
            nombre.text = cliente?.value(forKey: Configuraciones.keyNombre) as? String
            telefono.text = cliente?.value(forKey: Configuraciones.keyTelefono) as? String
            direccion.text = cliente?.value(forKey: Configuraciones.keyCalle) as? String
            
            
            let storageRef = Storage.storage().reference()
            let codigo = cliente?.value(forKey: Configuraciones.keyId) as? String
            let userRef = storageRef.child(Configuraciones.keyClientes).child(codigo!)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.fotoPersona.image = img
                    
                    
                }
            }
            
            
            
            mapa.delegate = self
            var ubicacion: CLLocationCoordinate2D!
            
            if let lat = cliente!.value(forKey: Configuraciones.keyLat) as? String,
                let long = cliente!.value(forKey: Configuraciones.keyLong) as? String {
                
                let latitude = Double( lat ) ?? 0.0
                let longitude = Double( long ) ?? 0.0
                
                ubicacion = CLLocationCoordinate2DMake(latitude, longitude)
            }
            
            
            
            
            
            
            mapa.removeAnnotations(mapa.annotations)
            let artwork = Mapas(title: nombre.text!,
                                locationName: direccion.text!,
                                coordinate: ubicacion)
            
            
            mapa.addAnnotation(artwork)
            let coordinateRegion = MKCoordinateRegion(center: ubicacion,
                                                      latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapa.setRegion(coordinateRegion, animated: true)
            
            direccion.isEditable = false
            
        }

        // Do any additional setup after loading the view.
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
extension ClienteUbicacionVC:MKMapViewDelegate, UINavigationControllerDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! Mapas
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Mapas else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
}
