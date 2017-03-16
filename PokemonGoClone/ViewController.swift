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
    
    var updateCount = 0
    
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
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            //            Spawn a pokemon
            
            if let coord = self.manager.location?.coordinate {
                
                let anno = MKPointAnnotation()
                
                let randoLat = (Double(arc4random_uniform(200)) - 100) / 50000.0
                let randoLong = (Double(arc4random_uniform(200)) - 100) / 50000.0
                
                anno.coordinate = coord
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLong
                self.mapView.addAnnotation(anno)
            }
            
            //            print("Timer")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print("we made it")
        
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            
            mapView.setRegion(region, animated: false)
            
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
        
        
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
            
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            
            mapView.setRegion(region, animated: true)
            
        }
        
        
    }
    
    
    
}

