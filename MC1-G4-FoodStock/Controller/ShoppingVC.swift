//
//  ShoppingVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 11/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ShoppingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddShopItemVCDelegate {
    
    func addToList(newModel: FoodModel) {
        listOfShopItems.append(newModel)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfShopItems: [FoodModel] = []
    var listOfKeys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        populateList()

        
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
                            if item.stockLevel == .empty {
                                listOfShopItems.append(item)
                            }

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
        }

            return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SaveShopItemVC {
            destination.selectedItem = listOfShopItems[tableView.indexPathForSelectedRow!.row]
        }
        
         let vc = segue.destination as? AddShopItemVC
            vc?.delegate = self

    }
    
}
