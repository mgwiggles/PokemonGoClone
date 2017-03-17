//
//  PokeAnnotation.swift
//  PokemonGoClone
//
//  Created by Mitch Guzman on 3/16/17.
//  Copyright © 2017 Mitch Guzman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var pokemon : Pokemon
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
