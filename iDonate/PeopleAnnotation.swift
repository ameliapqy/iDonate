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
    var userType: String
    var name: String
    
    init(coordinate: CLLocationCoordinate2D, id: Int, supplyNumber: Int, supplyType: String, tel: Int, type: String, name: String) {
        self.id = id
        self.supplyNumber = supplyNumber
        self.supplyType = supplyType
        self.tel = tel
        self.userType = type
        self.name = name
        super.init()
        self.coordinate = coordinate
    }
}
