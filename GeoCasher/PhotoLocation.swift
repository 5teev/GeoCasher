//
//  PhotoLocation.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/28/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct PhotoLocation {
    var location  : CLLocation?
    var name      : String  = ""
    var id        : Int64   = -1

    // follow SwiftyJSON convention in initializer
    init(withDictionary dict : [String : JSON] ) {

        if let latitude = dict["latitude"]?.double, let longitude = dict["longitude"]?.double {

            /*
                This should work but somehow breaks CLLocation's distanceFromLocation() method
                so that it always returns 0 as the distance between this and some random location.
                (At least in the simulator.)
            */
            location = CLLocation(latitude: longitude, longitude: latitude)

            /*
                Instead create CLLocation with fake altitude, accuracy, speed, and timestamp
                and the location object properly* calculates a value for distanceFromLocation().
                * - although not 100% accurate, this should be reasonably accurate within
                a small geographical area, e.g., a few square blocks in downtown PDX.
            */
            location = CLLocation(coordinate: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate())

        }

        if let placeName = dict["name"]?.string {
            name = placeName
        }

        if let placeID = dict["id"]?.int64 {
            id = placeID
        }
    }

    func description() -> String {
        return "location \(name) (id: \(id)) at \(location?.coordinate)"
    }
}
