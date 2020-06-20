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
    var ref: DatabaseReference!
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var costo: UITextField!
    @IBOutlet weak var costoVenta: UITextField!
    @IBOutlet weak var existencia: UITextField!
    @IBOutlet weak var imagenProducto: UIButton!
    
    @IBOutlet weak var botonMarca: UIButton!
    @IBOutlet weak var botonTalla: UIButton!
    @IBOutlet weak var botonCategoria: UIButton!
    
    @IBOutlet weak var botonNombre: UIButton!
    @IBOutlet weak var botonCosto: UIButton!
    @IBOutlet weak var botonCostoVenta: UIButton!
    @IBOutlet weak var botonExistencia: UIButton!
    
    
    
    @IBAction func botonTomarFotoProducto(_ sender: Any) {
        
        
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
    
    
 
    
    @IBAction func guardarNombre(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyNombre, Value: nombre.text!)
    }
    
    @IBAction func guardarCosto(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCosto, Value: costo.text!)
    }
    
    @IBAction func guardarCostoVenta(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCostoVenta, Value: costoVenta.text!)
    }
    @IBAction func guardarExistencia(_ sender: Any) {
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyExistencia, Value: existencia.text!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        if producto != nil {
            codigo =  producto!.value(forKey: Configuraciones.keyId) as? String
            
            botonMarca.setTitle(producto!.value(forKey: Configuraciones.keyMarca) as? String, for: .normal)
            botonTalla.setTitle(producto!.value(forKey: Configuraciones.keyTalla) as? String, for: .normal)
            botonCategoria.setTitle(producto!.value(forKey: Configuraciones.keyCategorias) as? String, for: .normal)
            botonNombre.setTitle(producto!.value(forKey: Configuraciones.keyNombre) as? String, for: .normal)
            botonCosto.setTitle(producto!.value(forKey: Configuraciones.keyCosto) as? String, for: .normal)
            botonCostoVenta.setTitle(producto!.value(forKey: Configuraciones.keyCostoVenta) as? String, for: .normal)
            botonExistencia.setTitle(producto!.value(forKey: Configuraciones.keyExistencia) as? String, for: .normal)

     
            producto = nil
            
            //cargando imagen
            
            /*
            let storageRef = Storage.storage().reference()
            
            let userRef = storageRef.child(Configuraciones.keyProductos).child(codigo!)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                    let img = UIImage(data: data!)
                    self.imagenProducto.setImage(img, for: UIControl.State.normal)
                }
            }
            */
            Configuraciones.cargarImagenEnBoton(KeyNode: Configuraciones.keyProductos, Child: codigo!, Boton: self.imagenProducto)

            
            
            
        }
        else {
            codigo = nil
            
            
            
            botonNombre.titleLabel?.text = Configuraciones.txtSeleccionarNombre
            botonMarca.titleLabel?.text = Configuraciones.txtSeleccionarMarca
            botonTalla.titleLabel?.text = Configuraciones.txtSeleccionarTalla
            botonCosto.titleLabel?.text = Configuraciones.txtSeleccionarCosto
            botonCostoVenta.titleLabel?.text = Configuraciones.txtSeleccionarCostoVenta
            botonExistencia.titleLabel?.text = Configuraciones.txtSeleccionarExistencia
            
            //nombre.select(nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "MarcaDesdeAgregarProducto",
            let vc = segue.destination as? MarcaVC {
                vc.delegate = self
        }
        
        if segue.identifier == "TallaDesdeAgregarProducto",
            let vc = segue.destination as? TallaVC {
                vc.delegate = self
        }
        
        if segue.identifier == "CategoriaDesdeAgregarProducto",
            let vc = segue.destination as? CategoriaVC {
            vc.delegate = self
        }
        */
        
        if segue.identifier == "DetallesProductoListaDesdeProductosParaCategoria",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Categoria"
            vc.detalleKey = Configuraciones.keyDetalleProductoCategoria
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaMarca",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Marca"
            vc.detalleKey = Configuraciones.keyDetalleProductoMarca
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaTalla",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Talla"
            vc.detalleKey = Configuraciones.keyDetalleProductoTalla
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaNombre",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Nombre"
            vc.detalleKey = Configuraciones.keyDetalleProductoNombre
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaCosto",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Costo"
            vc.detalleKey = Configuraciones.keyDetalleProductoCosto
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaCostoVenta",
                  let vc = segue.destination as? DetallesProductoListaVC {
                  vc.delegate = self
                  vc.title = "Costo de venta"
                  vc.detalleKey = Configuraciones.keyDetalleProductoCostoVenta
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaExistencia",
              let vc = segue.destination as? DetallesProductoListaVC {
              vc.delegate = self
              vc.title = "Existencia"
              vc.detalleKey = Configuraciones.keyDetalleProductoExistencia
        }
        
        
        //
    }
    

}






extension ProductoAgregarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        //imagenMostrar.image = image
        imagenProducto.setImage(image, for: UIControl.State.normal)
        
        
        //imagenCasa2.setImage(image, for: UIControl.State.normal)
        self.dismiss(animated: true, completion: nil)
        
        
        
        let data = image!.jpegData(compressionQuality: 0.25)! as NSData
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference()
        let key = Configuraciones.keyProductos
        
        if codigo == nil {
            guardarNombre(self)
        }
        let userRef = storageRef.child(key).child(codigo!)
        
        
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


extension ProductoAgregarVC: MarcaVCDelegate {
    func marcaSeleccionada(nombre: String) {
        botonMarca.setTitle(nombre, for: .normal)
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyMarca, Value: nombre)
        
    }
    
    
}

extension ProductoAgregarVC: TallaVCDelegate {
    func tallaSeleccionada(nombre: String) {
        botonTalla.setTitle(nombre, for: .normal)
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyTalla, Value: nombre)
    }
    
    
}

extension ProductoAgregarVC: CategoriaVCDelegate {
    func categoriaSeleccionada(nombre: String) {
        botonCategoria.setTitle(nombre, for: .normal)
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCategorias, Value: nombre)
    }
    
    
}




extension ProductoAgregarVC: DetallesProductoListaVCDelegate {
    func valorSeleccionado(nombre: String, detalle: String) {
        
        switch detalle {
            
        case Configuraciones.keyDetalleProductoMarca:
             botonMarca.setTitle(nombre, for: .normal)
             codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyMarca, Value: nombre)
             break
        case Configuraciones.keyDetalleProductoTalla:
            botonTalla.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyTalla, Value: nombre)
            break
        case Configuraciones.keyDetalleProductoCategoria:
            botonCategoria.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCategorias, Value: nombre)
            break
        case Configuraciones.keyDetalleProductoNombre:
            botonNombre.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyNombre, Value: nombre)
            break
        case Configuraciones.keyDetalleProductoCosto:
            botonCosto.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCosto, Value: nombre)
            break
        case Configuraciones.keyDetalleProductoCostoVenta:
            botonCostoVenta.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCostoVenta, Value: nombre)
            break
        case Configuraciones.keyDetalleProductoExistencia:
               botonExistencia.setTitle(nombre, for: .normal)
               codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyExistencia, Value: nombre)
               break
        default:
            break
        }
        
    }
    
    
}
