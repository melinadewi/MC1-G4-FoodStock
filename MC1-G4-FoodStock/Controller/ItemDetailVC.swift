//
//  ItemDetailVC.swift
//  MC1-G4-FoodStock
//
//  Created by Agnes Felicia on 08/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

protocol ItemDetailVCDelegate: class {
    func deleteItem(id: String)
}

class ItemDetailVC: UITableViewController {
    
    @IBOutlet weak var itemImage: UIImageView! {
        didSet {
            //itemImage.layer.borderWidth = 1
            itemImage.layer.masksToBounds = false
            //itemImage.layer.borderColor = UIColor.black.cgColor
            itemImage.layer.cornerRadius = itemImage.frame.height / 2
            itemImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var stockCondition: UILabel! {
        didSet {
            stockCondition.layer.cornerRadius = 8
            stockCondition.layer.masksToBounds = true
       //     stockCondition.layer.borderColor = UIColor.systemGray.cgColor
       //     stockCondition.layer.borderWidth = 2.0
        }
    }
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var notesBox: UITextView! {
        didSet {
            notesBox.layer.cornerRadius = 8
            notesBox.layer.masksToBounds = true
            notesBox.layer.borderColor = UIColor.lightGray.cgColor
            notesBox.layer.borderWidth = 1.0
        }
    }
    
    var selectedItem: FoodModel?
    
    weak var delegate: ItemDetailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true

        populateDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChanges(notification:)), name: NSNotification.Name(rawValue: notificationKey), object: nil)
    }
    
    @objc func updateChanges(notification: Notification) {
        guard let changes = notification.userInfo!["editedItem"] as? FoodModel else { return } // if let
    
        itemName.text = changes.foodName
        expDate.text = dateFormat(date: changes.expDate)
//        itemImage.image = changes.foodImage
        
        // UserDefault Model
        guard let changesImage = notification.userInfo!["editedImage"] as? UIImage else { return } // if let
//        display(key: changes.foodImage) // kalau display, harus lebih cepat dari save gambar di FoodStock
        itemImage.image = changesImage
        
        stockCategory(item: changes)
        notesBox.text = "\(changes.itemNote ?? "")"
//        stockCondition.text = "\(changes.stockLevel)"
        
        selectedItem = changes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        print(NotificationCenter.default.self)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpNavBar() {
        // create edit and delete button
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editItem))
        let deleteButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItem))
        
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    
    // to format date into intended string
    func dateFormat(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    // populate the item data
    func populateDetail() {
        itemName.text = selectedItem?.foodName
        
        if let date = selectedItem?.expDate {
            expDate.text = dateFormat(date: date)
        }
        
        // stock level color
        stockCategory(item: selectedItem!)
//        itemImage.image = selectedItem?.foodImage
        // display image for UserDefault Model
        display(key: selectedItem!.foodImage)
        notesBox.text = selectedItem?.itemNote

    }
    
    func stockCategory(item: FoodModel){
        // stock level color
        switch item.stockLevel {
        case .plenty:
            stockCondition.backgroundColor = UIColor.systemGreen
            stockCondition.text = "Plenty"
        case .half:
            stockCondition.backgroundColor = UIColor.systemOrange
            stockCondition.text = "Half"
        case .low:
            stockCondition.backgroundColor = UIColor.systemRed
            stockCondition.text = "Low"
        default:
            stockCondition.backgroundColor = UIColor.systemGray
            stockCondition.text = "Empty"
        }
    }
    
    // update "created at" in table view
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return ""
        case 1:
            return "Stock"
        case 2:
            return "Expiration Date"
        case 3:
            return "Notes"
        case 4:
            guard let date = selectedItem?.updatedDate else {
                return nil
            }
            return "Last Edited at \(dateFormat(date: date))"
        default:
            return nil
        }
    }
    
    // go to edit vc when edit button tapped
    @objc func editItem() {
        performSegue(withIdentifier: "toEditItem", sender: self)
    }
    
    // delete item when trash button tapped with confirmation
    @objc func deleteItem() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        // yes action
        let yesAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
//            self.performSegue(withIdentifier: "unwindBack", sender: self)
            self.delegate?.deleteItem(id: self.selectedItem!.id)
            self.navigationController?.popViewController(animated: true)        }

        alert.addAction(yesAction)

        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    // pass item id back to FoodStockVC for deletion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindBack" {
            if let destination = segue.destination as? FoodStockVC {
                destination.removeItem = selectedItem?.id
            }
        }
        if segue.identifier == "toEditItem" {
            let nc = segue.destination as? UINavigationController
            let vc = nc?.topViewController as? EditItemVC
            vc?.selectedItem = selectedItem
            // send image for UserDefault Model
            vc?.selectedImage = itemImage.image
        }
    }
    
    // Function to display image for UserDefault Model
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imgData = UserDefaults.standard.object(forKey: key) as? Data, let image = UIImage(data: imgData) {
            return image
        }
        return nil
    }
    
    @objc
    private func display(key: String) {
        DispatchQueue.global(qos: .background).async {
            if let savedImage = self.retrieveImage(forKey: key) {
                DispatchQueue.main.async {
                    self.itemImage.image = savedImage
                }
            }
        }
    }
}

