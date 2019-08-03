//
//  RecipeDetailsViewController.swift
//  BillyRecipeApp
//
//  Created by Billy on 03/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UIViewController {
    
    @IBOutlet weak var recipeIV: UIImageView!
    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var ingredientLbl: UILabel!
    @IBOutlet weak var stepsLbl: UILabel!
    
    var currentRecipeTypeID: Int = 0
    var recipeID: Int = 0
    let localDB = LocalDB()
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadRecipe()
        
        let editBtn = UIButton(type: .custom)
        editBtn.setImage(UIImage(named: "edit"), for: .normal)
        editBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editBtn.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        let editItem = UIBarButtonItem(customView: editBtn)
        
        self.navigationItem.rightBarButtonItem = editItem
    }

    func loadRecipe() {
        if let recipe = localDB.getRecipeDetails(recipeID: Int64(recipeID)) {
            self.navigationItem.title = recipe.name
            recipeIV.image = UIImage(contentsOfFile: "\(documentPath)/\(recipe.imageURL)")
            prepTimeLbl.text = "Prep Time: \(recipe.prepTime)"
            ingredientLbl.text = recipe.ingredients
            stepsLbl.text = recipe.steps
        }
    }
    
    @objc func editBtnClicked() {
        let alert = UIAlertController(title: "Select your action", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
