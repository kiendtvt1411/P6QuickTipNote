//
//  UI.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class UI {
    
    static func simpleAlert(in ui: UIViewController, title: String, message: String) {
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(actionOk)
        ui.present(alert, animated: true, completion: nil)
    }
    
    static func addDoneButton(in ui: UIViewController, for textFields: [UITextField]) {
        
        for textField in textFields {
            
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: ui, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: textField, action: #selector(UITextField.resignFirstResponder))
            ]
            
            toolbar.sizeToFit()
            textField.inputAccessoryView = toolbar
        }
    }
    
    static func addDoneButton(in ui: UIViewController, for textViews: [UITextView]) {
        
        for textView in textViews {
            
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: ui, action: nil),
                UIBarButtonItem(title: "Done", style: .done, target: textView, action: #selector(UITextField.resignFirstResponder))
            ]
            
            toolbar.sizeToFit()
            textView.inputAccessoryView = toolbar
        }
    }
}
