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
    var recipe: Recipe? = nil
    let localDB = LocalDB()
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let editBtn = UIButton(type: .custom)
        editBtn.setImage(UIImage(named: "edit"), for: .normal)
        editBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        editBtn.addTarget(self, action: #selector(editBtnClicked), for: .touchUpInside)
        let editItem = UIBarButtonItem(customView: editBtn)
        
        self.navigationItem.rightBarButtonItem = editItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecipe()
    }

    func loadRecipe() {
        recipe = localDB.getRecipeDetails(recipeID: Int64(recipeID))
        if let rp = recipe {
            self.navigationItem.title = rp.name
            recipeIV.image = UIImage(contentsOfFile: "\(documentPath)/\(rp.imageURL)")
            prepTimeLbl.text = "Prep Time: \(rp.prepTime)"
            ingredientLbl.text = rp.ingredients
            stepsLbl.text = rp.steps
        }
    }
    
    @objc func editBtnClicked() {
        let alert = UIAlertController(title: "Select your action", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateRecipeVC") as! AddUpdateRecipeViewController
            vc.isEditingRecipe = true
            vc.recipe = self.recipe
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            let success = self.localDB.removeRecipe(recipeID: Int64(self.recipeID))
            if success {
                let alert = UIAlertController(title: "Success", message: "Successfully removed recipe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Problem removing recipe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(alert, animated: true, completion: nil)
    }
}
