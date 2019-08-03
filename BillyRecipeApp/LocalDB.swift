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
    let recipeTypesTable = Table("recipe_types")
    let recipeTable = Table("recipe")
    
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    
    let recipeId = Expression<Int64>("id")
    let recipeTypeId = Expression<Int64>("recipeTypeId")
    let recipeName = Expression<String>("name")
    let recipeImgURL = Expression<String>("imageURL")
    let recipeIngredients = Expression<String>("ingredients")
    let recipeSteps = Expression<String>("steps")
    let recipePrepTime = Expression<String>("prepTime")
    
    func setup() {
        do {
            //Create Recipe Types Table
            try db?.run(recipeTypesTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
            
            //Create Recipe Table
            try db?.run(recipeTable.create(ifNotExists: true) { t in
                t.column(recipeId, primaryKey: true)
                t.column(recipeTypeId)
                t.column(recipeName)
                t.column(recipeImgURL)
                t.column(recipeIngredients)
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
            try db?.run(recipeTypesTable.delete())
            for type in recipeTypeNameArr {
                try db?.run(recipeTypesTable.insert(name <- type))
            }
        } catch {
            
        }
    }
    
    func showRecipeTypes() -> [RecipeType] {
        var recipeTypeArr = [RecipeType]()
        do {
            for rt in try (db?.prepare(recipeTypesTable))! {
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
            let recipeTypeTable = recipeTypesTable.filter(id == recipeTypeID)
            
            for rt in try (db?.prepare(recipeTypeTable))! {
                recipeType = RecipeType(id: Int(rt[id]), name: rt[name])
            }
            return recipeType
        } catch {
            return nil
        }
    }
    
    func addRecipe(recipeArr: [Recipe], recipeTypeID: Int64) -> Bool {
        do {
            if recipeArr.count > 0 {
                for recipe in recipeArr {
                    try db?.run(recipeTable.insert(recipeTypeId <- recipeTypeID, recipeName <- recipe.name, recipeImgURL <- recipe.imageURL, recipeIngredients <- recipe.ingredients, recipeSteps <- recipe.steps, recipePrepTime <- recipe.prepTime))
                }
                return true
            }
            return false
        } catch {
            return false
        }
    }
    
    func getRecipeList(recipeTypeID: Int64) -> [Recipe] {
        var recipeArr = [Recipe]()
        do {
            let recipeFilteredTable = recipeTable.filter(recipeTypeId == recipeTypeID)
            for r in try (db?.prepare(recipeFilteredTable))! {
                recipeArr += [Recipe(id: Int(r[recipeId]), name: r[recipeName], imageURL: r[recipeImgURL], ingredients: r[recipeIngredients] , steps: r[recipeSteps], prepTime: r[recipePrepTime])]
            }
            
            return recipeArr
        } catch {
            return recipeArr
        }
    }
    
    func getRecipeDetails(recipeID: Int64) -> Recipe? {
        do {
            var recipe: Recipe? = nil
            let recipeFilteredTable = recipeTable.filter(id == recipeID)
            
            for r in try (db?.prepare(recipeFilteredTable))! {
                recipe = Recipe(id: Int(r[recipeId]), name: r[recipeName], imageURL: r[recipeImgURL], ingredients: r[recipeIngredients] , steps: r[recipeSteps], prepTime: r[recipePrepTime])
            }
            return recipe
        } catch {
            return nil
        }
    }
}
