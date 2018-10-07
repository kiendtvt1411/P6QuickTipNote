//
//  Settings.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class Settings {
    
    static let IS_INITIATED = "IS_INITIATED"
    
    static func saveBool(key: String, value: Bool) {
        
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func getBool(key: String) -> Bool? {
        
        return UserDefaults.standard.bool(forKey: key)
    }
}
