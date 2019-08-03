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
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        cell.recipeIV.image = UIImage(contentsOfFile: "\(documentPath)/\(recipeArr[indexPath.row].imageURL)")
        cell.recipeNameLbl.text = recipeArr[indexPath.row].name
        
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.2)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 20
        let size = (collectionView.frame.size.width - padding)/2
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsViewController
        vc.currentRecipeTypeID = selectedRecipeTypeID
        vc.recipeID = recipeArr[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
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
