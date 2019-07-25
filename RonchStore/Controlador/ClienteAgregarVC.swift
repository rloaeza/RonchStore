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

    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var botonEliminar: UIButton!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var imagenPersona: UIImageView!
    @IBOutlet weak var imagenCasa: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var imagen: UIImageView!
    
    @IBAction func botonTomarFotoCasa(_ sender: Any) {
        if telefono.text!.isEmpty {
            Configuraciones.alert(Titulo: "Error", Mensaje: "No existe telefono", self, popView: false)
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagen = imagenCasa
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBAction func botonTomarFoto(_ sender: Any) {
        if telefono.text!.isEmpty {
            Configuraciones.alert(Titulo: "Error", Mensaje: "No existe telefono", self, popView: false)
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagen = imagenPersona
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    @IBAction func botonGuardar(_ sender: Any) {
        if telefono.text!.isEmpty {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child(Configuraciones.keyClientes).child(telefono.text!).setValue([Configuraciones.keyTelefono: telefono.text!, Configuraciones.keyNombre: nombre.text!, Configuraciones.keyDireccion: direccion.text!,Configuraciones.keyEmail: email.text!])
        
        Configuraciones.alert(Titulo: "Clientes", Mensaje: "Cliente guardado", self, popView: true)

        
    }
    
  
    func limpiar() {
        telefono.text = ""
        nombre.text = ""
        direccion.text = ""
        email.text = ""
        telefono.select(nil)
    }
    
    @IBAction func botonEliminar(_ sender: Any) {
        let alert = UIAlertController(title: "¿Eliminar?", message: "¿Esta seguro de eliminar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (UIAlertAction) in
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyClientes).child(self.telefono.text!).setValue(nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)

        }))
        
        self.present(alert, animated: true)
        
        
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if cliente != nil {
            telefono.text = cliente!.value(forKey: Configuraciones.keyTelefono) as? String
            nombre.text = cliente!.value(forKey: Configuraciones.keyNombre) as? String
            direccion.text = cliente!.value(forKey: Configuraciones.keyDireccion) as? String
            email.text = cliente!.value(forKey: Configuraciones.keyEmail) as? String
            telefono.isEnabled = false
            botonEliminar.isHidden = false
            cliente = nil
            
            let storageRef = Storage.storage().reference()
            
            let userRef = storageRef.child(Configuraciones.keyClientes).child(telefono.text!)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imagenPersona.image = img
                }
            }
            
            
            let homeRef = storageRef.child(Configuraciones.keyCasas).child(telefono.text!)
            homeRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imagenCasa.image = img
                }
            }
            
            mapView.delegate = self
            let initialLocation = CLLocation(latitude: 19.6460889, longitude: -102.0513349)
            let regionRadius: CLLocationDistance = 1000
            
            //
            
            
            let locat = CLLocationCoordinate2D(latitude: 19.5130623, longitude: -101.6106347)
            let artwork = Mapas(title: nombre.text!,
                                  locationName: direccion.text!,                            
                                  coordinate: locat)
            mapView.addAnnotation(artwork)
            
            let coordinateRegion = MKCoordinateRegion(center: locat,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            let location = mapView.annotations[0] as! Mapas
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
           // location.mapItem().openInMaps(launchOptions: launchOptions)
            
            
            
            
        }
        else {
            limpiar()
            telefono.isEnabled = true
            botonEliminar.isHidden = true
        }
    }
}


extension ClienteAgregarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        foto.image = image
        self.dismiss(animated: true, completion: nil)
        
        
        
        let data = image!.jpegData(compressionQuality: 0.8)! as NSData
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        let key = self.imagen==self.imagenCasa ? Configuraciones.keyCasas : Configuraciones.keyClientes
        
        let userRef = storageRef.child(key).child(telefono.text!)
        
        let uploadTask = userRef.putData(data as Data, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                Configuraciones.alert(Titulo: "Imagen", Mensaje: "Error al subir imagen", self, popView: false)
                return
            }
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
