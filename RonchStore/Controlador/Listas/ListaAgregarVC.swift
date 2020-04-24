//
//  ListaAgregarVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 06/11/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import FirebaseDatabase

import MessageUI


class ListaAgregarVC: UIViewController, MFMessageComposeViewControllerDelegate {

    var lista: NSDictionary? = nil
    
    var productosLista: [NSDictionary] = []

    var cliente: NSDictionary? = nil
    var codigo: String? = nil
    var ref: DatabaseReference!


    
    @IBOutlet weak var botonCliente: UIButton!
    @IBOutlet weak var tableViewProductos: UITableView!
    
    @IBAction func enviarLista(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            var mensaje = "\(Configuraciones.Titulo) \n"
            
            mensaje += "Visita: http://url/lista.php?\(codigo!)\n"
            let messageVC = MFMessageComposeViewController()
                messageVC.body = mensaje
                messageVC.recipients = [cliente?.value(forKey: Configuraciones.keyTelefono) as! String]
                messageVC.messageComposeDelegate = self
                self.present(messageVC, animated: true, completion: nil)
            }
            else {
                Configuraciones.alert(Titulo: "Alerta", Mensaje: "No es posible enviar mensajes", self, popView: false)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        if lista != nil {
            codigo = lista?.value(forKey: Configuraciones.keyId) as? String

            cliente = lista?.value(forKey: Configuraciones.keyCliente) as? NSDictionary
            productosLista = lista?.value(forKey: Configuraciones.keyProductos) as? [NSDictionary] ?? []
            
            botonCliente.setTitle(cliente?.value(forKey: Configuraciones.keyNombre) as? String, for: .normal)
            
        }

        // Do any additional setup after loading the view.
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClienteDesdeNuevaLista",
               let vc = segue.destination as? ClienteVC {
               vc.delegate = self

           }
        if segue.identifier == "ProductosDesdeNuevaLista",
                   let vc = segue.destination as? ProductosListaVC {
                   vc.delegate = self
               }
    }
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
           var msg = ""
           switch (result) {
           case .cancelled:
               msg = "Mensaje cancelado"
           case .failed:
               msg = "Error al enviar"
           case .sent:
               msg = "Mensaje enviado satisfactoriamente"
           default:
               break
           }
           
           dismiss(animated: true, completion: nil)
           Configuraciones.alert(Titulo: "Mensaje", Mensaje: msg, self, popView: true)
       
       }
    

}

extension ListaAgregarVC: ClienteVCDelegate {
    func clienteSeleccionado(cliente: NSDictionary) {
        botonCliente.setTitle(cliente.value(forKey: Configuraciones.keyNombre) as? String , for: .normal)
        self.cliente = cliente
        
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyListas, Child: codigo, KeyValue: Configuraciones.keyCliente, Value: cliente)
        
    }
}


extension ListaAgregarVC: ProductosListaVCDelegate {
    func productoSeleccionado(productos: [NSDictionary]) {
        for producto in productos {
            productosLista.append(producto)
            self.tableViewProductos.reloadData()
        }
        codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyListas, Child: codigo, KeyValue: Configuraciones.keyProductos, Value: productosLista)
        
        
    }
}


extension ListaAgregarVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosLista.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "ProductoCelda", for: indexPath)
        
        let nombre = productosLista[indexPath.row].value(forKey: Configuraciones.keyNombre) as! String
        let marca = productosLista[indexPath.row].value(forKey: Configuraciones.keyMarca) as! String
        let talla = productosLista[indexPath.row].value(forKey: Configuraciones.keyTalla) as! String
        let costo = productosLista[indexPath.row].value(forKey: Configuraciones.keyCostoVenta) as! String
        
        
        celda.textLabel?.text = String(indexPath.row + 1) + ") \(nombre) (\(marca)/\(talla))"
        //celda.detailTextLabel?.text = costo
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if (editingStyle == .delete) {
            productosLista.remove(at: indexPath.row)
            self.tableViewProductos.reloadData()
            codigo = Configuraciones.guardarValor(Reference: ref, KeyNode: Configuraciones.keyListas, Child: codigo, KeyValue: Configuraciones.keyProductos, Value: productosLista)
           }
       }
}
