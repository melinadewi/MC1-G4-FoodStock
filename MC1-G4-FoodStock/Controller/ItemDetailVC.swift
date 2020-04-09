//
//  ItemDetailVC.swift
//  MC1-G4-FoodStock
//
//  Created by Agnes Felicia on 08/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ItemDetailVC: UIViewController {
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var itemImage: UIImageView! {
        didSet {
            itemImage.layer.borderWidth = 1
            itemImage.layer.masksToBounds = false
            itemImage.layer.borderColor = UIColor.black.cgColor
            itemImage.layer.cornerRadius = itemImage.frame.height / 2
            itemImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var stockCondition: UIButton! {
        didSet {
            stockCondition.layer.cornerRadius = 5.0
            stockCondition.backgroundColor = .systemGray
            stockCondition.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesBox: UITextView!
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.layer.cornerRadius = 5.0
            deleteButton.backgroundColor = .systemRed
            deleteButton.layer.masksToBounds = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

