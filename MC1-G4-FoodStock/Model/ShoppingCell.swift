//
//  ShoppingCell.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 08/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell{
    
    @IBOutlet weak var shopItemLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shopItemLabel.text = nil
    }
    
    func configureTheCell(shopItem : ShoppingModel){
        shopItemLabel.text = shopItem.itemName
    }
    
}
