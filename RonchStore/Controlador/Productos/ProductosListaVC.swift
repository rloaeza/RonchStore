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


protocol ProductosListaVCDelegate {
    func productoSeleccionado(producto: NSDictionary)
}


class ProductosListaVC: UIViewController {
    
    var delegate: ProductosListaVCDelegate?
    
    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []
    var categoriaSeleccionada: String = ""
    var marcaSeleccionada: String = ""
    var tallaSeleccionada: String = ""
    var textoSeleccionado: String = ""
    
    @IBOutlet weak var productosViewController: UITableView!
    @IBOutlet weak var botonCategoria: UIButton!
    @IBOutlet weak var botonMarca: UIButton!
    @IBOutlet weak var botonTalla: UIButton!
    
    @IBAction func botonAgregar(_ sender: Any) {
        
        
        
    }
    
    
    
    private func actualizarDatos() {
        /*valoresParaMostrar.removeAll()
        
        for valor in valores {
            let talla: String = valor.value(forKey: Configuraciones.keyTalla) as? String ?? ""
            let marca: String = valor.value(forKey: Configuraciones.keyMarca) as? String ?? ""
            let categoria: String = valor.value(forKey: Configuraciones.keyCategorias) as? String ?? ""
            let nombre: String = valor.value(forKey: Configuraciones.keyNombre) as? String ?? ""
            
            if talla.lowercased().contains(textoSeleccionado.lowercased())||nombre.lowercased().contains(textoSeleccionado.lowercased())||marca.lowercased().contains(textoSeleccionado.lowercased())||categoria.lowercased().contains(textoSeleccionado.lowercased())||textoSeleccionado.isEmpty{
                valoresParaMostrar.append(valor)
            }
        }
        */
        valoresParaMostrar = Datos.getProductos(Patron: textoSeleccionado)
        productosViewController.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        let ref = Database.database().reference().child(Configuraciones.keyProductos).queryOrdered(byChild: Configuraciones.keyNombre)
        
        ref.observe(.value) { (DataSnapshot) in
            self.valores.removeAll()
            for child in DataSnapshot.children {
                if let snap = child as? DataSnapshot {
                    let dic = snap.value as? NSDictionary
                    dic?.setValue(snap.key, forKey: Configuraciones.keyId)
                    self.valores.append(dic!)
                }
            }
            self.actualizarDatos()
        }
        */
        valores = Datos.getProductos(Patron: "")
        actualizarDatos()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
    
}


extension ProductosListaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath) as! ProductoCell
        
        let nombre = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        let marca = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String
        //let categoria = valores[indexPath.row].value(forKey: Configuraciones.keyCategorias) as? String
        let talla = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String

        celda.Nombre.text = "\(nombre!) "
        celda.Marca.text = "\(marca!)"
        celda.Talla.text = "\(talla!)"
        celda.CostoVenta.text = "$ \( (valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as? String)! )"
        celda.Imagen.image = UIImage(named: "no_imagen")
        
        /*
        let ruta: String = "\(Configuraciones.keyProductos)/\(valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId)! as! String)"
               
               
        NetworkManager.isReachableViaWiFi { (NetworkManager) in
           
            let userRef = Configuraciones.storageRef.child(ruta)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
                if error == nil {
                celda.Imagen.image = UIImage(data: data!)
                  
                }
            }
        }
        
        
        */
        if let imagen = Datos.ProductosFotos[valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId)! as! String] as? Data {
                  celda.Imagen.image = UIImage(data: imagen)
              }
        
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
}


extension ProductosListaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        delegate?.productoSeleccionado(producto: valoresParaMostrar[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        
    }
}





extension ProductosListaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
  
  
}
