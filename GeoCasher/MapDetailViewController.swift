//
//  DetailViewController.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/28/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)

    var photoModel: PhotoModel? {
        didSet {
            // Update the view. (Although current implementation 
            // won't update when photoModel is set, since view won't have loaded yet.)
            self.updateView()
        }
    }

    func updateView() {

        if let photoLocation = photoModel?.photoLocation {
            // set the title to the location name
            self.navigationItem.title = photoLocation.name

            if let location = photoLocation.location {
                
                // update the map if it exists (i.e., the view did load)
                if self.mapView != nil {
                    // position the map
                    self.mapView.setCenterCoordinate(location.coordinate, animated: true)
                    // and zoom in dramatically!
                    self.mapView.setCenterCoordinate(location.coordinate, animated: true)
                    self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
                    // add super bare-bones pin annotation
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = location.coordinate
                    pointAnnotation.title = photoLocation.name
                    pointAnnotation.subtitle = "(\(location.coordinate.latitude),\(location.coordinate.longitude))"
                    self.mapView.addAnnotation(pointAnnotation)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.updateView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // show nav bar
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
