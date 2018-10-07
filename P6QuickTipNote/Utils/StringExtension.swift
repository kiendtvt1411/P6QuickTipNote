//
//  StringExtension.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
