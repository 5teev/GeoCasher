//
//  MasterViewModel.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/30/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import SwiftyJSON
import CoreLocation

struct MasterViewModel {
    var photoModels = [PhotoModel]()

    // follow SwiftyJSON convention in initializer
    init(withArray array: [JSON] ) {

        for item in array {

            if let photoModelDict = item.dictionary {

                let photoModel : PhotoModel = PhotoModel(withDictionary: photoModelDict)
                self.photoModels.append(photoModel)

            }
            
        }
    }

    func count() -> Int  {
        return photoModels.count
    }

    func photoModelForIndexPath(indexPath : NSIndexPath) -> PhotoModel? {

        let index = indexPath.row
        if ( index < photoModels.count ) {
            return photoModels[index]
        }
        return nil
    }

    // MARK: Sorts of sorts
    mutating func sortByDistanceFromLocation( location currentLocation : CLLocation  ) {
        
        photoModels = photoModels.sort {
            (modelOne, modelTwo) -> Bool in
            var distance1 : CLLocationDistance = 0.0
            var distance2 : CLLocationDistance = 0.0
            if let location1 = modelOne.photoLocation?.location, let location2 = modelTwo.photoLocation?.location {
                distance1 = currentLocation.distanceFromLocation(location1)
                distance2 = currentLocation.distanceFromLocation(location2)
            }
            
            return distance1 < distance2
        }
        
    }
    
    mutating func sortByTime() {
        
        photoModels = photoModels.sort {
            (modelOne, modelTwo) -> Bool in

            // compare times since epoch started
            let time1 : NSTimeInterval = (modelOne.photoCreationTime?.timeIntervalSince1970)!
            let time2 : NSTimeInterval = (modelTwo.photoCreationTime?.timeIntervalSince1970)!

            // most recent first
            return time1 > time2
        }
        
    }
    
}
