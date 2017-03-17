//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Mitch Guzman on 3/15/17.
//  Copyright © 2017 Mitch Guzman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            
            manager.startUpdatingLocation()
            mapView.delegate = self
        } else {
            
            manager.requestWhenInUseAuthorization()
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            //            Spawn a pokemon
            
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.image = UIImage(named: "player")
            annoView.frame = frame
            
            return annoView
        }
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        
        annoView.image = UIImage(named: pokemon.imageName!)
        
        annoView.frame = frame
        
        return annoView
    }
    
    
    
}

