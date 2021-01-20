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
import BarcodeScanner

class ProductoAgregarVC: UIViewController {
    
    var producto: NSDictionary? = nil
    var codigo: String? = nil
    var ref: DatabaseReference!
    var categoriaSeleccionada: String? = nil
    var productosDuplicados = 1
    
    @IBOutlet weak var imagenProducto: UIButton!
    
    @IBOutlet weak var botonMarca: UIButton!
    @IBOutlet weak var botonTalla: UIButton!
    @IBOutlet weak var botonCategoria: UIButton!
    
    @IBOutlet weak var botonNombre: UIButton!
    @IBOutlet weak var botonCosto: UIButton!
    @IBOutlet weak var botonCostoVenta: UIButton!
    @IBOutlet weak var botonExistencia: UIButton!
    @IBOutlet weak var lblCodigoBarras: UILabel!
    @IBOutlet weak var botonDuplicar: UIButton!
    
    
    
    @IBAction func botonDuplicarProducto(_ sender: Any) {
        productosDuplicados += 1
        lblCodigoBarras.text = nil
        codigo = nil
        let imgProducto = UIImage(named: "noproducto")

        imagenProducto.setImage(imgProducto, for: UIControl.State.normal)

       
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCategorias, Value: botonCategoria.title(for: .normal))
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyMarca, Value: botonMarca.title(for: .normal))
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyTalla, Value: botonTalla.title(for: .normal))
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyNombre, Value: botonNombre.title(for: .normal))
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCosto, Value: botonCosto.title(for: .normal))
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCostoVenta, Value: botonCostoVenta.title(for: .normal))
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyExistencia, Value: botonExistencia.title(for: .normal))
        
        
        
        botonDuplicar.setTitle(Configuraciones.txtDuplicarProducto + "(\(productosDuplicados)) ", for: .normal)
        
    }
    
    @IBAction func botonLeerCodigoDeBarras(_ sender: Any) {
        
        let viewController = BarcodeScannerViewController()
        viewController.messageViewController.messages.scanningText=Configuraciones.txtBarCodeSearch
        viewController.codeDelegate = self
        //viewController.errorDelegate = self
        viewController.dismissalDelegate = self

        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func botonTomarFotoProducto(_ sender: Any) {
        if codigo == nil {
            Configuraciones.alert(Titulo: Configuraciones.txtError, Mensaje: Configuraciones.txtErrorLlenarCampos, self, popView: false)
            return
        }
        
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
    
    
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        if producto != nil {
            codigo =  producto!.value(forKey: Configuraciones.keyId) as? String
            
            lblCodigoBarras.text = producto!.value(forKey: Configuraciones.keyBarCode) as? String ?? ""
            
            botonMarca.setTitle(producto!.value(forKey: Configuraciones.keyMarca) as? String, for: .normal)
            botonTalla.setTitle(producto!.value(forKey: Configuraciones.keyTalla) as? String, for: .normal)
            botonCategoria.setTitle(producto!.value(forKey: Configuraciones.keyCategorias) as? String, for: .normal)
            botonNombre.setTitle(producto!.value(forKey: Configuraciones.keyNombre) as? String, for: .normal)
            botonCosto.setTitle(producto!.value(forKey: Configuraciones.keyCosto) as? String, for: .normal)
            botonCostoVenta.setTitle(producto!.value(forKey: Configuraciones.keyCostoVenta) as? String, for: .normal)
            botonExistencia.setTitle(producto!.value(forKey: Configuraciones.keyExistencia) as? String, for: .normal)

     
            producto = nil
            
            Configuraciones.cargarImagenEnBoton(KeyNode: Configuraciones.keyProductos, Child: codigo!, Boton: self.imagenProducto)

            
            
            
        }
        else {
            codigo = nil
            
            
            
            botonNombre.titleLabel?.text = Configuraciones.datosProductoNuevo.value(forKey: Configuraciones.keyNombre) as? String ?? Configuraciones.txtSeleccionarNombre
            botonMarca.titleLabel?.text = Configuraciones.txtSeleccionarMarca
            botonTalla.titleLabel?.text = Configuraciones.txtSeleccionarTalla
            botonCosto.titleLabel?.text = Configuraciones.txtSeleccionarCosto
            botonCostoVenta.titleLabel?.text = Configuraciones.txtSeleccionarCostoVenta
            botonExistencia.titleLabel?.text = Configuraciones.txtSeleccionarExistencia
            
            //nombre.select(nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        if segue.identifier == "DetallesProductoListaDesdeProductosParaCategoria",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Categoria"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoCategoria
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoCategoria
            vc.tipoTeclado = UIKeyboardType.alphabet
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaMarca",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Marca"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoMarca
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoMarca + categoriaSeleccionada!
            vc.tipoTeclado = UIKeyboardType.alphabet
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaTalla",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Talla"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoTalla
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoTalla + categoriaSeleccionada!

            vc.tipoTeclado = UIKeyboardType.alphabet
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaNombre",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Nombre"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoNombre
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoNombre+categoriaSeleccionada!
            vc.tipoTeclado = UIKeyboardType.alphabet
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaCosto",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Costo"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoCosto
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoCosto + categoriaSeleccionada!
            vc.tipoTeclado = UIKeyboardType.numberPad
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaCostoVenta",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Costo de venta"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoCostoVenta
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoCostoVenta + categoriaSeleccionada!
            vc.tipoTeclado = UIKeyboardType.numberPad
        }
        if segue.identifier == "DetallesProductoListaDesdeProductosParaExistencia",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Existencia"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoExistencia
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoExistencia + categoriaSeleccionada!
            vc.tipoTeclado = UIKeyboardType.numberPad
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


extension ProductoAgregarVC: DetallesProductoListaVCDelegate {
    func valorSeleccionado(nombre: String, detalle: String) {
        
        switch detalle {
            
        case Configuraciones.keyDatosDetalleProductoMarca:
             botonMarca.setTitle(nombre, for: .normal)
             codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyMarca, Value: nombre)
             break
        case Configuraciones.keyDatosDetalleProductoTalla:
            botonTalla.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyTalla, Value: nombre)
            break
        case Configuraciones.keyDatosDetalleProductoCategoria:
            botonCategoria.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCategorias, Value: nombre)
            categoriaSeleccionada = nombre
            break
        case Configuraciones.keyDatosDetalleProductoNombre:
            botonNombre.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyNombre, Value: nombre)
            break
        case Configuraciones.keyDatosDetalleProductoCosto:
            botonCosto.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCosto, Value: nombre)
            break
        case Configuraciones.keyDatosDetalleProductoCostoVenta:
            botonCostoVenta.setTitle(nombre, for: .normal)
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyCostoVenta, Value: nombre)
            break
        case Configuraciones.keyDatosDetalleProductoExistencia:
               botonExistencia.setTitle(nombre, for: .normal)
               codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyExistencia, Value: nombre)
               break
        default:
            break
        }
    }
}


extension ProductoAgregarVC: BarcodeScannerCodeDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    
    self.lblCodigoBarras.text = code
    codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyProductos, Child: codigo, KeyValue: Configuraciones.keyBarCode, Value: code)
    
    
    controller.dismiss(animated: true, completion: nil)
  }
}

extension ProductoAgregarVC: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
