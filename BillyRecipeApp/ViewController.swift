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
        for i in 1..<6 {
            preAddData(recipeTypeID: Int64(i))
        }
        
        UserDefaults.standard.set(currentSelectedRecipeTypeID, forKey: "selectedRecipeTypeID")
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        homeVC.selectedRecipeTypeID = currentSelectedRecipeTypeID
        let navigationController = UINavigationController(rootViewController: homeVC)
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navigationController
            }, completion: { completed in
            })
        }
    }
    
    func preAddData(recipeTypeID: Int64) {
        var recipeArr = [Recipe]()
        
        switch recipeTypeID {
        case 1:
            addImageToDocumentPath(imageFileName: "burrito.jpg")
            addImageToDocumentPath(imageFileName: "quesaddila.jpg")
            addImageToDocumentPath(imageFileName: "taco.jpg")
            recipeArr += [Recipe(id: 0, name: "Burrito", imageURL: "burrito.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Quesaddila", imageURL: "quesaddila.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Taco", imageURL: "taco.jpg", steps: "step 123", prepTime: "prep 123")]
        case 2:
            addImageToDocumentPath(imageFileName: "aglioolio.jpg")
            addImageToDocumentPath(imageFileName: "pizza.jpg")
            addImageToDocumentPath(imageFileName: "carbonara.jpg")
            recipeArr += [Recipe(id: 0, name: "Aglio Olio", imageURL: "aglioolio.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Pizza", imageURL: "pizza.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Carbonara", imageURL: "carbonara.jpg", steps: "step 123", prepTime: "prep 123")]
        case 3:
            addImageToDocumentPath(imageFileName: "sushi.jpg")
            addImageToDocumentPath(imageFileName: "soba.jpg")
            addImageToDocumentPath(imageFileName: "udon.jpg")
            recipeArr += [Recipe(id: 0, name: "Sushi", imageURL: "sushi.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Soba", imageURL: "soba.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Udon", imageURL: "udon.jpg", steps: "step 123", prepTime: "prep 123")]
        case 4:
            addImageToDocumentPath(imageFileName: "kimchi.jpg")
            addImageToDocumentPath(imageFileName: "friedchicken.jpg")
            addImageToDocumentPath(imageFileName: "bibimbap.jpg")
            recipeArr += [Recipe(id: 0, name: "Kimchi", imageURL: "kimchi.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Korean Fried Chicken", imageURL: "friedchicken.jpg", steps: "step 123", prepTime: "prep 123")]
            recipeArr += [Recipe(id: 0, name: "Bibimbap", imageURL: "bibimbap.jpg", steps: "step 123", prepTime: "prep 123")]
        default:
            return
        }

        let _ = localDB.addRecipe(recipeArr: recipeArr, recipeTypeID: recipeTypeID)
    }
    
    func addImageToDocumentPath(imageFileName: String) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let img = UIImage(named: imageFileName) {
            guard let imgData = img.jpegData(compressionQuality: 1.0) else {
                print("image data error")
                return
            }
            
            do {
                try imgData.write(to: URL(fileURLWithPath: "\(documentPath)/\(imageFileName)"))
            } catch {
                return
            }
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
