//
//  AddShopItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 10/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

protocol AddItem {
    func addItem(itemName: String)
}

class AddShopItemVC: UIViewController {

    @IBOutlet weak var addItem: UIButton!
    
    @IBAction func addAction(_ sender: Any) {
        if addShopItemTextField.text != "" {
            delegate?.addItem(itemName: addShopItemTextField.text!)
            navigationController?.popViewController(animated: true)
            print("add")
        }
    }
    
    @IBOutlet weak var addShopItemTextField: UITextField!
    
    var delegate: AddItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
