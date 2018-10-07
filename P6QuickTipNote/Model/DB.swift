//
//  DB.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit
import CoreData

class DB {
    
    static func getContextCoreData() -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    static func initMockData() {
        
        let contents = [
            "A friend in need is friend indeed\nLine 2\nLine 3",
            "A speaker louder than words\nAnother line",
            "Never say never"
        ]
        
        let tagNames = [
            ["friendship", "quotes"],
            ["quotes", "action"],
            ["thinking", "quotes"]
        ]
        
        let imgs = [
            ["meo-1", "meo-2", "meo-3", "meo-4"],
            ["meo-2", "meo-4"],
            ["meo-1", "meo-3", "meo-4"]
        ]
        
        for i in 0..<contents.count {
            
            guard let note = Note.createNew(content: contents[i]) else {
                continue
            }
            
            // add tags
            let tags = note.mutableSetValue(forKeyPath: "tags")
            
            for name in tagNames[i] {
                
                guard let newTag = Tag.insertTag(withName: name) else {
                    continue
                }
                
                tags.add(newTag)
            }
            
            // add images
            let pics = note.mutableSetValue(forKey: "images")
            
            for img in imgs[i] {
                
                let picture = UIImage(named: img)!
                let compressPicture = UIImageJPEGRepresentation(picture, 1.0)
                
                guard let newImage = Image.insertImage(withData: compressPicture!) else {
                    continue
                }
                
                pics.add(newImage)
            }
        }
        
        saveData()
    }
    
    static func saveData() {
        
        do {
            try getContextCoreData().save()
        } catch let error as NSError {
            print(error)
        }
    }
}
