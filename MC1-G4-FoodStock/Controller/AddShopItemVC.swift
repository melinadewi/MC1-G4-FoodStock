//
//  AddShopItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 10/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class AddShopItemVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    var update: (()-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveAddItems()
        
        return true
    }
    
    @IBAction func saveAddItems(){
        
        //check if the text is empty
        guard let text = field.text, !text.isEmpty else{
            return
        }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        
        //save items, each item will be unique
        UserDefaults().set(text, forKey: "item_\(newCount)")
        
        //if this function exist, call it
        update?()
        
        navigationController?.popViewController(animated: true)
    }
}
