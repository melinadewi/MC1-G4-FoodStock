//
//  FoodCell.swift
//  MC1-G4-FoodStock
//
//  Created by Victor Samuel Cuaca on 04/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var stockLevel: UILabel!
    @IBOutlet weak var colorIndicator: UIView!
    
    var foodModel: FoodModel? {
        didSet {
            // everytime foodModel did set a value, run this code
            cellConfig()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfig() {
        guard let obj = foodModel else { return }   // if foodModel is nil, then return immediately
        
        foodName.text = obj.foodName
        expDate.text = "Exp: \(obj.expDate)"
        stockLevel.text = obj.stockLevel
        
        switch stockLevel.text {
            case "High": colorIndicator.backgroundColor = UIColor.systemGreen
            case "Half": colorIndicator.backgroundColor = UIColor.systemOrange
            case "Low": colorIndicator.backgroundColor = UIColor.systemRed
            default: colorIndicator.backgroundColor = UIColor.systemGray
        }
    }
}
