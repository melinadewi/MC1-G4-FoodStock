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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var addButton: UIBarButtonItem? = nil
    
    let foodCell = "FoodCell"   // cell identifier
    
    var listOfFoods: [FoodModel] = []       // food data
    // Add new variable for UserDefault Model
    var listOfKeys: [String] = []
    var filteredFoods: [FoodModel] = []     // this will hold the foods that the user searches for
    var listOfShopFoods: [FoodModel] = []   // this will hold the foods that needs to be pushed to shopping list
    
    var isFiltering: Bool = false   // bool to determine wether it is filtering or not
    
    var selectedSort: String = ""
    
    var removeItem: String? = ""
    
    var selectedItems: [Int] = []
    
    var isEnableMultipleSelection: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpNavBar()
        populateList()
        
        tableView.tableFooterView = UIView()    // remove empty cell separator
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tabBarController?.tabBar.isHidden = false
//        let addVC = AddItemVC()
//        addVC.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(editListOfItems(notification:)), name: NSNotification.Name(rawValue: notificationKey), object: nil)
    }
    

    @objc func editListOfItems(notification: Notification) -> Void{
        // do something
        guard let foodItem = notification.userInfo!["editedItem"] as? FoodModel else { return }
        
        // get the id
        let foodId = foodItem.id
        
        // Save data and image for UserDefaultModel
        setData(item: foodItem)
        guard let imageItem = notification.userInfo!["editedImage"] as? UIImage else { return }
        saveImage(key: foodItem.foodImage, image: imageItem)
        
        print(foodId)
        
        if let index = listOfFoods.firstIndex(where: { $0.id == foodId } ) { // get the index from the original list
            listOfFoods[index] = foodItem      // replace food with new edited food
            print(index)
        }
        
//        switch selectedSort {
//        case "dateEdited" :
//            listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
//        case "lowestStock":
//            listOfFoods.sort(by: { $0.stockLevel.rawValue < $1.stockLevel.rawValue })
//        case "expDate":
//            listOfFoods.sort(by: { $0.expDate < $1.expDate })
//        default:
//            listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
//        }
        tableView.reloadData()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        selectedItems.removeAll()       // reset selected item everytime edit tapped
        deleteButton.isEnabled = false  // disable delete button until there is selected item
        
        if !isEnableMultipleSelection { // if not in editing mode do this
            tableView.setEditing(true, animated: true)
            
            navigationController?.toolbar.isHidden = false
            tabBarController?.tabBar.isHidden = true
            
            isEnableMultipleSelection = true
            addButton?.isEnabled = false
            sortButton.isEnabled = false
            sortButton.tintColor = .lightGray
            sortButton.setTitleColor(.lightGray, for: .disabled)
            editButton.title = "Done"
            
            navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
            
        } else {
            tableView.setEditing(false, animated: true)
            
            navigationController?.toolbar.isHidden = true
            tabBarController?.tabBar.isHidden = false
            
            isEnableMultipleSelection = false
            addButton?.isEnabled = true
            sortButton.isEnabled = true
            sortButton.tintColor = .systemBlue
            editButton.title = "Edit"
            
            navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        
        if selectedItems.count != 0 {   // if there is selected item
            
            // show alert
            let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            // yes action
            let yesAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                
                // delete all the selected items from list of foods
                self.listOfFoods = self.listOfFoods.enumerated().filter {!self.selectedItems.contains($0.offset) }.map {$0.element}
                
                
                var indexPath: [IndexPath] = []
                for index in self.selectedItems {
                    indexPath.append(IndexPath(row: index, section: 0))
                }
                
                self.tableView.deleteRows(at: indexPath, with: .left)
                
                // dismis editing
                self.tableView.setEditing(false, animated: true)
                self.editButtonDidTap(self)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.tableView.setEditing(false, animated: true)
                self.editButtonDidTap(self)
            }
            
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func setUpNavBar() {
        // create add button
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        
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
        
//        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: formatter.date(from: "24-06-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Kiwi", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Orange", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .empty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Peach", expDate: formatter.date(from: "14-08-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Ovomaltine", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Nutella", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Bread", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Oreo", expDate: formatter.date(from: "14-08-2020")!, stockLevel: .empty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Dragon Fruit", expDate: formatter.date(from: "08-04-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Watermelon", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Milk", expDate: formatter.date(from: "13-12-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Eggs", expDate: formatter.date(from: "13-08-2020")!, stockLevel: .empty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Tofu", expDate: formatter.date(from: "24-12-2020")!, stockLevel: .plenty, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Spaghetti", expDate: formatter.date(from: "21-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Cheese", expDate: formatter.date(from: "04-06-2020")!, stockLevel: .low, foodImage: nil, itemNote: ""))
//        listOfFoods.append(FoodModel(foodName: "Tomatoes", expDate: formatter.date(from: "14-05-2020")!, stockLevel: .half, foodImage: nil, itemNote: ""))
        
        // UserDefault Model
        if let data = UserDefaults.standard.data(forKey: "allkeys") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let keys = try decoder.decode([String].self, from: data)
                listOfKeys = keys
                print(listOfKeys)
                
                for key in keys {
                    if let data = UserDefaults.standard.data(forKey: key) {
                        do {
                            // Create JSON Decoder
                            let decoder = JSONDecoder()
                            
                            // Decode Note
                            let item = try decoder.decode(FoodModel.self, from: data)
                  //          if item.stockLevel != .empty {               // if stock item is empty, do not append?
                                listOfFoods.append(item)
                   //         }

                        } catch {
                            print("Unable to Decode Notes (\(error))")
                        }
                    }
                }

            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        } else {
            print("No items")
        }

        
        self.listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
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
            
            self.filteredFoods.sort(by: { $0.updatedDate > $1.updatedDate })
            self.listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
            
            self.tableView.reloadData()
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
        performSegue(withIdentifier: "toAddItem", sender: self)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        formatter.timeZone = TimeZone(abbreviation: "PST")
//
//        listOfFoods.append(FoodModel(foodName: "Apple yang sangat enak skali", expDate: formatter.date(from: "24-06-2020")!, stockLevel: .plenty, foodImage: nil))
//        tableView.reloadData()
    }
    
    func filterContent(searchText: String) {
        filteredFoods = listOfFoods.filter { (food: FoodModel) -> Bool in       // loops over all the element and calls the closure.
            return food.foodName.lowercased().contains(searchText.lowercased())     // return true if foodname contains searched text
        }
    }
    
    // Function save image for UserDefault Model
    private func store(image: UIImage, forKey key: String) {
        if let newImg = image.jpegData(compressionQuality: 1.0) {
                UserDefaults.standard.set(newImg, forKey: key)
        }
    }
    
    @objc
    private func saveImage(key: String, image: UIImage) {
        DispatchQueue.global(qos: .background).async {
            self.store(image: image, forKey: key)
        }
    }
}

extension FoodStockVC: UITableViewDataSource, UITableViewDelegate {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listOfFoods.count == 0 {
            sortButton.isEnabled = false
            sortButton.tintColor = .lightGray
            sortButton.setTitleColor(.lightGray, for: .disabled)
        } else {
            editButton.isEnabled = true
        }
        
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
            
            tableView.isUserInteractionEnabled = false
            
            sortButton.isHidden = false
            sortButton.isEnabled = false
            sortButton.tintColor = .lightGray
            sortButton.setTitleColor(.lightGray, for: .disabled)
            
            return 1
        }
        
        if listOfFoods.count == 0 {
            setMessage(message: "Food stocks is empty")
            navigationItem.largeTitleDisplayMode = .never
            
            tableView.isUserInteractionEnabled = false
            
            sortButton.isHidden = false
            sortButton.isEnabled = false
            sortButton.tintColor = .lightGray
            sortButton.setTitleColor(.lightGray, for: .disabled)
            
            editButton.isEnabled = false
            
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
        selectedItems.append(indexPath.row) // append selected row to selected items
        
        // disable or enable delete button
        if selectedItems.count == 0 {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
        
        // if not in editing style, segue to detail VC
        if !isEnableMultipleSelection {
            performSegue(withIdentifier: "toItemDetail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // remove selected item
        selectedItems.remove(at: selectedItems.firstIndex(where: { $0 == indexPath.row })!)
        
        if selectedItems.count == 0 {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
    }
    
    // pass cell data to ItemDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemDetailVC {
            
            destination.delegate = self
            
            if isFiltering {
                destination.selectedItem = filteredFoods[tableView.indexPathForSelectedRow!.row]
            } else {
                destination.selectedItem = listOfFoods[tableView.indexPathForSelectedRow!.row]
            }
        }
        
        if segue.identifier == "toAddItem" {
            let nc = segue.destination as? UINavigationController
            let vc = nc?.topViewController as? AddItemVC
            vc?.delegate = self
        }
    }
    
    // unwind back from ItemDetailVC after trash button pushed
    @IBAction func unwindBackToFoodStock(sender: UIStoryboardSegue)
    {
        // find the index of the item deleted from ItemDetailVC
        if let itemIndex = listOfFoods.firstIndex(where: {$0.id == removeItem}) {
            listOfFoods.remove(at: itemIndex)
            // UserDefault Model
            listOfKeys = listOfKeys.filter { $0 != removeItem }
            setKeys()
            UserDefaults.standard.removeObject(forKey: removeItem!) // delete object in userdefault
            UserDefaults.standard.removeObject(forKey: "\(removeItem!)-img") // delete image in userdefault
            print("dari unwindbacktofoodstock")
        }
        
        // reload tableview
        tableView.reloadData()
        
    }
    
    // configure swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            
            let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            // yes action
            let yesAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                if self.isFiltering {
                    let foodId = self.filteredFoods[indexPath.row].id   // get the food id
                    
                    if let index = self.listOfFoods.firstIndex(where: { $0.id == foodId } ) { // get the index from the original list
                        self.listOfFoods.remove(at: index)  // remove food from original list
                        // UserDefault Model
                        self.listOfKeys = self.listOfKeys.filter { $0 != foodId }
                        self.setKeys()
                        UserDefaults.standard.removeObject(forKey: foodId) // delete object in userdefault
                        UserDefaults.standard.removeObject(forKey: "\(foodId)-img") // delete image in userdefault
                        print("dari yes action isfiltering")
                    }
                    
                    self.filteredFoods.remove(at: indexPath.row)    // remove food from filtered list
                } else {
                    // UserDefault Model
                    let foodId = self.listOfFoods[indexPath.row].id
                    self.listOfKeys = self.listOfKeys.filter { $0 != foodId }
                    self.setKeys()
                    UserDefaults.standard.removeObject(forKey: foodId) // delete object in userdefault
                    UserDefaults.standard.removeObject(forKey: "\(foodId)-img") // delete image in userdefault
                    
                    self.listOfFoods.remove(at: indexPath.row)      // if not filtering then remove from original array
                }
                
                // delete data from table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                // do something
            }
            
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let addToList = UIContextualAction(style: .normal, title: "Add to List") { (action, view, nil) in
            if self.isFiltering {
                print("Adding to \(self.filteredFoods[indexPath.row].foodName) list")
            } else {
                print("Adding to \(self.listOfFoods[indexPath.row].foodName) list")
            }
            
            tableView.setEditing(false, animated: true)
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
        
        // end editing
        tableView.setEditing(false, animated: true)
        isEnableMultipleSelection = false
        addButton?.isEnabled = true
        editButton.title = "Edit"
        
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
    
    // Function tambahan untuk UserDefault Model
    func setKeys() {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(listOfKeys)
            
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "allkeys")
            
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    func setData(item: FoodModel) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(item)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: item.id)

        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
}

//extension FoodStockVC: AddItemVCDelegate {
//    func addToList(pesan: String) {
//        print(pesan)
//    }
//}

extension FoodStockVC: ItemDetailVCDelegate {
    func deleteItem(id: String) {
        if let index = listOfFoods.firstIndex(where: { $0.id == id}) {
            listOfFoods.remove(at: index)
            
            // UserDefault Model
            listOfKeys = listOfKeys.filter { $0 != id }
            setKeys()
            UserDefaults.standard.removeObject(forKey: id) // delete object in userdefault
            UserDefaults.standard.removeObject(forKey: "\(id)-img") // delete image in userdefault
            
            tableView.reloadData()
        }
    }
}

extension FoodStockVC: AddItemVCDelegate {
//    func addToList(newModel: FoodModel) {
//        listOfFoods.append(newModel)
//
//        switch selectedSort {
//        case "dateEdited" :
//            listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
//        case "lowestStock":
//            listOfFoods.sort(by: { $0.stockLevel.rawValue < $1.stockLevel.rawValue })
//        case "expDate":
//            listOfFoods.sort(by: { $0.expDate < $1.expDate })
//        default:
//            listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
//        }
//
//        tableView.reloadData()
//    }
    
    // UserDefault Model
    func addToList(newModel: FoodModel, newImage: UIImage) {
        listOfKeys.append(newModel.id)
        setKeys()
        
        listOfFoods.append(newModel)
        setData(item: newModel)
        saveImage(key: newModel.foodImage, image: newImage)
        
        switch selectedSort {
        case "dateEdited" :
            listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
        case "lowestStock":
            listOfFoods.sort(by: { $0.stockLevel.rawValue < $1.stockLevel.rawValue })
        case "expDate":
            listOfFoods.sort(by: { $0.expDate < $1.expDate })
        default:
            listOfFoods.sort(by: { $0.updatedDate > $1.updatedDate })
        }
        
        tableView.reloadData()
    }
}

//extension FoodStockVC: SaveShopItemVCDelegate {
//    func saveToStock(editItem: FoodModel) {
//        print(editItem.foodName)
//        print(editItem.stockLevel)
//        print(editItem.expDate)
//        
//        // get the id
//        let foodId = editItem.id
//        
//        // Save data and image for UserDefaultModel
//        setData(item: editItem)
////        print(foodId)
//        
//        if let index = listOfFoods.firstIndex(where: { $0.id == foodId } ) { // get the index from the original list
//            listOfFoods[index] = editItem      // replace food with new edited food
////            print(index)
//        }
//        tableView.reloadData()
//        
//    }

//}
