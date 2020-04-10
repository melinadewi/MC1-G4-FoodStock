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
    @IBOutlet weak var sortButton: UIButton!
    
    let foodCell = "FoodCell"   // cell identifier
    
    var listOfFoods: [FoodModel] = []       // food data
    var filteredFoods: [FoodModel] = []     // this will hold the foods that the user searches for
    
    var isFiltering: Bool = false   // bool to determine wether it is filtering or not
    
    var selectedSort: String = ""
    
    var removeItem: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpNavBar()
        populateList()
        
        tableView.tableFooterView = UIView()    // remove empty cell separator
    }
    
    func setUpNavBar() {
        // create add button
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        
        // create search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self    // this will inform this class of any text changes within the UISearchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search foods"
        
        // adding the search controller to the nav bar
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = addButton
        
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func populateList() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(abbreviation: "PST")
        
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: formatter.date(from: "24-06-2020")!, stockLevel: .plenty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Orange", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .empty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Peach", expDate: formatter.date(from: "14-08-2020")!, stockLevel: .half, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Ovomaltine", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .plenty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Nutella", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Bread", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .half, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Oreo", expDate: formatter.date(from: "14-08-2020")!, stockLevel: .empty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Dragon Fruit", expDate: formatter.date(from: "08-04-2020")!, stockLevel: .plenty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Watermelon", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Milk", expDate: formatter.date(from: "13-12-2020")!, stockLevel: .half, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Eggs", expDate: formatter.date(from: "13-08-2020")!, stockLevel: .empty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Tofu", expDate: formatter.date(from: "24-12-2020")!, stockLevel: .plenty, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Spaghetti", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Cheese", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .low, foodImage: nil))
        listOfFoods.append(FoodModel(foodName: "Tomatoes", expDate: formatter.date(from: "14-05-2020")!, stockLevel: .half, foodImage: nil))

    }
    
    // sort button tapped
    @IBAction func didTapSort(_ sender: UIButton) {
        // do something when sort button is tapped
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let dateEdited = UIAlertAction(title: "Default (Date Edited)", style: .default) { (action) in
            // implement code
            self.sortButton.setTitle("Sort by Date Edited (Default) ", for: .normal)
            
            self.selectedSort = "dateEdited"
        }
        
        let lowestStock = UIAlertAction(title: "Lowest Stock", style: .default) { (action) in
            // implement code
            self.sortButton.setTitle("Sort by Lowest Stock ", for: .normal)
            
            self.selectedSort = "lowestStock"

            self.filteredFoods.sort(by: { $0.stockLevel.rawValue < $1.stockLevel.rawValue })
            self.listOfFoods.sort(by: { $0.stockLevel.rawValue < $1.stockLevel.rawValue })

            self.tableView.reloadData()
        }
        
        let expDate = UIAlertAction(title: "Expiration Date", style: .default) { (action) in
            // implement code
            self.sortButton.setTitle("Sort by Expiration Date ", for: .normal)
            
            self.selectedSort = "expDate"
            
            self.filteredFoods.sort(by: { $0.expDate < $1.expDate })
            self.listOfFoods.sort(by: { $0.expDate < $1.expDate })
            
            self.tableView.reloadData()
        }
        
        switch selectedSort {
        case "dateEdited":
            dateEdited.setValue(true, forKey: "checked")
        case "lowestStock":
            lowestStock.setValue(true, forKey: "checked")
        case "expDate":
            expDate.setValue(true, forKey: "checked")
        default:
            dateEdited.setValue(true, forKey: "checked")
        }
        
        actionSheet.addAction(dateEdited)
        actionSheet.addAction(lowestStock)
        actionSheet.addAction(expDate)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
        // silence the constraint alert warnings. possible bug in iOS(?)
        actionSheet.view.subviews.flatMap({$0.constraints}).filter{ (one: NSLayoutConstraint) -> (Bool)  in
           return (one.constant < 0) && (one.secondItem == nil) && (one.firstAttribute == .width)
        }.first?.isActive = false
    }
    
    @objc func addFood() {
        // do something when add button is tapped
        //performSegue(withIdentifier: "toAddItem", sender: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = TimeZone(abbreviation: "PST")
        
        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: formatter.date(from: "24-06-2020")!, stockLevel: .plenty, foodImage: nil))
        tableView.reloadData()
    }
    
    func filterContent(searchText: String) {
        filteredFoods = listOfFoods.filter { (food: FoodModel) -> Bool in       // loops over all the element and calls the closure.
            return food.foodName.lowercased().contains(searchText.lowercased())     // return true if foodname contains searched text
        }
    }
}

extension FoodStockVC: UITableViewDataSource, UITableViewDelegate {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {    // if is filtering, return filtered foods count
            return filteredFoods.count
        }
        
        // else return original food count
        return listOfFoods.count
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering && filteredFoods.count == 0 {    // if search not found
            setMessage(message: "No Result")
            return 0
        }
        
        if listOfFoods.count == 0 {
            setMessage(message: "Food stocks is empty")
            navigationItem.largeTitleDisplayMode = .never
            tableView.isUserInteractionEnabled = false
            sortButton.isHidden = false
            sortButton.isEnabled = false
            sortButton.tintColor = .lightGray
            sortButton.setTitleColor(.lightGray, for: .disabled)
            return 1
        }
        
        restore()   // else restore
        return 1
    }
    
    // set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodCell, for: indexPath) as! FoodCell
        
        if isFiltering {
            cell.foodModel = filteredFoods[indexPath.row]   // if is filtering, set cell using filtered foods else use the original data
        } else {
            cell.foodModel = listOfFoods[indexPath.row]     // sets foodModel variable in FoodCell, this will trigger didSet in FoodCell
        }
        
        return cell
    }
    
    // did tap cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItemDetail", sender: self)
    }
    
    // pass cell data to ItemDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemDetailVC {
            if isFiltering {
                destination.selectedItem = filteredFoods[tableView.indexPathForSelectedRow!.row]
            } else {
                destination.selectedItem = listOfFoods[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    // unwind back from ItemDetailVC after delete
    @IBAction func unwindBackToFoodStock(sender: UIStoryboardSegue)
    {
        // find the index of the item deleted from ItemDetailVC
        if let itemIndex = listOfFoods.firstIndex(where: {$0.id == removeItem}) {
            listOfFoods.remove(at: itemIndex)
        }
        
        // reload tableview
        tableView.reloadData()
        
    }
    
    // configure swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            
            if self.isFiltering {
                let foodId = self.filteredFoods[indexPath.row].id   // get the food id
                
                if let index = self.listOfFoods.firstIndex(where: { $0.id == foodId } ) { // get the index from the original list
                    self.listOfFoods.remove(at: index)  // remove food from original list
                }
                
                self.filteredFoods.remove(at: indexPath.row)    // remove food from filtered list
            } else {
                self.listOfFoods.remove(at: indexPath.row)      // if not filtering then remove from original array
            }
            
            // delete data from table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let addToList = UIContextualAction(style: .normal, title: "Add to List") { (action, view, nil) in
            print("Adding to \(self.listOfFoods[indexPath.row].foodName) list")
        }
        addToList.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete, addToList])
    }
    
    // called everytime user starts scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.resignFirstResponder()       // close keyboard when scrolling
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1 // (space u want to give between header and first row)
        }
        
        return 0
    }
}

extension FoodStockVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {    // gets called everytime searchbar text changed
        // do something
        let searchBar = searchController.searchBar
        
        if let text = searchBar.text {      // check if search bar text is not nil
            if text != "" {     // if search bar text is NOT EMPTY, do this
                isFiltering = true
                filterContent(searchText: text)
            } else {        // else (EMPTY) do this
                isFiltering = false
            }
        }
        
        // reload tableview data
        tableView.reloadData()
    }
}

extension FoodStockVC {
    func setMessage(message: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center;

        tableView.backgroundView = messageLabel;
        sortButton.isHidden = true
    }
    
    func restore() {
        tableView.backgroundView = nil
        tableView.isUserInteractionEnabled = true
        sortButton.isHidden = false
        sortButton.isEnabled = true
        sortButton.tintColor = .systemBlue
        
        navigationItem.largeTitleDisplayMode = .automatic
    }
}
