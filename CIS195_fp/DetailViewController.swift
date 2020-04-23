//
//  DetailViewController.swift
//  CIS195_fp
//
//  Created by Ajay Vasisht on 4/23/20.
//  Copyright © 2020 Ajay Vasisht. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var subtitleInfo: UILabel!
    @IBOutlet weak var blurbInfo: UILabel!
    
    var inputTitle : String = ""
    var inputSubtitle : String = ""
    var inputBlurb : String = ""
    var inputImageUrl : URL? = nil

    
    override func viewDidLoad() {
//        print("hi")
        titleInfo.text = inputTitle
        subtitleInfo.text = inputSubtitle
        blurbInfo.text = inputBlurb

        if (inputImageUrl != nil) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: self.inputImageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.pic.image = UIImage(data: data!)
                }
            }
        }
        
    }
}
