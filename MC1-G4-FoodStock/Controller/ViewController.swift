//
//  ViewController.swift
//  MC1-G4-FoodStock
//
//  Created by Melina Dewi on 03/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let foodCell = "FoodCell"   // cell identifier
    
    var listOfFoods: [FoodModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpNavBar()
        populateList()
    }
    
    func setUpNavBar() {
        // creates a search controller and add button
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let searchController = UISearchController(searchResultsController: nil)
        
        // adding the search controller to the nav bar
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = addButton
    }
    
    func populateList() {
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: "24-06-2020", stockLevel: "High", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: "04-06-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: "14-08-2020", stockLevel: "Half", foodImage: nil))
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodCell, for: indexPath) as! FoodCell
        
        cell.foodModel = listOfFoods[indexPath.row]     // sets foodModel variable in FoodCell, this will trigger didSet in FoodCell
        
        return cell
    }
}
