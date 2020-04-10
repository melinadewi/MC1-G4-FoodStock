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
        
        let date = obj.expDate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let formattedDate = formatter.string(from: date)
        
        foodName.text = obj.foodName
        expDate.text = "Exp: \(formattedDate)"
        
        switch obj.stockLevel {
        case .plenty:
            stockLevel.text = "Plenty"
            colorIndicator.backgroundColor = UIColor.systemGreen
        case .half:
            stockLevel.text = "Half"
            colorIndicator.backgroundColor = UIColor.systemOrange
        case .low:
            stockLevel.text = "Low"
            colorIndicator.backgroundColor = UIColor.systemRed
        case .empty:
            stockLevel.text = "Empty"
            colorIndicator.backgroundColor = UIColor.systemGray
        }
    }
}
