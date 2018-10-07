//
//  Image+CoreDataClass.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {

    static func createNew(data: Data) -> Image {
        
        let newImage = Image(context: DB.getContextCoreData())
        
        newImage.data = NSData(data: data)
        
        return newImage
    }
    
    static func insertImage(withData data: Data) -> Image? {
        
        let newImage = createNew(data: data)
        
        DB.saveData()
        
        return newImage
    }
}
