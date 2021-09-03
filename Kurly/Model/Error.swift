//
//  File.swift
//  Kurly
//
//  Created by Ahmad Medhat on 29/08/2021.
//

import Foundation
import UIKit

struct ErrorHandler {
    static func showError(title: String , errorBody: String , senderView: UIViewController) {
        let alert = UIAlertController(title: title, message: errorBody, preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        
        senderView.present(alert, animated: true, completion: nil)
    }
}
