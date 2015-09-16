//
//  MasterViewModel.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/30/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import SwiftyJSON
import CoreLocation
import Alamofire
import SwiftyJSON

class MasterViewModel : NSObject {
    var photoModels = [PhotoModel]()

    // KVO vars for view controller
    dynamic var isLoading : Bool = true
    dynamic var error : NSError?

    // follow SwiftyJSON convention in initializer
    init(withArray array: [JSON] ) {
        super.init()
        self.setPhotoModelsWithArray(array)
    }

    init(withURL dataURLString: String) {
        super.init()
        
        // try to load data from API call at URL
        Alamofire.request(.GET, dataURLString ).responseJSON { _, _, result in
            
            switch result {
                case .Success(let data):
                    let json = JSON(data)

                    // process data
                    if let photoModelsArray = json.array {
                        self.setPhotoModelsWithArray(photoModelsArray)
                    }
                    self.isLoading = false
                    
                case .Failure(_, let error):
                    if let errorObject = error as NSError? {
                        self.error = errorObject
                    }
                }
        }
    }

    func setPhotoModelsWithArray(array : [JSON] ) {
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
    func sortByDistanceFromLocation( location currentLocation : CLLocation  ) {
        
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
    
    func sortByTime() {
        
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
