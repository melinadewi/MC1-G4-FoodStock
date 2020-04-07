//
//  ViewController.swift
//  MC1-G4-FoodStock
//
//  Created by Melina Dewi on 03/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class FoodStockVC: UIViewController {
    
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
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        let searchController = UISearchController(searchResultsController: nil)
        
        // adding the search controller to the nav bar
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = addButton
    }
    
    func populateList() {
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: "24-06-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: "04-06-2020", stockLevel: "Empty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: "14-08-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: "24-06-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: "04-06-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: "14-08-2020", stockLevel: "Empty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: "24-06-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: "04-06-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: "14-08-2020", stockLevel: "Empty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: "24-06-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: "04-06-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: "14-08-2020", stockLevel: "Half", foodImage: nil))
    }
    
    
    @IBAction func didTapSort(_ sender: UIButton) {
        // do something when sort button is tapped
        print("Sort button did tap")
    }
    
    @objc func addFood() {
        // do something when add button is tapped
        print("Add button did tap")
    }
    
}

extension FoodStockVC: UITableViewDataSource, UITableViewDelegate {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfFoods.count
    }
    
    // set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodCell, for: indexPath) as! FoodCell
        
        cell.foodModel = listOfFoods[indexPath.row]     // sets foodModel variable in FoodCell, this will trigger didSet in FoodCell
        
        return cell
    }
    
    // configure swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("Deleting row")
            
            // delete data from array
            self.listOfFoods.remove(at: indexPath.row)
            
            // delete data from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        let addToList = UIContextualAction(style: .normal, title: "Add to List") { (action, view, nil) in
            print("Adding to list")
        }
        addToList.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete, addToList])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1 // (space u want to give between header and first row)
        }
        
        return 0
    }
}
