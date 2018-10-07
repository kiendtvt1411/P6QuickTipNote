//
//  ShowImageController.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class ShowImageController: UIViewController {

    // MARK: - Variables
    
    var selectedIndex: Int?
    var selectedThumbnail: UIImage?
    var note: Note?
    
    // MARK: - UI elements
    
    @IBOutlet weak var imgDetail: UIImageView!
    
    
    // MARK: - Main methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // show image
        imgDetail.image = selectedThumbnail
        
        // add delete button
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(btnDeletePressed))
        navigationItem.setRightBarButton(deleteButton, animated: true)
    }

    // MARK: - Handle button delete methods
    
    @objc func btnDeletePressed() {
        
        let yesAct = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let imageSet = self.note?.mutableSetValue(forKeyPath: "images")
            let images = imageSet!.allObjects as! [Image]
            let thisImage = images[self.selectedIndex!]
            imageSet?.remove(thisImage)
            
            DB.saveData()
            
            self.navigationController?.popViewController(animated: true)
        }
        
        let noAct = UIAlertAction(title: "No", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you really want to delete this picture? This action cannot undo!", preferredStyle: .alert)
        
        alert.addAction(yesAct)
        alert.addAction(noAct)
        
        present(alert, animated: true, completion: nil)
    }
}
