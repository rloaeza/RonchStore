//
//  TextFieldDeletage.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/20/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
