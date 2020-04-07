//
//  FoodModel.swift
//  MC1-G4-FoodStock
//
//  Created by Victor Samuel Cuaca on 04/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class FoodModel: NSObject {
    var foodName = ""
    var expDate = ""
    var stockLevel = ""
    var foodImage: UIImage?
    
    init(foodName: String, expDate: String, stockLevel: String, foodImage: UIImage?) {
        self.foodName = foodName
        self.expDate = expDate
        self.stockLevel = stockLevel
        self.foodImage = foodImage
    }
}