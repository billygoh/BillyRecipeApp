//
//  RecipeViewModel.swift
//  BillyRecipeApp
//
//  Created by Billy on 13/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import UIKit

public class RecipeViewModel {
    
    static let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let recipe: Recipe
    let recipeImage: UIImage
    let recipeName: String
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.recipeName = recipe.name
        self.recipeImage = UIImage(contentsOfFile: "\(RecipeViewModel.documentPath)/\(recipe.imageURL)")!
    }
}
