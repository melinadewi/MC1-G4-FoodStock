//
//  AddItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Alnodi Adnan on 07/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemStockSegmentedControl: UISegmentedControl!
    @IBOutlet weak var itemNotesTextField: UITextField!
    @IBOutlet weak var itemExpiryDateTextField: UITextField!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Variables
    var newItemName = ""
    var newItemStockLevel = ""
    var newItemExpiryDate = ""
    var newItemFoodImage = ""
    var newItemNotes = ""
    
    let expiryDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeImageCircle()
        setupExpiryDatePicker()
        
        itemNameTextField.delegate = self
        itemNotesTextField.delegate = self
        
        //Move view up when keyboard appear
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemVC.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddItemVC.keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //Hide keyboard when an area is tapped
        hideKeyboardWhenTapped()
    }
    
    //MARK: Functions
    
    func makeImageCircle(){
        itemImageView.layer.borderWidth = 1
        itemImageView.layer.masksToBounds = false
        itemImageView.layer.borderColor = UIColor.black.cgColor
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
    }
    
    @objc func dismissDatePicker(){
        view.endEditing(true)
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
    
    //Move view up when keyboard appear
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    //Hide keyboard when an area is tapped
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "New Item Info", message: "Name: \(newItemName)\nStock: \(newItemStockLevel)\nExp Date: \(newItemExpiryDate)\nNotes: \(newItemNotes)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    
    //MARK: Actions
    
    @IBAction func itemStock_Action(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            newItemStockLevel = "Empty"
        case 1:
            newItemStockLevel = "Low"
        case 2:
            newItemStockLevel = "Half"
        case 3:
            newItemStockLevel = "Plenty"
        default:
            newItemStockLevel = "Nothing chosen"
        }
        print(newItemStockLevel)
    }
    
    @IBAction func backButton_Action(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
        return true
    }
}
