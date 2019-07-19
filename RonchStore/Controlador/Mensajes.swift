//
//  Mensajes.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/18/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import UIKit
import MessageUI


class Mensajes: UIViewController, MFMessageComposeViewControllerDelegate  {
    
    func sendSMS(Telefono tel:String, Mensaje msg:String, _ view: UIViewController) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return
        }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = msg
            controller.recipients = [tel]
            
            controller.messageComposeDelegate = self
            view.present(controller, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: nil)
       // self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

   

}
