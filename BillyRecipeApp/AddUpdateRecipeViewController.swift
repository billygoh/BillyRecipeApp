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
    @IBOutlet weak var recipeIngredientTV: UITextView!
    @IBOutlet weak var contentSV: UIScrollView!
    
    var isEditingRecipe: Bool = false
    var recipe: Recipe? = nil
    var selectedImageUpload: UIImage?
    var currentRecipeTypeID: Int = 0
    
    let localDB = LocalDB()
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeStepsTV.delegate = self
        recipeStepsTV.tag = 1
        recipeIngredientTV.delegate = self
        recipeIngredientTV.tag = 2
        recipeNameTF.delegate = self
        recipePrepTimeTF.delegate = self
        
        if !isEditingRecipe {
            self.navigationItem.title = "Add Recipe"
            recipeStepsTV.text = "Steps"
            recipeIngredientTV.text = "Ingredients"
            recipeIngredientTV.textColor = UIColor.lightGray
            recipeStepsTV.textColor = UIColor.lightGray
            recipeIV.contentMode = .center
        } else {
            self.navigationItem.title = "Edit Recipe"
            recipeIngredientTV.textColor = UIColor.black
            recipeStepsTV.textColor = UIColor.black
            recipeIV.contentMode = .scaleAspectFill
            if let rp = recipe {
                recipeNameTF.text = rp.name
                recipeIngredientTV.text = rp.ingredients
                recipeStepsTV.text = rp.steps
                recipePrepTimeTF.text = rp.prepTime
                recipeIV.image = UIImage(contentsOfFile: "\(documentPath)/\(rp.imageURL)")
            }
        }
        
        let imageviewTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        recipeIV.isUserInteractionEnabled = true
        recipeIV.addGestureRecognizer(imageviewTap)
        
        let saveBtn = UIButton(type: .custom)
        saveBtn.setImage(UIImage(named: "ok"), for: .normal)
        saveBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        let saveItem = UIBarButtonItem(customView: saveBtn)
        
        self.navigationItem.rightBarButtonItem = saveItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func saveBtnClicked() {
        saveDetails()
    }
    
    @objc func imageViewTapped() {
        performImagePicker()
    }
    
    func saveDetails() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        if let recipeName = recipeNameTF.text, let prepTime = recipePrepTimeTF.text, let steps = recipeStepsTV.text, let ingredients = recipeIngredientTV.text {
            var imageFileName = ""
            if let img = selectedImageUpload {
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
            }
            
            var success = false
            var successMsg = ""
            
            if !isEditingRecipe {
                success = localDB.addRecipe(recipeArr: [Recipe(id: 0, name: recipeName, imageURL: imageFileName, ingredients: ingredients, steps: steps, prepTime: prepTime)], recipeTypeID: Int64(currentRecipeTypeID))
                successMsg = "Successfully added recipe!"
            } else {
                if let rp = recipe {
                    if imageFileName == "" {
                        imageFileName = rp.imageURL
                    }
                    success = localDB.editRecipe(recipe: Recipe(id: rp.id, name: recipeName, imageURL: imageFileName, ingredients: ingredients, steps: steps, prepTime: prepTime))
                    successMsg = "Successfully updated recipe!"
                }
            }
            
            if success {
                let alert = UIAlertController(title: "Success", message: successMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "There are problems occured", preferredStyle: .alert)
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
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = contentSV.contentInset
        contentInset.bottom = keyboardFrame.size.height
        contentSV.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        contentSV.contentInset = contentInset
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
        if textView.tag == 1 {
            if textView.text == "Steps" {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        } else if textView.tag == 2 {
            if textView.text == "Ingredients" {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 1 {
            if textView.text == "" {
                textView.text = "Steps"
                textView.textColor = UIColor.lightGray
            }
        } else if textView.tag == 2 {
            if textView.text == "" {
                textView.text = "Ingredients"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
