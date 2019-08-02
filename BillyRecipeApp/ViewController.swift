//
//  ViewController.swift
//  BillyRecipeApp
//
//  Created by Billy on 02/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var recipeTypePV: UIPickerView!
    @IBOutlet weak var pickerViewTB: UIToolbar!
    
    var recipeTypeNameArr = [String]()
    let localDB = LocalDB()
    var currentSelectedRecipeTypeID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let xmlPath = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: xmlPath) {
                parser.delegate = self
                parser.parse()
            }
        }
        
        recipeTypePV.delegate = self
        recipeTypePV.dataSource = self
        
        self.selectBtn.addTarget(self, action: #selector(beginBtnClicked), for: .touchUpInside)
    }
    
    @objc func beginBtnClicked() {
        recipeTypePV.isHidden = false
        pickerViewTB.isHidden = false
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        recipeTypePV.isHidden = true
        pickerViewTB.isHidden = true
    }
    
    @IBAction func selectBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(currentSelectedRecipeTypeID, forKey: "selectedRecipeTypeID")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        homeVC.selectedRecipeTypeID = currentSelectedRecipeTypeID
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.navigationBar.prefersLargeTitles = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            }, completion: { completed in
                // maybe do something here
            })
        }
        
        
    }
}

extension ViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "type" {
            if let name = attributeDict["name"] {
                recipeTypeNameArr += [name]
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        localDB.populateRecipeTypes(recipeTypeNameArr: recipeTypeNameArr)
        recipeTypePV.reloadAllComponents()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        currentSelectedRecipeTypeID = ID
    }
}
