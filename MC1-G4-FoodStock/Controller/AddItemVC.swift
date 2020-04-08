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
