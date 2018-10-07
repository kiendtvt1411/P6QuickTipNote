//
//  Tag+CoreDataClass.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {

    static func createNew(with name: String) -> Tag {
        
        let newTag = Tag(context: DB.getContextCoreData())
        
        newTag.name = name
        
        return newTag
    }
    
    static func findTag(byName name: String) -> Tag? {
        
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try DB.getContextCoreData().fetch(request)
            return result.first
        } catch let error as NSError {
            print("Could not find \(error)")
            return nil
        }
    }
    
    static func insertTag(withName name: String) -> Tag? {
        
        if let tag = findTag(byName: name) {
            return tag
        } else {
            let newTag = createNew(with: name)
            DB.saveData()
            return newTag
        }
    }
    
    static func getAll() -> [Tag] {
        
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        
        do {
            return try DB.getContextCoreData().fetch(request)
        } catch {
            return []
        }
    }
}
