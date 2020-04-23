//
//  PeopleAnnotation.swift
//  iDonate
//
//  Created by Qingyuan Peng on 4/16/20.
//  Copyright © 2020 pqy. All rights reserved.
//
import MapKit

class PeopleAnnotation: MKPointAnnotation {
    var id: Int
    var supplyNumber: Int
    var supplyType: String
    var tel: Int
    
    init(coordinate: CLLocationCoordinate2D, id: Int, supplyNumber: Int, supplyType: String, tel: Int) {
        self.id = id
        self.supplyNumber = supplyNumber
        self.supplyType = supplyType
        self.tel = tel
        super.init()
        self.coordinate = coordinate
    }
}
