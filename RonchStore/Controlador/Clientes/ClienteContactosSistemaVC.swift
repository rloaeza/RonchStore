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
    
    
    var listaContactos = [Contacto]()
    var contactStore = CNContactStore()

    override func viewDidLoad() {
        super.viewDidLoad()


        
        contactStore.requestAccess(for: .contacts) { (aceptar, error) in
            if aceptar {
                print ( "Permisos aceptados" )
            } else {
                print( "Permisos denegados" )
            }
            
            if let error = error {
                print( "Error en contacto" )
            }
        }
        
        fetchContactos()
        
    }
    
    func fetchContactos() {
        let key = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: key)
        
        try! contactStore.enumerateContacts(with: request, usingBlock: { (contacto, apuntador) in
            let nombre = contacto.givenName
            let apellidos = contacto.familyName
            let numero = contacto.phoneNumbers.first?.value.stringValue ?? ""
            let email = contacto.emailAddresses.first?.value.uppercased ?? ""
            let direccion = contacto.postalAddresses.first?.value.street ?? ""
            
            let contactoNuevo = Contacto(nombre: nombre, apellidos: apellidos, numero: numero, email: email, domicilio: direccion)
            
            self.listaContactos.append(contactoNuevo)
        })
    }
    
    


}
extension ClienteContactosSistemaVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaContactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)
        let contacto = listaContactos[indexPath.row]
        celda.textLabel?.text = "\(contacto.nombre) \(contacto.apellidos)"
        celda.detailTextLabel?.text = "\(contacto.numero)"
        return celda
    }
    
    
}
extension ClienteContactosSistemaVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var contacto = listaContactos[indexPath.row]
        delegate?.contactoSeleccionado(contacto: contacto)
        
        self.navigationController?.popViewController(animated: true)
    }
}

