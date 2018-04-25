//
//  ImageViewController.swift
//  Swirl
//
//  Created by shani herskowitz on 4/12/18.
//  Copyright © 2018 shani herskowitz. All rights reserved.
//

import UIKit
import os.log
struct MyVariables {
    static var num = 1
}
class ImageViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var RatingStarz: RatingControl!
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var image: Image?
    @IBOutlet weak var TextField: UITextField!
    let limitLength = 22
    //var buttonCol = #colorLiteral(red: 0.678948597, green: 0.5924711366, blue: 1, alpha: 1)
    
  
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var SaveImage: UIBarButtonItem!
    @IBOutlet weak var CancelImage: UIBarButtonItem!
    @IBOutlet weak var ClearText: UIButton!
    @IBOutlet weak var DefText: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        TextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let image = image {
            navigationItem.title = image.name
            TextField.text   = image.name
            photoImageView.image = image.photo
            RatingStarz.rating = image.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    func setButtonColors(buttonCol: UIColor) {
        SaveImage.tintColor = buttonCol
        CancelImage.tintColor = buttonCol
        ClearText.setTitleColor(buttonCol.darker(by: 30), for: UIControlState.normal)
        DefText.setTitleColor(buttonCol.darker(by: 30), for: UIControlState.normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddImageMode = presentingViewController is UINavigationController
        if isPresentingInAddImageMode {
            _ = navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ImageViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === SaveImage else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = TextField.text ?? ""
        let photo = photoImageView.image
        let rating = RatingStarz.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        image = Image(name: name, photo: photo, rating: rating)
    }
    
    
    //MARK: Actions
    @IBAction func DefLabelText(_ sender: UIButton) {
        TextField.text = "Picture number \(MyVariables.num)"
        MyVariables.num += 1
        SaveImage.isEnabled = true
    }
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        TextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func ClearText(_ sender: UIButton) {
        TextField.text = nil
        SaveImage.isEnabled = false
        
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        SaveImage.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = TextField.text ?? ""
        SaveImage.isEnabled = !text.isEmpty
    }
    
    // MARK: Autoroate configuration
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
}

