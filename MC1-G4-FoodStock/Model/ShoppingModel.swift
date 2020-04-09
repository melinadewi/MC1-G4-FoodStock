//
//  ShoppingModel.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 09/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

struct ShoppingModel{
    var itemName: String
}

extension ShoppingModel {
    static func createShopItem() -> [ShoppingModel]{
        return [ShoppingModel(itemName: "Minyak Goreng"),
            ShoppingModel(itemName: "Gula Pasir"),
            ShoppingModel(itemName: "Kopi")
        ]
    }
}
