//
//  NoteDetailController.swift
//  P6QuickTipNote
//
//  Created by Nguyen Trung Kien on 10/7/18.
//  Copyright © 2018 Nguyen Trung Kien. All rights reserved.
//

import UIKit

class NoteDetailController: UIViewController {

    // MARK: - Variables
    
    var note: Note?
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var edtTagNames: UITextField!
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var scrollViewPicture: UIScrollView!
    let imagePicker = UIImagePickerController()
    
    
    // MARK: - UI Events
    
    @IBAction func btnAddPicPressed(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - Main methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        
        // add save button
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(btnSavePressed))
        navigationItem.setRightBarButton(saveBtn, animated: true)
        
        // bind delegate image picker
        bindDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareUI()
    }
    
    @objc func btnSavePressed() {
        
        note?.content = tvContent.text
        
        let tags = note?.mutableSetValue(forKeyPath: "tags")
        tags?.removeAllObjects()
        
        if edtTagNames.text!.count > 0 {
            
            let separator = ", "
            let tokens = edtTagNames.text!.components(separatedBy: separator)
            
            for token in tokens {
                
                guard let newTag = Tag.insertTag(withName: token.trimmed()) else {
                    continue
                }
                
                tags?.add(newTag)
            }
            
            DB.saveData()
            
            UI.simpleAlert(in: self, title: "Change Data", message: "Data Saved")
        }
    }
    
    func prepareUI() {
        
        registerKeyboardNotification()
        
        // remove all sub view of scroll view
        for view in scrollViewPicture.subviews {
            view.removeFromSuperview()
        }

        // and resize scroll view
        scrollViewPicture.contentSize = CGSize(width: 0, height: 0)
        
        // show text
        tvContent.text = note?.content
        
        var tagNames = ""
        var prefix = ""
        
        for tag in note?.tags?.allObjects as! [Tag] {
            
            tagNames += prefix + tag.name!
            if prefix == "" {
                prefix = ", "
            }
        }
        
        edtTagNames.text = tagNames
        
        // add image
        for pic in note?.images?.allObjects as! [Image] {
            addDynamic(image: Data.init(referencing: pic.data!), into: scrollViewPicture)
        }
        
        // modify
        UI.addDoneButton(in: self, for: [edtTagNames])
        UI.addDoneButton(in: self, for: [tvContent])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToShowImage" {
            
            let destination = segue.destination as! ShowImageController
            destination.selectedIndex = selectedIndex
            destination.selectedThumbnail = selectedThumbnail
            destination.note = note
        }
    }
    
    // MARK: - Adding dynamic image into Scroll view
    
    func addDynamic(image: Data, into scrollView: UIScrollView) {
        let width = CGFloat(120)
        let spacing = CGFloat(10)
        
        // get current size scroll view
        let sizeScrollView = scrollView.contentSize
        var countExistPic = CGFloat(0)
        
        if sizeScrollView.width > 0 {
            countExistPic = (sizeScrollView.width - spacing) / (width + spacing)
        }
        
        // create dynamic ui image view
        let imageView = UIImageView(frame: CGRect(x: spacing + (width + spacing) * countExistPic, y: 0, width: width, height: width))
        imageView.image = UIImage(data: image)
        
        // adjust content mode, auto fit with size
        imageView.contentMode = .scaleAspectFit
        
        // add shadow
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize.zero
        
        // use tag to mark position of image
        imageView.tag = Int(countExistPic)
        
        // add gesture tap recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(thumbnailTapped))
        imageView.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        // bind that image view onto scroll view
        scrollView.addSubview(imageView)
        
        // update content size of scroll view
        countExistPic += 1
        scrollView.contentSize = CGSize(width: spacing + (width + spacing) * countExistPic, height: width)
    }
    
    // handle event tap to thumbnail image
    var selectedIndex: Int?
    var selectedThumbnail: UIImage?
    
    @objc func thumbnailTapped(sender: UITapGestureRecognizer) {
        
        let imgView = sender.view as! UIImageView
        selectedIndex = imgView.tag
        selectedThumbnail = imgView.image
        
        performSegue(withIdentifier: "goToShowImage", sender: self)
    }
    
    // MARK: - Handle hide/show keyboard
    
    var activeTv: UITextView?
    
    func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
        scrollViewContent.isScrollEnabled = true
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height, right: 0)
        
        scrollViewContent.contentInset = contentInset
        scrollViewContent.scrollIndicatorInsets = contentInset
        
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardSize!.height, right: 0)
        
        scrollViewContent.contentInset = contentInset
        scrollViewContent.scrollIndicatorInsets = contentInset
        
        scrollViewContent.isScrollEnabled = false
    }
}


// MARK: - Handle methods image picker

extension NoteDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func bindDelegate() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        let compressPic = UIImageJPEGRepresentation(image, 1.0)
        
        guard let newPic = Image.insertImage(withData: compressPic!) else {
            return
        }
        
        note?.mutableSetValue(forKey: "images").add(newPic)
        
        DB.saveData()
        
        addDynamic(image: Data(referencing: newPic.data!), into: scrollViewPicture)
    }
}
