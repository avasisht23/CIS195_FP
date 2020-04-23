//
//  AddPinDBViewController.swift
//  CIS195_fp
//
//  Created by Ajay Vasisht on 4/23/20.
//  Copyright © 2020 Ajay Vasisht. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol AddPinDelegate: class {
    func didCreate(_ yes: Bool)
}

class AddPinDBViewController : UIViewController {
    // set up Firebase variables (ref, refHandle)
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle!
    
    override func viewDidLoad() {
        print("add pin db")
        // set up Firebase ref
        ref = Database.database().reference()
    }
    
    @IBOutlet weak var IdInput: UITextField!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var LatInput: UITextField!
    @IBOutlet weak var LongInput: UITextField!
    
    @IBAction func Cancel(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Save(_ sender: Any) {
        if (createPinAndAddDB()) {
            self.delegate?.didCreate(true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func createPinAndAddDB() -> Bool {
        let nilBool : Bool = IdInput != nil && NameInput != nil && LatInput != nil && LongInput != nil
        let emptyBool : Bool = IdInput?.text != "" && NameInput?.text != "" && LatInput?.text != "" && LongInput?.text != ""

        if (nilBool && emptyBool) {
        
            let pinId : String = IdInput.text!
            
            let pinIdInt : Int = Int(pinId)!
            let pinName : String = NameInput.text!
            let lat : Float = Float(LatInput.text!)!
            let long : Float = Float(LongInput.text!)!
            
            self.ref.child("pins").child(pinId).setValue(["id": pinIdInt, "name": pinName, "lat": lat, "long": long])

            
            return true
        } else {
            return false
        }
    }
    
    weak var delegate: AddPinDelegate?
}
