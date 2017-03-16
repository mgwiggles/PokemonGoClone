//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Mitch Guzman on 3/15/17.
//  Copyright © 2017 Mitch Guzman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            
            manager.startUpdatingLocation()
            
            print("ready to go!")
        } else {
        
        manager.requestWhenInUseAuthorization()
        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("we made it")
    }


}

