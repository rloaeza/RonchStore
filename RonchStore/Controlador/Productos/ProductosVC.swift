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
    
    var categoriaSeleccionada: String = ""
    var marcaSeleccionada: String = ""
    var tallaSeleccionada: String = ""
    var textoSeleccionado: String = ""
    

    @IBAction func botonLimpiar(_ sender: Any) {
        tallaSeleccionada = ""
        marcaSeleccionada = ""
        categoriaSeleccionada = ""
        botonTalla.setTitle(Configuraciones.keyTalla, for: .normal)
        botonMarca.setTitle(Configuraciones.keyMarca, for: .normal)
        botonCategoria.setTitle(Configuraciones.keyCategorias, for: .normal)
        actualizarDatos()
    }
    @IBOutlet weak var productosViewControler: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        let ref = Database.database().reference().child(Configuraciones.keyProductos).queryOrdered(byChild: Configuraciones.keyMarca)
        
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
        if segue.identifier == "TallaDesdeProductos",
           let vc = segue.destination as? TallaVC {
            vc.delegate = self
        }
        if segue.identifier == "MarcaDesdeProducto",
            let vc = segue.destination as? MarcaVC {
            vc.delegate = self
        }
        if segue.identifier == "CategoriaDesdeProducto",
            let vc = segue.destination as? CategoriaVC {
            vc.delegate = self
        }
    }
    
    
    private func actualizarDatos() {
        valoresParaMostrar.removeAll()
        
        for valor in valores {
            let categoria: String = valor.value(forKey: Configuraciones.keyCategorias) as? String ?? ""
            if  categoria == categoriaSeleccionada  || categoriaSeleccionada.isEmpty {
                let marca: String = valor.value(forKey: Configuraciones.keyMarca) as? String ?? ""
                if  marca == marcaSeleccionada  || marcaSeleccionada.isEmpty {
                    let talla: String = valor.value(forKey: Configuraciones.keyTalla) as? String ?? ""
                    if  talla == tallaSeleccionada  || tallaSeleccionada.isEmpty {
                        let nombre: String = valor.value(forKey: Configuraciones.keyNombre) as? String ?? ""
                        if nombre.lowercased().contains(textoSeleccionado.lowercased())||marca.lowercased().contains(textoSeleccionado.lowercased())||categoria.lowercased().contains(textoSeleccionado.lowercased())||textoSeleccionado.isEmpty{
                            valoresParaMostrar.append(valor)
                        }
                        
                    }
                }
            }
        }
        productosViewControler.reloadData()
    }
    
    
}



extension ProductosVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valoresParaMostrar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath) as! ProductoCompletoCell
        
    
        
        let nombre = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyNombre) as? String
        let marca = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyMarca) as? String
        let categoria = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCategorias) as? String
        let talla = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyTalla) as? String
        let existencia = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyExistencia) as? String
        let costoVenta = valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as? String
        celda.Nombre.text = "\(nombre!) "
        celda.Categoria.text = "\(categoria!)"
        celda.Marca.text = "\(marca!)"
        celda.Talla.text = "\(talla!)"
        celda.Existencia.text = "\(existencia!)"
        celda.CostoVenta.text = "$ \(costoVenta!)"
        celda.Imagen.image = UIImage(named: "no_imagen")

        let existenciaInt = Int( existencia! )!
        celda.Existencia.textColor = UIColor.black
        if existenciaInt <= 0 {
            
            celda.Existencia.textColor = UIColor.red
        }

        
        let ruta: String = "\(Configuraciones.keyProductos)/\(valoresParaMostrar[indexPath.row].value(forKey: Configuraciones.keyId)! as! String)"
        
        
        NetworkManager.isReachableViaWiFi { (NetworkManager) in
            
            let userRef = Configuraciones.storageRef.child(ruta)
            userRef.getData(maxSize: 10*1024*1024) { (data, error) in
               if error == nil {
                celda.Imagen.image = UIImage(data: data!)
                   
               }
           }
        }
        
        
        
        return celda
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(Configuraciones.keyProductos).child(valoresParaMostrar[indexPath.row].value(forKey: "key") as! String).setValue(nil)
            
            Configuraciones.eliminarFoto(Reference: Storage.storage().reference(), KeyNode: Configuraciones.keyProductos, Child: valoresParaMostrar[indexPath.row].value(forKey: "key") as! String)
        }
    }
}


extension ProductosVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ProductoAgregarSegue", sender: valoresParaMostrar[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}




extension ProductosVC: CategoriaVCDelegate {
    func categoriaSeleccionada(nombre: String) {
        botonCategoria.setTitle(nombre, for: .normal)
        categoriaSeleccionada = nombre
        actualizarDatos()
    }
}

extension ProductosVC: MarcaVCDelegate {
    func marcaSeleccionada(nombre: String) {
        botonMarca.setTitle(nombre, for: .normal)
        marcaSeleccionada = nombre
        actualizarDatos()
    }
}
extension ProductosVC: TallaVCDelegate {
    func tallaSeleccionada(nombre: String) {
        botonTalla.setTitle(nombre, for: .normal)
        tallaSeleccionada = nombre
        actualizarDatos()
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

