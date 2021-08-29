//
//  TextFieldDesigner.swift
//  Kurly
//
//  Created by Ahmad Medhat on 29/08/2021.
//

import Foundation
import UIKit


struct TextFieldDesigner {
    static func updateTextField(for field: UITextField) -> UITextField {
        field.layer.cornerRadius = 25
        field.borderStyle = .none
        field.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.layer.masksToBounds = true
        
        return field
    }
}
