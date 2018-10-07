//
//  TagController.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class TagController: UIViewController {

    // MARK: - Variables
    
    var tags = [Tag]()
    
    var selectedTag = ""
    
    // MARK: - UI elements
    
    @IBOutlet weak var tableViewTag: UITableView!
    
    
    // MARK: - UI events
    
    
    
    // MARK: - Main methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackNotes" {
            let destination = segue.destination as! NoteController
            destination.tagName = selectedTag
        }
    }
    
    // MARK: - Manipulation data methods
    
    func updateData() {
        
        tags = Tag.getAll()
        
        tableViewTag.reloadData()
    }
}


// MARK: - Delegate & Data Source Methods

extension TagController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All tags"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagCell
        
        if indexPath.row == 0 {
            let size = Note.getAll().count
            cell.tvName.text = "All - \(size) note(s)"
        } else {
            let tag = tags[indexPath.row - 1]
            cell.tvName.text = "\(tag.name!) - \(tag.notes!.count) note(s)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectedTag = "All"
        } else {
            selectedTag = tags[indexPath.row - 1].name!
        }
        
        performSegue(withIdentifier: "goBackNotes", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DB.getContextCoreData().delete(tags[indexPath.row - 1])

            tags.remove(at: indexPath.row - 1)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
