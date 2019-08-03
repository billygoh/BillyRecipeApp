//
//  AddUpdateRecipeViewController.swift
//  BillyRecipeApp
//
//  Created by Billy on 03/08/2019.
//  Copyright © 2019 BillyGDev. All rights reserved.
//

import UIKit

class AddUpdateRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeNameTF: UITextField!
    @IBOutlet weak var recipeIV: UIImageView!
    @IBOutlet weak var recipeStepsTV: UITextView!
    @IBOutlet weak var recipePrepTimeTF: UITextField!
    
    var barTitle: String = ""
    var selectedImageUpload: UIImage?
    var currentRecipeTypeID: Int = 0
    
    let localDB = LocalDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = barTitle
        recipeStepsTV.text = "Steps"
        recipeStepsTV.textColor = UIColor.lightGray
        recipeStepsTV.delegate = self
        recipeNameTF.delegate = self
        recipePrepTimeTF.delegate = self
        
        let imageviewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        recipeIV.isUserInteractionEnabled = true
        recipeIV.addGestureRecognizer(imageviewTap)
        
        let saveBtn = UIButton(type: .custom)
        saveBtn.setImage(UIImage(named: "ok"), for: .normal)
        saveBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        let saveItem = UIBarButtonItem(customView: saveBtn)
        
        self.navigationItem.rightBarButtonItem = saveItem
    }
    
    @objc func saveBtnClicked() {
        saveDetails()
    }
    
    @objc func imageViewTapped() {
        performImagePicker()
    }
    
    func saveDetails() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        if let recipeName = recipeNameTF.text, let img = selectedImageUpload, let prepTime = recipePrepTimeTF.text, let steps = recipeStepsTV.text {
            var imageFileName = ""
            guard let imgData = img.jpegData(compressionQuality: 1.0) else {
                print("image data error")
                return
            }
            
            do {
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyyMMddHHmmss"
                let formattedDate = format.string(from: date)
                imageFileName = "\(formattedDate).jpg"
                try imgData.write(to: URL(fileURLWithPath: "\(documentPath)/\(imageFileName)"))
            } catch {
                return
            }
            
            let success = localDB.addRecipe(recipeArr: [Recipe(id: 0, name: recipeName, imageURL: imageFileName, ingredients: "", steps: steps, prepTime: prepTime)], recipeTypeID: Int64(currentRecipeTypeID))
            
            if success {
                let alert = UIAlertController(title: "Success", message: "Successfully added recipe!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "There are problems adding recipe", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incomplete Detail", message: "Please fill in the recipe details", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func performImagePicker() {
        let alert = UIAlertController(title: "Select Your Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.cameraPicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.galleryPicker()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraPicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Error", message: "There is no camera in your device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func galleryPicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Error", message: "Please allow permission to access device Gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AddUpdateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipeIV.contentMode = .scaleToFill
            recipeIV.image = selectedImage
            selectedImageUpload = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddUpdateRecipeViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Steps" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Steps"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
