//
//  HomeViewController.swift
//  BillyRecipeApp
//
//  Created by Billy on 02/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var recipeCV: UICollectionView!
    @IBOutlet weak var recipeTypePV: UIPickerView!
    @IBOutlet weak var pickerViewTB: UIToolbar!
    
    var pickerSelectedRecipeTypeID: Int = 0
    var pickerSelectedRecipeTypeName: String = ""
    var selectedRecipeTypeID: Int = 0
    var recipeType: RecipeType? = nil
    let localDB = LocalDB()
    
    var recipeArr = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let filterBtn = UIButton(type: .custom)
        filterBtn.setImage(UIImage(named: "filter"), for: .normal)
        filterBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filterBtn.addTarget(self, action: #selector(filterBtnClicked), for: .touchUpInside)
        let filterItem = UIBarButtonItem(customView: filterBtn)
        
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "add"), for: .normal)
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addBtn.addTarget(self, action: #selector(addBtnClicked), for: .touchUpInside)
        let addItem = UIBarButtonItem(customView: addBtn)
        
        self.navigationItem.leftBarButtonItem = filterItem
        self.navigationItem.rightBarButtonItem = addItem
        
        recipeCV.delegate = self
        recipeCV.dataSource = self
        
        recipeTypePV.delegate = self
        recipeTypePV.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recipeType = localDB.getRecipeType(recipeTypeID: Int64(selectedRecipeTypeID))
        if let rt = recipeType {
            self.navigationItem.title = rt.name
            recipeArr = localDB.getRecipeList(recipeTypeID: Int64(rt.id))
            recipeCV.reloadData()
        }
    }
    
    @objc func filterBtnClicked() {
        recipeTypePV.isHidden = false
        pickerViewTB.isHidden = false
    }
    
    @objc func addBtnClicked() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateRecipeVC") as! AddUpdateRecipeViewController
        vc.barTitle = "Add Recipe"
        vc.currentRecipeTypeID = selectedRecipeTypeID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        recipeTypePV.isHidden = true
        pickerViewTB.isHidden = true
    }
    
    @IBAction func selectBtnClicked(_ sender: Any) {
        recipeTypePV.isHidden = true
        pickerViewTB.isHidden = true
        
        selectedRecipeTypeID = pickerSelectedRecipeTypeID
        self.navigationItem.title = pickerSelectedRecipeTypeName
        recipeArr = localDB.getRecipeList(recipeTypeID: Int64(selectedRecipeTypeID))
        recipeCV.reloadData()
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        return cell
    }
}

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localDB.showRecipeTypes().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localDB.showRecipeTypes()[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let ID = localDB.showRecipeTypes()[row].id
        let name = localDB.showRecipeTypes()[row].name
        pickerSelectedRecipeTypeID = ID
        pickerSelectedRecipeTypeName = name
    }
}
