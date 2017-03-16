//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by Mitch Guzman on 3/15/17.
//  Copyright © 2017 Mitch Guzman. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
