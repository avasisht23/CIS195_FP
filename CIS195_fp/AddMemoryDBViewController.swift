//
//  AddMemoryDBViewController.swift
//  CIS195_fp
//
//  Created by Ajay Vasisht on 4/23/20.
//  Copyright © 2020 Ajay Vasisht. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol AddMemoryDelegate: class {
    func didCreate(_ yes: Bool)
}

class AddMemoryDBViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // set up Firebase variables (ref, refHandle)
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle!
    var pinId : Int? = nil
    
    override func viewDidLoad() {
        print("add pin db")
        // set up Firebase ref
        ref = Database.database().reference()
    }
    
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var memIdInput: UITextField!
    @IBOutlet weak var blurbInput: UITextField!
    
    @IBAction func tapReact(_ sender: Any) {
        presentImagePicker()
    }
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Save(_ sender: Any) {
        if (createMemoryAndAddDB()) {
            self.delegate?.didCreate(true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Set ImageView to display the selected image.
            pic.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func createMemoryAndAddDB() -> Bool {
        let nilBool : Bool = titleInput != nil && memIdInput != nil && blurbInput != nil
        let emptyBool : Bool = titleInput?.text != "" && memIdInput?.text != "" && blurbInput?.text != ""

        if (nilBool && emptyBool) {
        
            let title : String = titleInput.text!
            let memId : String = memIdInput.text!
            
            let memIdInt : Int = Int(memId)!
            let blurb : String = blurbInput.text!
            
            let image : UIImage = pic.image!
            
            // storage to get url from firebase
            let randomId = UUID.init().uuidString
            let uploadRef = Storage.storage().reference(withPath: "memoryPics/\(randomId).jpg")
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return false }
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            
            uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, err1) in
                if let err1 = err1 {
                    print("error in uploading pic \(err1)")
                } else {
                    print("put complete, got back: \(String(describing: downloadMetadata))")
                    
                    uploadRef.downloadURL(completion: { (url, err2) in
                        if let err2 = err2 {
                            print("error in downloading url: \(err2)")
                        } else {
                            if let url = url {
                                print ("url: \(url)")
                            }
                            self.ref.child("memories").child(String(self.pinId!)).child(memId)
                            .setValue(["title": title, "memId": memIdInt, "blurb": blurb, "image": "\(String(describing: url!))"])
                        }
                        
                    })
                }
            }
            
            return true
        } else {
            return false
        }
    }
    
    weak var delegate: AddMemoryDelegate?
}
