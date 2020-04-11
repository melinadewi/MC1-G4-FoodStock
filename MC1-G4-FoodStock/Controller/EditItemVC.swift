//
//  EditItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Melina Dewi on 10/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class EditItemVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var stockSC: UISegmentedControl!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    let expiryDatePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    var itemName = ""
    var stockLevel = ""
    var expiryDate = ""
    var newItemNotes = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setupExpiryDatePicker()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        makeImageCircle()
        hideKeyboardWhenTapped()
    }
    
    func makeImageCircle(){
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
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
    
    @IBAction func choosePhoto(_ sender: Any) {
        NSLayoutConstraint.deactivate(view.constraints)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(button) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(button) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageView.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    private func store(image: UIImage, forKey key: String) {
        if let newImg = image.jpegData(compressionQuality: 1.0) {
                UserDefaults.standard.set(newImg, forKey: key)
        }
    }
    
    @objc
    private func save(key: String) {
        if let newImg = UIImage(named: key) {
            DispatchQueue.global(qos: .background).async {
                self.store(image: newImg, forKey: key)
            }
        }
    }
    
    func hideKeyboardWhenTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        if let txt = itemNameField.text {
            itemName = txt
        }
        save(key: itemName)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func itemStock_Action(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//            case 0:
//                stockSC = "Empty"
//            case 1:
//                stockSC = "Low"
//            case 2:
//                stockSC = "Half"
//            case 3:
//                stockSC = "Plenty"
//            default:
//                stockSC = "Nothing chosen"
//        }
//    }
}
