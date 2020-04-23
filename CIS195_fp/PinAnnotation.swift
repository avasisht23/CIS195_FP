//
//  PinAnnotation.swift
//  CIS195_fp
//
//  Created by Ajay on 4/3/20.
//  Copyright © 2020 University of Pennsylvania. All rights reserved.
//

import MapKit

// Note the use of typealias to create an "EggId" type
typealias Id = Int

class PinAnnotation: MKPointAnnotation {
    var id: Id
    var name: String
    
    init(coordinate: CLLocationCoordinate2D, id : Id, name : String) {
        self.id = id
        self.name = name
        super.init()
        self.coordinate = coordinate
    }
}
