//
//  ProductosVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/16/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore

class ProductosVC: UIViewController {
    var valores: [NSDictionary] = []
    var valoresParaMostrar: [NSDictionary] = []

    
    @IBOutlet weak var botonCategoria: UIButton!
    @IBOutlet weak var botonMarca: UIButton!
    @IBOutlet weak var botonTalla: UIButton!
    
    var textoSeleccionado: String = ""
    

    @IBOutlet weak var productosViewControler: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        let ref: DatabaseReference! = Database.database().reference().child(Configuraciones.userID + Configuraciones.keyProductos)

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
        
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductoAgregarSegue",
            let vc = segue.destination as? ProductoAgregarVC {
            vc.producto = sender as? NSDictionary
        }        
    }
    
    
    private func actualizarDatos() {
        
        valoresParaMostrar = Datos.getProductos(Patron: textoSeleccionado,  Productos: valores)
        productosViewControler.reloadData()
    }
    
    
}



extension ProductosVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath) as! ProductoCompletoCell
        
    
        let codigo = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId) as? String
        let nombre = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String ?? ""
        let marca = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String ?? ""
        let categoria = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCategorias) as? String ?? ""
        let talla = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String ?? ""
        let existencia = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyExistencia) as? String ?? "0"
        let costoVenta = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as? String ?? "0"
        celda.Nombre.text = "\(nombre) "
        celda.Categoria.text = "\(categoria)"
        celda.Marca.text = "\(marca)"
        celda.Talla.text = "\(talla)"
        celda.Existencia.text = "\(existencia)"
        celda.CostoVenta.text = "$ \(costoVenta)"
        celda.Imagen.image = UIImage(named: "no_imagen")

        let existenciaInt = Int( existencia )!
        celda.Existencia.textColor = UIColor.black
        if existenciaInt <= 0 {
            
            celda.Existencia.textColor = UIColor.red
        }
        
        Configuraciones.cargarImagen(KeyNode: Configuraciones.keyProductos, Child: codigo!, Image: celda.Imagen)
        
        //if let imagen = Datos.ProductosFotos[valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId)! as! String] as? Data {
       //     celda.Imagen.image = UIImage(data: imagen)
        //}
        
        
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
            
            Configuraciones.eliminarImagen(Reference: Storage.storage().reference(), KeyNode: Configuraciones.keyProductos, Child: valoresParaMostrar[indexPath.row].value(forKey: "key") as! String)
        }
    }
}


extension ProductosVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valoresParaMostrar[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProductosVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

