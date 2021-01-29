//
//  FiltrosVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 28/01/21.
//  Copyright © 2021 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import Foundation


protocol FiltrosVCDelegate {
    func filtro(categoria: String, marca: String, talla: String)
}

class FiltrosVC: UIViewController {
    var delegate: FiltrosVCDelegate?

    var categoriaSeleccionada: String? = nil
    var filtros: [NSDictionary] = []


    @IBOutlet weak var botonTalla: UIButton!
    @IBOutlet weak var botonMarca: UIButton!
    @IBOutlet weak var botonCategoria: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func botonLimpiar(_ sender: Any) {
        botonCategoria.setTitle(Configuraciones.txtSeleccionarCategoria, for: .normal)
        botonMarca.setTitle(Configuraciones.txtSeleccionarMarca, for: .normal)
        botonTalla.setTitle(Configuraciones.txtSeleccionarTalla, for: .normal)
    }
    
    @IBAction func botonAceptar(_ sender: Any) {
        
        delegate?.filtro(categoria: botonCategoria.title(for: .normal)!, marca: botonMarca.title(for: . normal)!, talla: botonTalla.title(for: .normal)! )
        self.navigationController?.popViewController(animated: true)

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        if segue.identifier == "DetallesProductoListaDesdeVentasParaCategoria",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Categoria"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoCategoria
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoCategoria
            vc.tipoTeclado = UIKeyboardType.alphabet
        }
        if segue.identifier == "DetallesProductoListaDesdeVentasParaMarca",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Marca"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoMarca
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoMarca + categoriaSeleccionada!
            vc.tipoTeclado = UIKeyboardType.alphabet
        }
        if segue.identifier == "DetallesProductoListaDesdeVentasParaTalla",
            let vc = segue.destination as? DetallesProductoListaVC {
            vc.delegate = self
            vc.title = "Talla"
            vc.ordenarPor = Configuraciones.keyNombre
            vc.detalleKey = Configuraciones.keyDatosDetalleProductoTalla
            vc.detalleKeyOrigen = Configuraciones.keyDatosDetalleProductoTalla + categoriaSeleccionada!

            vc.tipoTeclado = UIKeyboardType.alphabet
        }
    }
}



extension FiltrosVC: DetallesProductoListaVCDelegate {
    func valorSeleccionado(nombre: String, detalle: String) {
        
        switch detalle {
        
        case Configuraciones.keyDatosDetalleProductoCategoria:
            botonCategoria.setTitle(nombre, for: .normal)
            categoriaSeleccionada = nombre
            break
            
        case Configuraciones.keyDatosDetalleProductoMarca:
             botonMarca.setTitle(nombre, for: .normal)
             break
        case Configuraciones.keyDatosDetalleProductoTalla:
            botonTalla.setTitle(nombre, for: .normal)
            break

        default:
            break
        }
    }
}
