//
//  PhotoObject.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/28/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import SwiftyJSON

struct PhotoModel {
    var photoLocation : PhotoLocation?
    var photoCreationTime : NSDate?
    var photoImageStandard : PhotoImage?
    var photoImageThumbnail : PhotoImage?
    var photoImageLowRes : PhotoImage?

    // follow SwiftyJSON convention in initializer
    init(withDictionary dict : [String : JSON] ) {

        if let locationDict = dict["location"]?.dictionary {
            photoLocation = PhotoLocation(withDictionary: locationDict)
        }

        if let imageDicts = dict["images"]?.dictionary {

            if let standardImageDict = imageDicts["standard_resolution"]?.dictionary {
                photoImageStandard = PhotoImage(withDictionary: standardImageDict)
            }

            if let lowResImageDict = imageDicts["low_resolution"]?.dictionary {
                photoImageLowRes = PhotoImage(withDictionary: lowResImageDict)
            }

            if let thumbnailImageDict = imageDicts["thumbnail"]?.dictionary {
                photoImageThumbnail = PhotoImage(withDictionary: thumbnailImageDict)
            }

        }

        // another sorting option may be of interest someday...
        if let timeStamp = dict["created_time"]?.doubleValue {
            photoCreationTime = NSDate(timeIntervalSince1970: timeStamp)
        }
    }

    func description() {
        print( "PhotoObject: \(photoLocation?.name) (\(photoLocation?.id)) at \(photoLocation?.location) with image \(photoImageStandard)" )
        photoLocation?.description()
        photoImageStandard?.description()
        photoImageLowRes?.description()
        photoImageThumbnail?.description()
    }
}
