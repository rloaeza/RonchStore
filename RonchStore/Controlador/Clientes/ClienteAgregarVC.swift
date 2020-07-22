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
    
    var lat: Double? = nil
    var long: Double? = nil
    
  
    @IBOutlet weak var swPremium: UISwitch!
    @IBOutlet weak var apellidos: UITextField!
    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var nombre: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var calle: UITextField!
    @IBOutlet weak var colonia: UITextField!
    @IBOutlet weak var ciudad: UITextField!
    @IBOutlet weak var pais: UITextField!
    @IBOutlet weak var montoCredito: UITextField!
    @IBOutlet weak var imagenCasa: UIImageView!
    @IBOutlet weak var imagenPersona: UIImageView!
    
    
    var imagenMostrar: UIImageView!
    var ubicacion: CLLocationCoordinate2D!
    var opcionTipoPago: String = Configuraciones.keyTipoPagoSemanal
    
    
    
    
    @IBAction func guardarMontoCredito(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyMontoMaximo, Value: montoCredito.text!)
    }
    
    @IBAction func actualizarPremium(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyPremium, Value: swPremium.isOn)
    }
    @IBAction func guardarTelefono(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyTelefono, Value: telefono.text!)
    }
    
    @IBAction func guardarApellidos(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyApellidos, Value: apellidos.text!)
    }
    @IBAction func guardarNombre(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyNombre, Value: nombre.text!)
    }
    @IBAction func guardarEmail(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyEmail, Value: email.text!)
    }
    
    @IBAction func guardarCalle(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyCalle, Value: calle.text!)
    }
    @IBAction func guardarColonia(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyColonia, Value: colonia.text!)
    }
    @IBAction func guardarCiudad(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyCiudad, Value: ciudad.text!)
    }
    @IBAction func guardarPais(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyClientes, Child: codigo, KeyValue: Configuraciones.keyPais, Value: pais.text!)
    }
    
    
   
    @IBAction func botonTomarFotoCasa(_ sender: Any) {
        if codigo == nil {
            Configuraciones.alert(Titulo: "Error", Mensaje: "Debe llenar al menos un campo", self, popView: false)
            return
        }
        //imagenMostrar = imagenCasa
        //let imagePickerController = UIImagePickerController()
        //imagePickerController.delegate = self;
        //imagePickerController.sourceType = .camera
        //self.present(imagePickerController, animated: true, completion: nil)
        
        
        
        imagenMostrar = imagenCasa

        let alertaOrigenImagen = UIAlertController(title: "Adquirir imagen", message: "Seleccione la fuente de la imagen", preferredStyle: UIAlertController.Style.alert)

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self;
        alertaOrigenImagen.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action: UIAlertAction!) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))

        alertaOrigenImagen.addAction(UIAlertAction(title: "Galería", style: .default, handler: { (action: UIAlertAction!) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        present(alertaOrigenImagen, animated: true, completion: nil )
        
            
            
            
            
            
            
        
    }
    
    @IBAction func botonTomarFoto(_ sender: Any) {
        if codigo == nil {
            Configuraciones.alert(Titulo: "Error", Mensaje: "Debe llenar al menos un campo", self, popView: false)
            return
        }
        imagenMostrar = imagenPersona
        //let imagePickerController = UIImagePickerController()
        //imagePickerController.delegate = self;
        //imagePickerController.sourceType = .camera
        //self.present(imagePickerController, animated: true, completion: nil)
        
        let alertaOrigenImagen = UIAlertController(title: "Adquirir imagen", message: "Seleccione la fuente de la imagen", preferredStyle: UIAlertController.Style.alert)

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self;
        alertaOrigenImagen.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action: UIAlertAction!) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))

        alertaOrigenImagen.addAction(UIAlertAction(title: "Galería", style: .default, handler: { (action: UIAlertAction!) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        present(alertaOrigenImagen, animated: true, completion: nil )
        
        
    }
    
    
  
    func limpiar() {
        telefono.text = ""
        nombre.text = ""
        calle.text = ""
        colonia.text = ""
        ciudad.text = ""
        pais.text = ""
        email.text = ""
        montoCredito.text = ""
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
            apellidos.text = cliente!.value(forKey: Configuraciones.keyApellidos) as? String
            email.text = cliente!.value(forKey: Configuraciones.keyEmail) as? String
            calle.text = cliente!.value(forKey: Configuraciones.keyCalle) as? String
            colonia.text = cliente!.value(forKey: Configuraciones.keyColonia) as? String
            ciudad.text = cliente!.value(forKey: Configuraciones.keyCiudad) as? String
            pais.text = cliente!.value(forKey: Configuraciones.keyPais) as? String
            montoCredito.text = cliente!.value(forKey: Configuraciones.keyMontoMaximo) as? String
            
            
            
            let premium: Bool =  cliente!.value(forKey: Configuraciones.keyPremium) as? Bool ?? false
            
            swPremium.setOn(premium, animated: true)
            
            if let lat = cliente!.value(forKey: Configuraciones.keyLat) as? String,
               let long = cliente!.value(forKey: Configuraciones.keyLong) as? String {
                self.lat = Double( lat ) ?? 0.0
                self.long = Double( long ) ?? 0.0
            }
           
            //cliente = nil
            
            
            Configuraciones.cargarImagen(KeyNode: Configuraciones.keyClientes, Child: codigo!, Image: self.imagenPersona)
            Configuraciones.cargarImagen(KeyNode: Configuraciones.keyCasas, Child: codigo!, Image: self.imagenCasa)
            
        }
        else {
            limpiar()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactosDesdeAgregarCliente",
            let vc = segue.destination as? ClienteContactosSistemaVC {
            vc.delegate = self
        }
        
        if segue.identifier == "MapaDesdeAgregarCliente",
            let vc = segue.destination as? MapaVC {
            vc.codigo = self.codigo
            vc.lat1 = self.lat
            vc.coord1 = self.long
            vc.nombre = self.nombre.text!
            vc.cliente = cliente
        
        }
       
    }
    
}



extension ClienteAgregarVC: ClienteContactosSistemaVCDelegate {
    func contactoSeleccionado(contacto: Contacto) {
        self.nombre.text = contacto.nombre
        self.telefono.text = contacto.telefono
        self.calle.text = contacto.calle
        self.email.text = contacto.email
        self.ciudad.text = contacto.ciudad
        self.pais.text = contacto.pais
        
        
        
        guardarNombre(self)
        guardarTelefono(self)
        guardarCalle(self)
        guardarEmail(self)
        guardarCiudad(self)
        guardarPais(self)
        
        
        
    }
    
    
}




extension ClienteAgregarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imagenMostrar.image = image
        //imagenMostrar.setImage(image, for: UIControl.State.normal)
        
        
        //imagenCasa2.setImage(image, for: UIControl.State.normal)
        self.dismiss(animated: true, completion: nil)
        
        
        
        let data = image!.jpegData(compressionQuality: 0.25)! as NSData
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        let key = self.imagenMostrar==self.imagenCasa ? Configuraciones.keyCasas : Configuraciones.keyClientes
        
        let userRef = storageRef.child(Configuraciones.userID + key).child(codigo!)
        
        Configuraciones.guardarImagenLocal(KeyNode: key, Child: codigo!, Data: data)
        
        
        
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
