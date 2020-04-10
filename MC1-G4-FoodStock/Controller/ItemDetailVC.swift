//
//  ItemDetailVC.swift
//  MC1-G4-FoodStock
//
//  Created by Agnes Felicia on 08/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var notesBox: UITextView!
    
    var selectedItem: FoodModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true

        populateDetail()
       
    }
    
    
    func setUpNavBar() {
        // create edit and delete button
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editItem))
        let deleteButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItem))
        
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    
    // populate the item data
    func populateDetail() {
        itemName.text = selectedItem?.foodName
        stockCondition.text = selectedItem?.stockLevel
        expDate.text = selectedItem?.expDate
        
        // stock level color
        switch stockCondition.text {
            case "Plenty": stockCondition.backgroundColor = UIColor.systemGreen
            case "Half": stockCondition.backgroundColor = UIColor.systemOrange
            case "Low": stockCondition.backgroundColor = UIColor.systemRed
            default: stockCondition.backgroundColor = UIColor.systemGray
        }

    }
    
    
    // go to edit vc when edit button tapped
    @objc func editItem() {
       // performSegue(withIdentifier: "", sender: self)
    }
    
    // delete item when trash button tapped with confirmation
    @objc func deleteItem() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.performSegue(withIdentifier: "unwindBack", sender: self)
            print("delete")
        }

        alert.addAction(yesAction)

        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    // pass item id back to FoodStockVC for deletion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FoodStockVC {
            destination.removeItem = selectedItem?.id
        } 
    }

}

