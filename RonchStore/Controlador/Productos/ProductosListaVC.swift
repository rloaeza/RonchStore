//
//  ProductosListaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 9/12/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import BarcodeScanner



protocol ProductosListaVCDelegate {
    func productoSeleccionado(productos: [NSDictionary])
}


class ProductosListaVC: UIViewController {
    
    var delegate: ProductosListaVCDelegate?
    
    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var categoriaSeleccionada: String = ""
    var marcaSeleccionada: String = ""
    var tallaSeleccionada: String = ""
    var textoSeleccionado: String = ""
    
    var montoDisponible: Double = 0.0
    var validarCantidades: Bool = false
    @IBOutlet weak var productosViewController: UITableView!
    @IBOutlet weak var barraBusqueda: UISearchBar!
    
    private func actualizarDatos() {
        valoresParaMostrar = Datos.getProductos(Patron: textoSeleccionado, Productos: valores)
        productosViewController.reloadData()
    }
    
    @IBAction func botonCodigoBarras(_ sender: Any) {
        let viewController = BarcodeScannerViewController()
        viewController.messageViewController.messages.scanningText=Configuraciones.txtBarCodeSearch
           viewController.codeDelegate = self
           //viewController.errorDelegate = self
           viewController.dismissalDelegate = self

           present(viewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref: DatabaseReference! = Database.database().reference().child(Configuraciones.userID + Configuraciones.keyProductos)

        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    dic?.setValue("0", forKey: Configuraciones.keyContador)
                    self.valores.append(dic!)
                }
            }
            self.actualizarDatos()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
    func validarMonto() -> Bool {
        var montoAcumulado: Double = 0.0
        for producto in valoresParaMostrar {
            let contador: Int = Int( (producto.value(forKey: Configuraciones.keyContador) as! String) )!
            if  contador != 0 {
                montoAcumulado += Double(contador) * Double (producto.value(forKey: Configuraciones.keyCostoVenta) as? String ?? "0")!
            }
        }
        return self.montoDisponible >= montoAcumulado
    }
    
    @IBAction func agregarTodos(_ sender: Any) {
        var productos: [NSDictionary] = []
        
        for producto in valoresParaMostrar {
            let contador: Int = Int( (producto.value(forKey: Configuraciones.keyContador) as! String) )!
            if  contador != 0 {
                for _ in 1...contador {
                    productos.append(producto)
                }
            }
        }
        
        //delegate?.productoSeleccionado(productos: valoresParaMostrar)
        
        delegate?.productoSeleccionado(productos: productos)
        self.navigationController?.popViewController(animated: true)
    }
    
}



extension ProductosListaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath) as! ProductoCell

        celda.Nombre.text = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String ?? ""
        celda.Marca.text = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String ?? ""
        celda.Talla.text = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String ?? ""
        celda.CostoVenta.text = "$ \( (valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as? String ?? "0") )"
        let contador: Int = Int(valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyContador) as! String)!
        if contador != 0 {
            celda.Contador.text = "x \(contador)"
        }
        else {
            celda.Contador.text = ""
        }

        celda.Imagen.image = UIImage(named: "no_imagen")
        Configuraciones.cargarImagen(KeyNode: Configuraciones.keyProductos, Child: (valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId) as? String)!, Image: celda.Imagen)
        
        /*
        if let imagen = Datos.ProductosFotos[valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId)! as! String] as? Data {
                  celda.Imagen.image = UIImage(data: imagen)
              }
 */
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            valoresParaMostrar[indexPath.row].setValue("0", forKey: Configuraciones.keyContador)
            self.productosViewController.reloadData()
            //var ref: DatabaseReference!
            //ref = Database.database().reference()
            //ref.child(Configuraciones.keyProductos).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
    
}


extension ProductosListaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        
        if validarCantidades {
            var contador: Int = Int( valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyContador) as! String )! + 1
            valoresParaMostrar[indexPath.row].setValue("\(contador)", forKey: Configuraciones.keyContador)
            
            if !validarMonto() {
                contador -=  1
                valoresParaMostrar[indexPath.row].setValue("\(contador)", forKey: Configuraciones.keyContador)
                Configuraciones.alert(Titulo: "Error", Mensaje: "Se ha superado el límite de crédito", self, popView: false)
            }
        }
        else {            
            valoresParaMostrar[indexPath.row].setValue("1", forKey: Configuraciones.keyContador)
        }
        
        
        
        self.productosViewController.reloadData()
        //var productos: [NSDictionary] = []
        //productos.append(valoresParaMostrar[indexPath.row])
        //delegate?.productoSeleccionado(productos: productos)
        //self.navigationController?.popViewController(animated: true)
        
    }
}

extension ProductosListaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
}


extension ProductosListaVC: BarcodeScannerCodeDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    self.textoSeleccionado = code
    barraBusqueda.text = code
    actualizarDatos()
    controller.dismiss(animated: true, completion: nil)
  }
}

extension ProductosListaVC: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
