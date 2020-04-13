//
//  EditItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Melina Dewi on 10/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

let notificationKey = "com.mc1-g4-foodstock.notificationKey"

class EditItemVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var stockSC: UISegmentedControl!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    let expiryDatePicker = UIDatePicker() // date picker for expiry date
    let imagePicker = UIImagePickerController() // image picker to choose image
    var stockLevel: StockLevel? // variable for stock level
    var expiryDate: Date? // to keep real expiry date in date type
    
    // Get these from ItemDetail
    var selectedItem: FoodModel?
    // UserDefault Model
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupExpiryDatePicker()
        // image picker
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        makeImageCircle()

        hideKeyboardWhenTapped() // improve hide keyboard
        populateItem(item: selectedItem!) // populate selected item
    }
    
    func populateItem(item: FoodModel) {
        itemNameField.text = item.foodName
        notesField.text = item.itemNote

//        imageView.image = item.foodImage
        // UserDefault Model
        imageView.image = selectedImage
        
        expiryDate = item.expDate
        expDateField.text = dateFieldFormatter(date: expiryDate!)
        
        stockLevel = item.stockLevel
        switch item.stockLevel {
        case .empty:
            stockSC.selectedSegmentIndex = 0
            stockSC.selectedSegmentTintColor = UIColor.systemGray4
        case .low:
            stockSC.selectedSegmentIndex = 1
            stockSC.selectedSegmentTintColor = UIColor.systemRed
        case .half:
            stockSC.selectedSegmentIndex = 2
            stockSC.selectedSegmentTintColor = UIColor.systemOrange
        case .plenty:
            stockSC.selectedSegmentIndex = 3
            stockSC.selectedSegmentTintColor = UIColor.systemGreen
        }
    }
    
    // date formatter for date text field
    func dateFieldFormatter(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    // make image circle
    func makeImageCircle() {
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
    
    // override titleForHeaderInSection to get last edited at
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = dateEditedFormat(date: selectedItem!.updatedDate)
        switch section {
            case 0:
                return ""
            case 1:
                return "Item Name"
            case 2:
                return "Stock"
            case 3:
                return "Expiration Date"
            case 4:
                return "Notes"
            case 5:
                return "Last Edited at \(date)"
            default:
                return nil
        }
    }
    
    // date formatter for last edite
    func dateEditedFormat(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    // date picker
    func setupExpiryDatePicker(){
        expiryDatePicker.datePickerMode = .date
        expiryDatePicker.minimumDate = Date()
        expiryDatePicker.addTarget(self, action: #selector(datePickerChanger), for: .valueChanged)
        expDateField.inputView = expiryDatePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissDatePicker))
        
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        expDateField.inputAccessoryView = toolbar
    }
    
    // function when date picker's value changed
    @objc func datePickerChanger(sender : UIDatePicker) {
        expiryDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        expDateField.text = dateFormatter.string(from: sender.date)
    }

    @objc func dismissDatePicker(){
        view.endEditing(true)
    }
    
    // action for choose photo button -> show alert
    @IBAction func choosePhoto(_ sender: Any) {
//        NSLayoutConstraint.deactivate(view.constraints)
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(button) in
//            self.imagePicker.sourceType = .photoLibrary
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }))
//
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(button) in
//            self.imagePicker.sourceType = .camera
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        present(alert, animated: true, completion: nil)
        
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    // change image view with picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // done button action -> send notification to FoodStock and ItemDetail
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
//        let editedItem = FoodModel(foodName: itemNameField.text!, expDate: expiryDate!, stockLevel: stockLevel!, foodImage: imageView.image, id: selectedItem!.id, updatedDate: Date(), itemNote: notesField.text)
        // UserDefault Model
        let editedItem = FoodModel(foodName: itemNameField.text!, expDate: expiryDate!, stockLevel: stockLevel!, foodImage: selectedItem!.foodImage, id: selectedItem!.id, updatedDate: Date(), itemNote: notesField.text)
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil, userInfo: ["editedItem": editedItem])
        // Notification for UserDefault Model
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil, userInfo: ["editedItem": editedItem, "editedImage": imageView.image!])
        
        NotificationCenter.default.removeObserver(self)
        
        dismiss(animated: true, completion: nil)
    }
    
    // cancel button action
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // stock action to update stock level
    @IBAction func stockAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            stockLevel = .empty
            stockSC.selectedSegmentTintColor = UIColor.systemGray4
        case 1:
            stockLevel = .low
            stockSC.selectedSegmentTintColor = UIColor.systemRed
        case 2:
            stockLevel = .half
            stockSC.selectedSegmentTintColor = UIColor.systemOrange
        case 3:
            stockLevel = .plenty
            stockSC.selectedSegmentTintColor = UIColor.systemGreen
        default:
            stockLevel = .plenty
            stockSC.selectedSegmentTintColor = UIColor.systemGreen
        }
    }
}
