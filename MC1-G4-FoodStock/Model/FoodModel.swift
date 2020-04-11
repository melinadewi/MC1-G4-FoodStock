//
//  FoodModel.swift
//  MC1-G4-FoodStock
//
//  Created by Victor Samuel Cuaca on 04/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

enum StockLevel: Int {
    case empty = 0
    case low = 1
    case half = 2
    case plenty = 3
}

class FoodModel: NSObject {
    
    var foodName = ""
    var expDate: Date
    var stockLevel:StockLevel
    var foodImage: UIImage?
    var id = ""
    var updatedDate: Date
    var itemNote: String?
    
    init(foodName: String, expDate: Date, stockLevel: StockLevel, foodImage: UIImage?, id: String = UUID().uuidString, updatedDate: Date = Date(), itemNote: String? = "") {
        self.foodName = foodName
        self.expDate = expDate
        self.stockLevel = stockLevel
        self.foodImage = foodImage
        self.id = id
        self.updatedDate = updatedDate
        self.itemNote = itemNote
    }
}
