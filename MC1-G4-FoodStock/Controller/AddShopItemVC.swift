//
//  AddShopItemVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 10/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

protocol AddShopItemVCDelegate: class {
    func addToList(newModel : FoodModel)
}

class AddShopItemVC: UIViewController {

    
    @IBOutlet weak var addShopItemTextField: UITextField!
    
    var delegate : AddShopItemVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        if addShopItemTextField.text != "" {
            let id = UUID().uuidString
            let newFood = FoodModel(foodName: addShopItemTextField.text!, expDate: Date(), stockLevel: .empty, id: id )            //Send the new model to the list page
               delegate?.addToList(newModel: newFood)
               navigationController?.popViewController(animated: true)
           }
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

}
