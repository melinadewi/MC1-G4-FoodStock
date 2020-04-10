//
//  EditItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Melina Dewi on 10/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class EditItemVC: UITableViewController {
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var stockSC: UISegmentedControl!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    let expiryDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupExpiryDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = ""
            case 1:
            sectionName =  NSLocalizedString("Item Name", comment: "item name")
            case 2:
            sectionName =  NSLocalizedString("Stock", comment: "stock")
            case 3:
            sectionName =  NSLocalizedString("Expiration Date", comment: "expiration date")
            case 4:
            sectionName =  NSLocalizedString("Notes", comment: "notes")
            case 5:
            sectionName =  NSLocalizedString("Updated at \(Date())", comment: "updated at")
            default:
                sectionName = ""
        }
        return sectionName
    }
    
    func setupExpiryDatePicker(){
        expiryDatePicker.datePickerMode = .date
        expiryDatePicker.minimumDate = Date()
        expiryDatePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        expDateField.inputView = expiryDatePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDatePicker))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        expDateField.inputAccessoryView = toolbar
    }
    
    @objc func datePickerValueChanged(sender : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        expDateField.text = dateFormatter.string(from: sender.date)
    }

    @objc func dismissDatePicker(){
        view.endEditing(true)
    }
}
