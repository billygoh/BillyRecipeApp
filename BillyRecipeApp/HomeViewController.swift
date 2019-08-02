//
//  HomeViewController.swift
//  BillyRecipeApp
//
//  Created by Billy on 02/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var selectedRecipeTypeID: Int = 0
    var recipeType: RecipeType? = nil
    let localDB = LocalDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeType = localDB.getRecipeType(recipeTypeID: Int64(selectedRecipeTypeID))
        if let rt = recipeType {
            self.navigationItem.title = rt.name
        }
        
    }
}
