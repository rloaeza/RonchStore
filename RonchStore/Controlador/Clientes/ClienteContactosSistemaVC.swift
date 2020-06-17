//
//  ClienteContactosSistemaVC.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 29/05/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import Contacts

protocol ClienteContactosSistemaVCDelegate {
    func contactoSeleccionado(contacto: Contacto)
}

class ClienteContactosSistemaVC: UIViewController {
    
    var delegate: ClienteContactosSistemaVCDelegate?
    
    
    var textoSeleccionado: String = ""
    
    var listaContactos = [Contacto]()
    var listaContactosTabla = [Contacto]()
    var contactStore = CNContactStore()

    @IBOutlet weak var tablaValores: UITableView!
    
    func actualizarDatos() {
        listaContactosTabla.removeAll()
        if textoSeleccionado.isEmpty {
            listaContactosTabla.append(contentsOf: listaContactos)
        }
        for contacto in listaContactos {
            if contacto.nombre.uppercased().contains(textoSeleccionado.uppercased()) {
                listaContactosTabla.append(contacto)
            }
        }
        tablaValores.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        contactStore.requestAccess(for: .contacts) { (aceptar, error) in
            if aceptar {
                print ( "Permisos aceptados" )
            } else {
                print( "Permisos denegados" )
            }
            
            if error != nil {
                print( "Error en contacto" )
            }
        }
        
        fetchContactos()
        actualizarDatos()
        
    }
    
    func fetchContactos() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: key)
        request.sortOrder = CNContactSortOrder.givenName
        
        try! contactStore.enumerateContacts(with: request, usingBlock: { (contacto, apuntador) in
            let nombre = "\(contacto.givenName) \(contacto.familyName)"
            let telefono = contacto.phoneNumbers.first?.value.stringValue ?? ""
            let email = contacto.emailAddresses.first?.value.description ?? ""
            let calle = contacto.postalAddresses.first?.value.street ?? ""
            let ciudad = contacto.postalAddresses.first?.value.city ?? ""
            let pais = contacto.postalAddresses.first?.value.country ?? ""
            
            let contactoNuevo = Contacto(nombre: nombre, telefono: telefono, email: email, calle: calle, colonia: "", ciudad: ciudad, pais: pais)
            self.listaContactos.append(contactoNuevo)
        })
    }
    
    


}
extension ClienteContactosSistemaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaContactosTabla.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)
        let contacto = listaContactosTabla[indexPath.row]
        celda.textLabel?.text = "\(contacto.nombre) "
        celda.detailTextLabel?.text = "\(contacto.telefono)"
        return celda
    }
    
    
}
extension ClienteContactosSistemaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contacto = listaContactosTabla[indexPath.row]
        delegate?.contactoSeleccionado(contacto: contacto)
        
        self.navigationController?.popViewController(animated: true)
    }
}



extension ClienteContactosSistemaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoSeleccionado = searchText
        actualizarDatos()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
