//
//  ProductoAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ProductoAgregarVC: UIViewController {
    
    var producto: NSDictionary? = nil
    var codigo: String? = nil
    
    @IBOutlet weak var botonEliminar: UIButton!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var marca: UITextField!
    @IBOutlet weak var talla: UITextField!
    @IBOutlet weak var costo: UITextField!
    @IBOutlet weak var costoVenta: UITextField!
    @IBOutlet weak var existencia: UITextField!
    @IBOutlet weak var imagenProducto: UIButton!
    
    
   
    @IBAction func botonTomarFotoProducto(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        
    }
    
    
    @IBAction func botonEliminar(_ sender: Any) {
        let alert = UIAlertController(title: "¿Eliminar?", message: "¿Esta seguro de eliminar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (UIAlertAction) in
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(self.codigo!).setValue(nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
    }
    @IBAction func botonGuardar(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let newKey: DatabaseReference!
        if codigo == nil {
            newKey = ref.child(Configuraciones.keyProductos).childByAutoId()
        }
        else {
            newKey = ref.child(Configuraciones.keyProductos).child(codigo!)
        }
        newKey.setValue([
            Configuraciones.keyNombre:nombre.text,
            Configuraciones.keyMarca:marca.text,
            Configuraciones.keyTalla:talla.text,
            Configuraciones.keyCosto:costo.text,
            Configuraciones.keyCostoVenta:costoVenta.text,
            Configuraciones.keyExistencia:existencia.text
            ])
        codigo = newKey.key
        
        Configuraciones.alert(Titulo: "Productos", Mensaje: "Producto guardado", self, popView: true)

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if producto != nil {
            codigo =  producto!.value(forKey: Configuraciones.keyId) as? String
            nombre.text = producto!.value(forKey: Configuraciones.keyNombre) as? String
            marca.text = producto!.value(forKey: Configuraciones.keyMarca) as? String
            talla.text = producto!.value(forKey: Configuraciones.keyTalla) as? String
            costo.text = producto!.value(forKey: Configuraciones.keyCosto) as? String
            costoVenta.text = producto!.value(forKey: Configuraciones.keyCostoVenta) as? String
            existencia.text = producto!.value(forKey: Configuraciones.keyExistencia) as? String
            botonEliminar.isHidden = false
            producto = nil
            
            //cargando imagen
            let storageRef = Storage.storage().reference()
            
            let userRef = storageRef.child(Configuraciones.keyProductos).child(codigo!)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imagenProducto.setImage(img, for: UIControl.State.normal)
                }
            }
            
        }
        else {
            codigo = nil
            nombre.text = ""
            marca.text = ""
            talla.text = ""
            costo.text = ""
            costoVenta.text = ""
            existencia.text = ""
            nombre.select(nil)
            botonEliminar.isHidden = true
        }
    }
    

}






extension ProductoAgregarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //imagenMostrar.image = image
        imagenProducto.setImage(image, for: UIControl.State.normal)
        
        
        //imagenCasa2.setImage(image, for: UIControl.State.normal)
        self.dismiss(animated: true, completion: nil)
        
        
        
        let data = image!.jpegData(compressionQuality: 0.8)! as NSData
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        let key = Configuraciones.keyProductos
        
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

