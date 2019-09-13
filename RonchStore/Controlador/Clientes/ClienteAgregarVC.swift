//
//  ClienteAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import MapKit

class ClienteAgregarVC: UIViewController{
    
    var cliente: NSDictionary? = nil
    var codigo: String? = nil
    var ref: DatabaseReference!
    
    

    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var email: UITextField!
    //@IBOutlet weak var imagenPersona: UIImageView!
    //@IBOutlet weak var imagenCasa: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagenCasa: UIButton!
    @IBOutlet weak var imagenPersona: UIButton!
    @IBOutlet weak var imagenCasa2: UIButton!
    var imagenMostrar: UIButton!
    var ubicacion: CLLocationCoordinate2D!
    
    
    @IBAction func guardarTelefono(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyTelefono, Value: telefono.text!)
    }
    
    @IBAction func guardarNombre(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyNombre, Value: nombre.text!)
    }
    @IBAction func guardarEmail(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyEmail, Value: email.text!)
    }
    
    @IBAction func guardarDireccion(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyDireccion, Value: direccion.text!)
    }
    
    
    
    @IBAction func botonGPS(_ sender: Any) {
        
        ubicacion = mapView.convert(CGPoint(x: mapView.bounds.width / 2, y: mapView.bounds.height / 2), toCoordinateFrom: mapView)

        mapView.removeAnnotations(mapView.annotations)
        let artwork = Mapas(title: nombre.text!,
                            locationName: direccion.text!,
                            coordinate: ubicacion)
        
        
        mapView.addAnnotation(artwork)
        let coordinateRegion = MKCoordinateRegion(center: ubicacion,
                                                  latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(coordinateRegion, animated: true)
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyLat, Value: "\(ubicacion.latitude)")
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyLong, Value: "\(ubicacion.longitude)")
        
        
        

    }
    @IBAction func botonTomarFotoCasa(_ sender: Any) {
        if codigo == nil {
            Configuraciones.alert(Titulo: "Error", Mensaje: "Debe llenar al menos un campo", self, popView: false)
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagenMostrar = imagenCasa
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func botonTomarFoto(_ sender: Any) {
        if codigo == nil {
            Configuraciones.alert(Titulo: "Error", Mensaje: "Debe llenar al menos un campo", self, popView: false)
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagenMostrar = imagenPersona
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    
  
    func limpiar() {
        telefono.text = ""
        nombre.text = ""
        direccion.text = ""
        email.text = ""
        telefono.select(nil)
    }
    
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        if cliente != nil {
            codigo =  cliente!.value(forKey: Configuraciones.keyId) as? String
            telefono.text = cliente!.value(forKey: Configuraciones.keyTelefono) as? String
            nombre.text = cliente!.value(forKey: Configuraciones.keyNombre) as? String
            direccion.text = cliente!.value(forKey: Configuraciones.keyDireccion) as? String
            email.text = cliente!.value(forKey: Configuraciones.keyEmail) as? String
            
            
            
            
            if let lat = cliente!.value(forKey: Configuraciones.keyLat) as? String,
               let long = cliente!.value(forKey: Configuraciones.keyLong) as? String {
                
                let latitude = Double( lat ) ?? 0.0
                let longitude = Double( long ) ?? 0.0
                
                ubicacion = CLLocationCoordinate2DMake(latitude, longitude)
            }
            
    
            cliente = nil
            
            let storageRef = Storage.storage().reference()
            
            let userRef = storageRef.child(Configuraciones.keyClientes).child(codigo!)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imagenPersona.setImage(img, for: UIControl.State.normal)
                }
            }
            
            
            let homeRef = storageRef.child(Configuraciones.keyCasas).child(codigo!)
            homeRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imagenCasa.setImage(img, for: UIControl.State.normal)
                }
            }
            
            mapView.delegate = self
            
            
            
            if ubicacion != nil {
                //let regionRadius: CLLocationDistance = 1000
                mapView.removeAnnotations(mapView.annotations)
                let artwork = Mapas(title: nombre.text!,
                                      locationName: direccion.text!,
                                      coordinate: ubicacion)
                
                
                mapView.addAnnotation(artwork)
                let coordinateRegion = MKCoordinateRegion(center: ubicacion,
                                                          latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(coordinateRegion, animated: true)
            }
            
            
        }
        else {
            limpiar()
        }
    }
}


extension ClienteAgregarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //imagenMostrar.image = image
        imagenMostrar.setImage(image, for: UIControl.State.normal)
        
        
        //imagenCasa2.setImage(image, for: UIControl.State.normal)
        self.dismiss(animated: true, completion: nil)
        
        
        
        let data = image!.jpegData(compressionQuality: 0.8)! as NSData
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        let key = self.imagenMostrar==self.imagenCasa ? Configuraciones.keyCasas : Configuraciones.keyClientes
        
        let userRef = storageRef.child(key).child(codigo!)
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        
        _ = userRef.putData(data as Data, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                Configuraciones.alert(Titulo: "Imagen", Mensaje: "Error al subir imagen", self, popView: false)
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.tintColor = UIColor.blue
                return
            }
            
            Configuraciones.alert(Titulo: "Imagen", Mensaje: "Carga satisfactoria", self, popView: false)
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.tintColor = UIColor.blue

        }


        
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension ClienteAgregarVC:MKMapViewDelegate {
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
