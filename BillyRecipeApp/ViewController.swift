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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        loadingIndicator.isHidden = true
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
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        recipeTypePV.isHidden = true
        pickerViewTB.isHidden = true
        selectBtn.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in 1..<6 {
                self.preAddData(recipeTypeID: Int64(i))
            }
            
            if self.currentSelectedRecipeTypeID == 0 {
                self.currentSelectedRecipeTypeID = self.localDB.showRecipeTypes()[0].id
            }
            
            UserDefaults.standard.set(self.currentSelectedRecipeTypeID, forKey: "selectedRecipeTypeID")
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            homeVC.selectedRecipeTypeID = self.currentSelectedRecipeTypeID
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
    }
    
    func preAddData(recipeTypeID: Int64) {
        var recipeArr = [Recipe]()
        
        let mockText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dignissim vulputate diam, id ullamcorper odio congue maximus. Fusce vitae lorem et libero eleifend condimentum. Vivamus venenatis tristique tortor, sit amet malesuada nunc sodales in. Nulla a nisi ut quam egestas luctus. Ut nec sagittis elit. Maecenas quis ante nec felis mattis aliquet scelerisque vitae metus. Nullam id suscipit justo, ac bibendum neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam tincidunt ut nibh nec sodales. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc porta purus vel enim semper, nec feugiat leo sagittis. Nulla cursus facilisis urna et convallis. Donec pretium eleifend ligula quis egestas."
        
        let mockPrepTime = "30 Minutes"
        
        switch recipeTypeID {
        case 1:
            addImageToDocumentPath(imageFileName: "burrito.jpg")
            addImageToDocumentPath(imageFileName: "quesaddila.jpg")
            addImageToDocumentPath(imageFileName: "taco.jpg")
            recipeArr += [Recipe(id: 0, name: "Burrito", imageURL: "burrito.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Quesaddila", imageURL: "quesaddila.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Taco", imageURL: "taco.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
        case 2:
            addImageToDocumentPath(imageFileName: "aglioolio.jpg")
            addImageToDocumentPath(imageFileName: "pizza.jpg")
            addImageToDocumentPath(imageFileName: "carbonara.jpg")
            recipeArr += [Recipe(id: 0, name: "Aglio Olio", imageURL: "aglioolio.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Pizza", imageURL: "pizza.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Carbonara", imageURL: "carbonara.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
        case 3:
            addImageToDocumentPath(imageFileName: "sushi.jpg")
            addImageToDocumentPath(imageFileName: "soba.jpg")
            addImageToDocumentPath(imageFileName: "udon.jpg")
            recipeArr += [Recipe(id: 0, name: "Sushi", imageURL: "sushi.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Soba", imageURL: "soba.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Udon", imageURL: "udon.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
        case 4:
            addImageToDocumentPath(imageFileName: "kimchi.jpg")
            addImageToDocumentPath(imageFileName: "friedchicken.jpg")
            addImageToDocumentPath(imageFileName: "bibimbap.jpg")
            recipeArr += [Recipe(id: 0, name: "Kimchi", imageURL: "kimchi.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Korean Fried Chicken", imageURL: "friedchicken.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
            recipeArr += [Recipe(id: 0, name: "Bibimbap", imageURL: "bibimbap.jpg", ingredients: mockText, steps: mockText, prepTime: mockPrepTime)]
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
