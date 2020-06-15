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
    
    @IBOutlet weak var productosViewController: UITableView!
    
    private func actualizarDatos() {
        valoresParaMostrar = Datos.getProductos(Patron: textoSeleccionado, Productos: valores)
        productosViewController.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref: DatabaseReference! = Database.database().reference().child(Configuraciones.keyProductos)

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
     
    }
    
    
    @IBAction func agregarTodos(_ sender: Any) {
        delegate?.productoSeleccionado(productos: valoresParaMostrar)
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
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
        }
    }
    
}


extension ProductosListaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valores[indexPath.row])
        var productos: [NSDictionary] = []
        productos.append(valoresParaMostrar[indexPath.row])
        delegate?.productoSeleccionado(productos: productos)
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension ProductosListaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
}
