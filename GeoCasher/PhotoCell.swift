//
//  PhotoCellCollectionViewCell.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/30/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import UIKit
import Alamofire

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    var photoModel : PhotoModel?

    func setPhotoModel (model: PhotoModel ) {
        self.photoModel = model
        
        let name = self.photoModel!.photoLocation!.name
        label?.text = name
        let url = self.photoModel!.photoImageStandard!.URL
        imageView.imageFromUrl(url!)

    }

    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
        label.text = ""
        super.prepareForReuse()
    }
}

extension Alamofire.Request {
}

@objc public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}


extension UIImageView {
    public func imageFromUrl(url: NSURL) {
        Alamofire.request(.GET, url).validate(contentType: ["image/*"]).responseData { (request: NSURLRequest?, response: NSHTTPURLResponse?, data : Result) -> Void in

            let image = UIImage(data: data.value!, scale: UIScreen.mainScreen().scale)
            self.image = image
            self.setNeedsDisplay()
        }
    }
}