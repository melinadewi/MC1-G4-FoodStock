//
//  ShoppingVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 11/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ShoppingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfShopItems: [FoodModel] = []
    var listOfAllItems: [FoodModel] = []
    var listOfKeys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        populateList()
        emptyItems()

        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func populateList() {

        if let data = UserDefaults.standard.data(forKey: "allkeys") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let keys = try decoder.decode([String].self, from: data)
                listOfKeys = keys
                
                for key in keys {
                    if let data = UserDefaults.standard.data(forKey: key) {
                        do {
                            // Create JSON Decoder
                            let decoder = JSONDecoder()
                            
                            // Decode Note
                            let item = try decoder.decode(FoodModel.self, from: data)
                                listOfAllItems.append(item)

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
    }
    
    func emptyItems() {
        for item in listOfAllItems {
            if item.stockLevel == .empty {
                listOfShopItems.append(item)
            }
        }
    }
    
    
    
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
//            print(item.stockLevel)

        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfShopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
        
        cell.textLabel?.text = listOfShopItems[indexPath.row].foodName
        

        return cell
    }
    
    // did tap cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEditShopItem", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){(action, view, nil) in

   //         let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: .alert)

            self.listOfShopItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            let id = self.listOfShopItems[indexPath.row].id
//            if let index = self.listOfShopItems.firstIndex(where: { $0.id == id}) {
//                self.listOfShopItems.remove(at: index)
//
//                // UserDefault Model
//                self.listOfKeys = self.listOfKeys.filter { $0 != id }
//                self.setKeys()
//                UserDefaults.standard.removeObject(forKey: id) // delete object in userdefault
//                UserDefaults.standard.removeObject(forKey: "\(id)-img") // delete image in userdefault
                
                tableView.reloadData()
            
        }

            return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SaveShopItemVC {
            destination.selectedItem = listOfShopItems[tableView.indexPathForSelectedRow!.row]
            destination.delegate = self
        }
        
         let vc = segue.destination as? AddShopItemVC
            vc?.delegate = self
        
     //   let nc = segue.destination as?

    }
    
}

extension ShoppingVC: AddShopItemVCDelegate {
    func addToList(newModel: FoodModel) {
        listOfShopItems.append(newModel)
        tableView.reloadData()
    }
}

extension ShoppingVC: SaveShopItemVCDelegate {
    func saveToStock(editItem: FoodModel) {
        print(editItem.foodName)
        print(editItem.expDate)
        print(editItem.stockLevel)
        
        let foodId = editItem.id
        setData(item: editItem)
        //        print(foodId)
        
        if let index = listOfAllItems.firstIndex(where: { $0.id == foodId } ) { // get the index from the original list
            listOfAllItems[index] = editItem      // replace food with new edited food
            //            print(index)
        }

    }

}

