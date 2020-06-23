//
//  VentaProductoCell.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 22/06/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit

class VentaProductoCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var marca: UILabel!
    @IBOutlet weak var talla: UILabel!
    
    @IBOutlet weak var costoVenta: UILabel!
    
    @IBOutlet weak var costoConDescuento: UILabel!
    
}
