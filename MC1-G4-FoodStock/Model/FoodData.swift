//
//  FoodData.swift
//  MC1-G4-FoodStock
//
//  Created by Agnes Felicia on 12/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import Foundation

class FoodData {
    
    var listOfFoods = [FoodModel]()
    
    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(abbreviation: "PST")
        
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: formatter.date(from: "24-06-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .empty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: formatter.date(from: "14-08-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Ovomaltine", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Nutella", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Bread", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Oreo", expDate: formatter.date(from: "14-08-2020")!, stockLevel: .empty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Dragon Fruit", expDate: formatter.date(from: "08-04-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Watermelon", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Milk", expDate: formatter.date(from: "13-12-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Eggs", expDate: formatter.date(from: "13-08-2020")!, stockLevel: .empty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Tofu", expDate: formatter.date(from: "24-12-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Spaghetti", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Cheese", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
        listOfFoods.append(FoodModel(foodName: "Tomatoes", expDate: formatter.date(from: "14-05-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
        
    }
    
    
}
