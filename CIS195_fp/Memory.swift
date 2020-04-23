//
//  Memory.swift
//  CIS195_fp
//
//  Created by Ajay Vasisht on 4/23/20.
//  Copyright © 2020 Ajay Vasisht. All rights reserved.
//

import Foundation
import UIKit

struct Memory {
    var title : String
    var memId : Int
    var blurb : String
    var image : URL?
    
    init(title: String, memId : Int, blurb: String) {
        self.title = title
        self.memId = memId
        self.blurb = blurb
    }

    init(title: String, memId : Int, blurb: String, image : URL?) {
        self.title = title
        self.memId = memId
        self.blurb = blurb
        self.image = image
    }
}
