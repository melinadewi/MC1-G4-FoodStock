//
//  AddItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Alnodi Adnan on 07/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

//Used as the medium to pass data back to FoodStockVC
protocol AddItemVCDelegate {
    func addToList(newModel : FoodModel)
}

class AddItemVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: Outlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemStockSegmentedControl: UISegmentedControl!
    @IBOutlet weak var itemNotesTextField: UITextField!
    @IBOutlet weak var itemExpiryDateTextField: UITextField!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
//    var delegate: AddItemVCDelegate?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func save() {
//        //create model
//
//        // save
//        delegate?.addToList(pesan: "hai delegate")
//    }
    
    //MARK: Variables
    var newItemName = ""
    var newItemStockLevel: StockLevel = .plenty
    var newItemExpiryDate: Date?
    var newItemFoodImage = ""
    var newItemNotes = ""
    
    let expiryDatePicker = UIDatePicker()
    
    var delegate : AddItemVCDelegate?
    
    var itemNameIsFilled = false
    var itemExpiryDateIsFilled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeImageCircle()
        disableDoneButton()
        setupExpiryDatePicker()
        itemStockSegmentedControl.selectedSegmentIndex = 3
        
        itemNameTextField.delegate = self
        itemNotesTextField.delegate = self
        
        //Move view up when keyboard appear
//        NotificationCenter.default.addObserver(self, selector: #selector(AddItemVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(AddItemVC.keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //Hide keyboard when an area is tapped
        hideKeyboardWhenTapped()
    }
    
    //MARK: Functions
    
    func makeImageCircle(){
//        itemImageView.layer.borderWidth = 1
        itemImageView.layer.masksToBounds = false
//        itemImageView.layer.borderColor = UIColor.black.cgColor
        itemImageView.layer.cornerRadius = itemImageView.frame.height / 2
        itemImageView.clipsToBounds = true
    }
    
    func setupExpiryDatePicker(){
        expiryDatePicker.datePickerMode = .date
        expiryDatePicker.minimumDate = Date()
        expiryDatePicker.addTarget(self, action: #selector(AddItemVC.datePickerValueChanged(sender:)), for: .valueChanged)
        itemExpiryDateTextField.inputView = expiryDatePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDatePicker))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        itemExpiryDateTextField.inputAccessoryView = toolbar
    }
    
    @objc func datePickerValueChanged(sender : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        itemExpiryDateTextField.text = dateFormatter.string(from: sender.date)
        newItemExpiryDate = sender.date
        
        if newItemExpiryDate != nil{
            itemExpiryDateIsFilled = true
            checkDoneButtonEligibility()
        }
        
    }
    
    @objc func dismissDatePicker(){
        view.endEditing(true)
    }
    
    //Allow user to choose image from the device photos app
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            itemImageView.image = selectedImage
            print("Image inserted name : \(String(describing: itemImageView.image?.description))")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //Store image after its added from the photos gallery
    func storeImage(image: UIImage, forKey key: String){
        if let pngRepresentation = image.pngData() {
            UserDefaults.standard.set(pngRepresentation, forKey: key)
        }
    }
    
    //Retrieve saved image
    func retrieveImage(forKey key: String) -> UIImage? {
        
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
            let image = UIImage(data: imageData) {
            UserDefaults.standard.removeObject(forKey: key)
            return image
        }
        
        return nil
    }
    
//    //Move view up when keyboard appear
//    @objc func keyboardWillShow(notification: NSNotification) {
////        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
////            return
////        }
////
////        self.view.frame.origin.y = 0 - keyboardSize.height
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        self.view.frame.origin.y = 0
//    }
    
    //Hide keyboard when an area is tapped
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Show an alert
    func showAlert() {
        let alert = UIAlertController(title: "New Item Info", message: "Name: \(newItemName)\nStock: \(String(describing: newItemStockLevel))\nExp Date: \(String(describing: newItemExpiryDate))\nNotes: \(newItemNotes)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkDoneButtonEligibility(){
        if itemNameIsFilled && itemExpiryDateIsFilled {
            enableDoneButton()
        }
    }
    
    func disableDoneButton(){
        doneButton.isEnabled = false
        doneButton.tintColor = .lightGray
    }
    
    func enableDoneButton(){
        doneButton.isEnabled = true
        doneButton.tintColor = .link
    }

    
    //MARK: Actions
    
    @IBAction func itemStock_Action(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            newItemStockLevel = .empty
            itemStockSegmentedControl.selectedSegmentTintColor = UIColor.systemGray4
        case 1:
            newItemStockLevel = .low
            itemStockSegmentedControl.selectedSegmentTintColor = UIColor.systemRed
        case 2:
            newItemStockLevel = .half
            itemStockSegmentedControl.selectedSegmentTintColor = UIColor.systemOrange
        case 3:
            newItemStockLevel = .plenty
            itemStockSegmentedControl.selectedSegmentTintColor = UIColor.systemGreen
        default:
            newItemStockLevel = .plenty
            itemStockSegmentedControl.selectedSegmentTintColor = UIColor.systemGreen
        }
        print(String(describing: newItemStockLevel))
    }
    
    @IBAction func backButton_Action(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneButton_onClick(_ sender: Any) {
        //Make new model that will be sent back to the list page
        let newFood = FoodModel(foodName: newItemName, expDate: newItemExpiryDate!, stockLevel: newItemStockLevel, foodImage: itemImageView.image, id: UUID().uuidString, updatedDate: Date())
        
//        print("--New Food--\nName: \(newFood.foodName)\nStockLevel: \(newFood.stockLevel)\nExpDate: \(newFood.expDate)\nNotes: \(newItemNotes)\n")
        
        //Send the new model to the list page
        delegate?.addToList(newModel: newFood)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addPhotoButton_Click(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension AddItemVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 0 {
            newItemName = textField.text!
            print(newItemName)
        }
        else if textField.tag == 1 {
            newItemNotes = textField.text!
            print("Item notes: \(newItemNotes)")
        }
        
        //Setup for done button eligibility check
        if newItemName != "" {
            itemNameIsFilled = true
        }
        
        checkDoneButtonEligibility()
        
        return true
    }
}
