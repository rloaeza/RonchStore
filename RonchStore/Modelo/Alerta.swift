//
//  Alerta.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 03/07/20.
//  Copyright © 2020 Roberto Loaeza Valerio. All rights reserved.
//

import Foundation


import UIKit

class Alerta {

    // Notification
    class func displayNotification(parmTitle: String, parmMessage: String) {
        let alert = UIAlertController(title: parmTitle, message: parmMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        displayAlert(parmAlert: alert)
    }

    
    // Create Alert
    //  parmTitle: Alert Title
    //  parmMessage: Alert Message
    //  parmOption: Option to select
    //  parmFunctions: Function to perform for option selected
    class func createAlert(parmTitle: String, parmMessage: String, parmOptions: [String], parmFunctions: [(()->())?] ) {
            
        let alert = UIAlertController(title: parmTitle, message: parmMessage, preferredStyle: UIAlertController.Style.alert)
        
//        var indexx: Int = 0
//        for item in parmOptions {
//
//            alert.addAction(UIAlertAction(title: parmOptions[indexx],
//                                          style: .default,
//                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[indexx])}))
//
//            indexx = indexx + 1
//        }
//        displayAlert(parmAlert: alert)
        
        
//        var indexx: Int = 0
//        while indexx < parmOptions.count {
//                        alert.addAction(UIAlertAction(title: parmOptions[indexx],
//                                                      style: .default,
//                                                      handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[indexx])}))
//            indexx += 1
//
//        }
//        displayAlert(parmAlert: alert)
        


        let arrayCount = parmOptions.count
        switch arrayCount {

        case 1:
            alert.addAction(UIAlertAction(title: parmOptions[0],
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[0])}))
            displayAlert(parmAlert: alert)
        case 2:
            alert.addAction(UIAlertAction(title: parmOptions[0],
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[0])}))
            alert.addAction(UIAlertAction(title: parmOptions[1],
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[1])}))
            displayAlert(parmAlert: alert)
        case 3:
            alert.addAction(UIAlertAction(title: parmOptions[0],
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[0])}))
            alert.addAction(UIAlertAction(title: parmOptions[1],
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[1])}))
            alert.addAction(UIAlertAction(title: parmOptions[2],
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in self.funcHandler(f: parmFunctions[2])}))
            displayAlert(parmAlert: alert)
        default:
            displayNotification(parmTitle: "ERROR", parmMessage: "The function (CreateAlert) does not support more than 3 options!")
        }

        
    }

    
    // Display Alert
    class func displayAlert(parmAlert: UIAlertController) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(parmAlert, animated: true, completion: nil)
    }

    
    // Function Wrapper
    class func funcHandler(f:(()->())?) {
        f?()
    }
    
    
}
