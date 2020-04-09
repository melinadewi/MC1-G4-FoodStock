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
    @IBOutlet weak var stockCondition: UILabel!
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var notesBox: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    func setUpNavBar() {
        // create edit and delete button
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        let deleteButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

