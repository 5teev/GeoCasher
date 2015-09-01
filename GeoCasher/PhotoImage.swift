//
//  PhotoImage.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/28/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import SwiftyJSON

struct PhotoImage {
    var URL     : NSURL?
    var width   : Float  = 0
    var height      : Float  = 0
    
    // follow SwiftyJSON convention in initializer
    init(withDictionary dict : [String : JSON] ) {

        if let urlString = dict["url"]?.string  {
            URL = NSURL(string: urlString)

        }
        
        if let imageWidth = dict["width"]?.float {
            width = imageWidth
        }
        
        if let imageHeight = dict["height"]?.float {
            height = imageHeight
        }
    }
    
    func description() {
        print( "URL \(URL) ( \(width) x \(height) )" )
    }
}
