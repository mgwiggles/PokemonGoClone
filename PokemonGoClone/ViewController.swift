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
            
            setup()
            
        } else {
            
            manager.requestWhenInUseAuthorization()
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func setup() {
        
        mapView.showsUserLocation = true
        
        manager.startUpdatingLocation()
        mapView.delegate = self
        
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
        
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
//                    print("Can catch the pokemon")
                    
                    let pokemon = (view.annotation as! PokeAnnotation).pokemon
                    pokemon.caught = true
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats", message: "You caught a \(pokemon.name!)!", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    
                    alertVC.addAction(pokedexAction)
                    
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
//                    print("pokemon is out of reach")
//                    Create alter view controller
                    let alertVC = UIAlertController(title: "Uh-Oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it! ", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        
        })
        
        
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

