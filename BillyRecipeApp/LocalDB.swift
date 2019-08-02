//
//  LocalDB.swift
//  BillyRecipeApp
//
//  Created by Billy on 02/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import Foundation
import SQLite

class LocalDB {
    let db = try? Connection("\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/recipedb.sqlite3")
    let recipeTypes = Table("recipe_types")
    let recipe = Table("recipe")
    
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    
    let recipeId = Expression<Int64>("id")
    let recipeName = Expression<String>("name")
    let recipeImgURL = Expression<String>("imageURL")
    let recipeSteps = Expression<String>("steps")
    let recipePrepTime = Expression<String>("prepTime")
    
    func setup() {
        do {
            //Create Recipe Types Table
            try db?.run(recipeTypes.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
            
            //Create Recipe Table
            try db?.run(recipe.create(ifNotExists: true) { t in
                t.column(recipeId, primaryKey: true)
                t.column(recipeName)
                t.column(recipeImgURL)
                t.column(recipeSteps)
                t.column(recipePrepTime)
            })
            
            print("SUCCESS")
        } catch {
            //ERROR CREATING TABLES
            print("FAILED")
        }
    }
    
    func populateRecipeTypes(recipeTypeNameArr: [String]) {
        do {
            try db?.run(recipeTypes.delete())
            for type in recipeTypeNameArr {
                try db?.run(recipeTypes.insert(name <- type))
            }
        } catch {
            
        }
    }
    
    func showRecipeTypes() -> [RecipeType] {
        var recipeTypeArr = [RecipeType]()
        do {
            for rt in try (db?.prepare(recipeTypes))! {
                recipeTypeArr += [RecipeType(id: Int(rt[id]), name: rt[name])]
            }
            return recipeTypeArr
        } catch {
            return recipeTypeArr
        }
    }
    
    func getRecipeType(recipeTypeID: Int64) -> RecipeType? {
        do {
            var recipeType: RecipeType? = nil
            let recipeTypeTable = recipeTypes.filter(id == recipeTypeID)
            
            for rt in try (db?.prepare(recipeTypeTable))! {
                recipeType = RecipeType(id: Int(rt[id]), name: rt[name])
            }
            return recipeType
        } catch {
            return nil
        }
    }
}
