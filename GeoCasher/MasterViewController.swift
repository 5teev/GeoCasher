//
//  MasterViewController.swift
//  GeoCasher
//
//  Created by Steve Milano on 8/28/15.
//  Copyright © 2015 Steve Milano. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class MasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {

    let dataURLString : String = "http://127.0.0.1:8000/imagefeed.json"
    private var myContext = 0
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!

    // empty view model to start the MVVM party
    var viewModel : MasterViewModel = MasterViewModel(withArray: [])

    var locationManager : CLLocationManager = CLLocationManager()
    var latestLocation : CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // if location services are available, try to use them
        if CLLocationManager.locationServicesEnabled() {

            locationManager.delegate = self

            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
                startMonitoringLocation()
            } else {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }

        // initialize default view model with no data
        self.viewModel = MasterViewModel(withArray: [])
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.viewModel = MasterViewModel(withURL: dataURLString)
        self.viewModel.addObserver(self, forKeyPath: "isLoading", options: .New, context: &myContext)
        self.viewModel.addObserver(self, forKeyPath: "error", options: .New, context: &myContext)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // no nav bar
        self.navigationController?.navigationBarHidden = true
    }

    func handleViewModelUpdate() {
        // update the view
        self.activityIndicator.stopAnimating()
        self.latestLocation = nil
        self.collectionView?.reloadData()
        
    }
    
    func handleViewModelError(error : NSError ) {
            // minimal error message
            var errorMessage = "There was a problem loading data."
            
            // give better error message if possible
            if let errorObject = error as NSError? {
                errorMessage.appendContentsOf("\n\"\(errorObject.localizedDescription)\"")
            }
        
            // build and show alertView with error message
            let alertController = UIAlertController.init(title: "Can't Load Data", message: errorMessage, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK",
                style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: false, completion: nil)

    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                print("value changed: \(newValue)")
                handleViewModelUpdate()
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    deinit {
        self.viewModel.removeObserver(self, forKeyPath: "isLoading", context: &myContext)
        self.viewModel.removeObserver(self, forKeyPath: "error", context: &myContext)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showDetail" {

            if let cell = sender as! PhotoCell? {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MapDetailViewController

                controller.photoModel = cell.photoModel
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Collection View

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell

        if let photoModel = viewModel.photoModelForIndexPath(indexPath) {
            cell.photoModel = photoModel
        }
        
        return cell
    }
    

    // MARK: - Location Manager 
    func startMonitoringLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
        latestLocation = nil
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
  
        // we should update the sort order if location changes or if we haven't yet sorted by location
        if newLocation.distanceFromLocation(oldLocation) > 0 || latestLocation  == nil {

            latestLocation = newLocation
            viewModel.sortByDistanceFromLocation(location: newLocation)
            collectionView.reloadData()
            // Since the photo order could change, it might be nice to scroll to top here;
            // however, this could also be annoying to users changing location quickly
            // (e.g., in a vehicle) who were trying to scroll down. I'll leave it to the UI folks.
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch( status ) {

            case .Authorized: fallthrough
            case .AuthorizedAlways: fallthrough
            case .AuthorizedWhenInUse:
                startMonitoringLocation()

            case .Denied: fallthrough
            case .NotDetermined: fallthrough
            case .Restricted:
                stopMonitoringLocation()
        }
    }

}

