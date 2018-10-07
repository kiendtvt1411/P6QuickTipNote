//
//  ViewController.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class NoteController: UIViewController {

    // MARK: - Variables
    
    var notes = [Note]()
    
    var tagName = ""
    
    var selectedNote: Note?
    
    
    // MARK: - UI elements
    
    @IBOutlet weak var tableViewNote: UITableView!
    
    
    // MARK: - UI events
    
    @IBAction func btnAddNotePressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Add new", message: "Write new note", preferredStyle: .alert)
        
        let actionSave = UIAlertAction(title: "Save", style: .default) { (action) in
            
            Note.createNew(content: alert.textFields!.first!.text!)
            
            DB.saveData()
            
            self.updateData()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { (textField) in
            
        }
        alert.addAction(actionSave)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Main methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewNote.estimatedRowHeight = 40.0
        tableViewNote.rowHeight = UITableViewAutomaticDimension
        
        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailNote" {
            
            let destination = segue.destination as! NoteDetailController
            destination.note = selectedNote
        }
    }
    
    // MARK: - Manipulation Data Methods
    
    func updateData() {
        
        if tagName == "All" {
            notes = Note.getAll()
        } else {
            notes = Note.getByTag(tagName: tagName)
        }
        
        tableViewNote.reloadData()
    }
}


// MARK: - Delegate & Data Source methods

extension NoteController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        cell.tvContent.text = notes[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notes[indexPath.row]
        
        performSegue(withIdentifier: "goToDetailNote", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DB.getContextCoreData().delete(notes[indexPath.row])
            
            notes.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

