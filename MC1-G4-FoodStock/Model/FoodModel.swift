//
//  FoodModel.swift
//  MC1-G4-FoodStock
//
//  Created by Victor Samuel Cuaca on 04/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

//enum StockLevel: Int {
//    case empty = 0
//    case low = 1
//    case half = 2
//    case plenty = 3
//}
//
//class FoodModel: NSObject {
//
//    var foodName = ""
//    var expDate: Date
//    var stockLevel:StockLevel
//    var foodImage: UIImage?
//    var id = ""
//    var updatedDate: Date
//    var itemNote: String?
//
//    init(foodName: String, expDate: Date, stockLevel: StockLevel, foodImage: UIImage?, id: String = UUID().uuidString, updatedDate: Date = Date(), itemNote: String? = "") {
//        self.foodName = foodName
//        self.expDate = expDate
//        self.stockLevel = stockLevel
//        self.foodImage = foodImage
//        self.id = id
//        self.updatedDate = updatedDate
//        self.itemNote = itemNote
//    }
//}



// UserDefault Model
enum StockLevel: Int, Codable {
    case empty = 0
    case low = 1
    case half = 2
    case plenty = 3
}

class FoodModel: Codable {
    
    var foodName = ""
    var expDate: Date
    var stockLevel:StockLevel
    var foodImage: String
    var id = ""
    var updatedDate: Date
    var itemNote: String?
    var isInShoppingList: Bool = false
    var isInFoodStock: Bool = false
    
    init(foodName: String, expDate: Date, stockLevel: StockLevel, foodImage: String = "", id: String = UUID().uuidString, updatedDate: Date = Date(), itemNote: String? = "", isInShoppingList: Bool = false, isInFoodStock: Bool = false) {
        self.foodName = foodName
        self.expDate = expDate
        self.stockLevel = stockLevel
        self.foodImage = foodImage
        self.id = id
        self.updatedDate = updatedDate
        self.itemNote = itemNote
        self.isInShoppingList = isInShoppingList
        self.isInFoodStock = isInFoodStock
    }
}

class Keys: Codable {
    var keys: [String]
}
