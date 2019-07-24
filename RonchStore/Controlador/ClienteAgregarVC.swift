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

class ClienteAgregarVC: UIViewController{
    
    var cliente: NSDictionary? = nil

    @IBOutlet weak var telefono: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var direccion: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var botonEliminar: UIButton!
    @IBOutlet weak var foto: UIImageView!
    
    @IBAction func botonTomarFoto(_ sender: Any) {
        if telefono.text!.isEmpty {
            Configuraciones.alert(Titulo: "Error", Mensaje: "No existe telefono", self, popView: false)
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
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
                    self.foto.image = img
                }
            }
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
        let userRef = storageRef.child(Configuraciones.keyClientes).child(telefono.text!)
        
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
