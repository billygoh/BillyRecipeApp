//
//  Recipe.swift
//  BillyRecipeApp
//
//  Created by Billy on 02/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import Foundation

struct RecipeType {
    var id: Int
    var name: String
}

struct Recipe {
    var id: Int
    var name: String
    var imageURL: String
    var ingredients: String
    var steps: String
    var prepTime: String
}
