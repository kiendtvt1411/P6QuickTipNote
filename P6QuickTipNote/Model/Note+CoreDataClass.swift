//
//  Note+CoreDataClass.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {

    static func createNew(content: String) -> Note? {
        
        let newNote = Note(context: DB.getContextCoreData())
        
        newNote.content = content
        
        return newNote
    }
    
    static func getAll() -> [Note] {
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            return try DB.getContextCoreData().fetch(request)
        } catch {
            return []
        }
        
    }
    
    static func getByTag(tagName: String) -> [Note] {
        
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        
        request.predicate = NSPredicate(format: "name == %@", tagName)
        
        do {
            
            let result = try DB.getContextCoreData().fetch(request)
            if let tag = result.first {
                return tag.notes?.allObjects as! [Note]
            } else {
                return []
            }
        } catch {
            return []
        }
    }
}
