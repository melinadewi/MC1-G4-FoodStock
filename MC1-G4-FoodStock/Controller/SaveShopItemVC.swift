//
//  SaveShopItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 11/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

let passNotifKey = "bebas"

protocol SaveShopItemVCDelegate: class {
    func saveToStock(editItem: FoodModel)
}

class SaveShopItemVC: UITableViewController {
    
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemStock: UISegmentedControl!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    var selectedItem: FoodModel?
    var stockLevel: StockLevel?
    var expiryDate: Date?
    let expiryDatePicker = UIDatePicker()
    
    var delegate: SaveShopItemVCDelegate? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
        setupExpiryDatePicker()
        hideKeyboardWhenTapped()
    }
    
    
    

    // MARK: - Table view data source
    
    
    
    func populateData() {
        itemNameField.text = selectedItem?.foodName
//        expDateField.text = dateFieldFormatter(date: expiryDate!)
        expDateField.text = dateFieldFormatter(date: (selectedItem?.expDate)!)
        notesField.text = selectedItem?.itemNote
    }
    
    func dateFieldFormatter(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }
    
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
    
    @objc func datePickerChanger(sender : UIDatePicker) {
        expiryDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        expDateField.text = dateFormatter.string(from: sender.date)
    }

    @objc func dismissDatePicker(){
        view.endEditing(true)
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
    
    
    @IBAction func updateStock(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            stockLevel = .empty
            itemStock.selectedSegmentTintColor = UIColor.systemGray4
        case 1:
            stockLevel = .low
            itemStock.selectedSegmentTintColor = UIColor.systemRed
        case 2:
            stockLevel = .half
            itemStock.selectedSegmentTintColor = UIColor.systemOrange
        case 3:
            stockLevel = .plenty
            itemStock.selectedSegmentTintColor = UIColor.systemGreen
        default:
            stockLevel = .plenty
            itemStock.selectedSegmentTintColor = UIColor.systemGreen
        }
    }
    

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        let editItem = FoodModel(foodName: itemNameField.text!, expDate: expiryDate!, stockLevel: stockLevel!, foodImage: selectedItem!.foodImage, id: selectedItem!.id, updatedDate: Date(), itemNote: selectedItem?.itemNote)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: passNotifKey), object: nil, userInfo: ["newEdited": editItem])
        NotificationCenter.default.removeObserver(self)
        
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil, userInfo: ["editedItem": editedItem])
                // Notification for UserDefault Model
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationKey), object: nil, userInfo: ["editedItem": editedItem, "editedImage": imageView.image!])
//                
//                NotificationCenter.default.removeObserver(self)
        delegate?.saveToStock(editItem: editItem)
        dismiss(animated: true, completion: nil)

    }
    
    
    
    
    

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
