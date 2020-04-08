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
    
    var listOfFoods: [FoodModel] = []       // food data
    var filteredFoods: [FoodModel] = []     // this will hold the foods that the user searches for

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpNavBar()
        populateList()
    }
    
    func setUpNavBar() {
        // create add button
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        
        // create search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self    // this will inform this class of any text changes within the UISearchBar
        searchController.searchBar.placeholder = "Search foods"
        
        // adding the search controller to the nav bar
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = addButton
    }
    
    func populateList() {
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: "24-06-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: "04-06-2020", stockLevel: "Empty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: "14-08-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Ovomaltine", expDate: "21-06-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Nutella", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Bread", expDate: "04-06-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Oreo", expDate: "14-08-2020", stockLevel: "Empty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Dragon Fruit", expDate: "08-04-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Watermelon", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Milk", expDate: "13-12-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Eggs", expDate: "13-08-2020", stockLevel: "Empty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Tofu", expDate: "24-12-2020", stockLevel: "Plenty", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Spaghetti", expDate: "21-06-2020", stockLevel: "Low", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Cheese", expDate: "04-06-2020", stockLevel: "Half", foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Tomatoes", expDate: "14-05-2020", stockLevel: "Half", foodImage: nil))
    }
    
    
    @IBAction func didTapSort(_ sender: UIButton) {
        // do something when sort button is tapped
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let dateEdited = UIAlertAction(title: "Default (Date Edited)", style: .default) { (action) in
            // implement code
            print("Sort by date edited")
        }
        
        let lowestStock = UIAlertAction(title: "Lowest Stock", style: .default) { (action) in
            // implement code
            print("Sort by lowest stock")
        }
        
        actionSheet.addAction(dateEdited)
        actionSheet.addAction(lowestStock)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
        // silence the constraint alert warnings. possible bug in iOS(?)
        actionSheet.view.subviews.flatMap({$0.constraints}).filter{ (one: NSLayoutConstraint) -> (Bool)  in
           return (one.constant < 0) && (one.secondItem == nil) && (one.firstAttribute == .width)
        }.first?.isActive = false
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
    
    // did tap cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // do something
        print("\(listOfFoods[indexPath.row].foodName) selected!")
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

extension FoodStockVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // do something
    }
}
