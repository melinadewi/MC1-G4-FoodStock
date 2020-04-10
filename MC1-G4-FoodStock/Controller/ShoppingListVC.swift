//
//  ShoppingListVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 08/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ShoppingListVC: UITableViewController {

    let identifier:String = "ShoppingCell"
    
    var listOfShopItems = ShoppingModel.createShopItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.delegate = self
        tableView.dataSource = self
        setUpNavBar()
    }
    
    func setUpNavBar() {
        // creates a search controller and add button
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShopItem))
        
        // adding the search controller to the nav bar
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addShopItem(){
       performSegue(withIdentifier: "toAddShopItem", sender: self)
    }

    // MARK: - Table view data source
}

extension ShoppingListVC{
    override func tableView( _ tableview: UITableView, numberOfRowsInSection section: Int) -> Int{
    return listOfShopItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShoppingCell {
            cell.configureTheCell(shopItem: listOfShopItems[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}


 
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell =  tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: IndexPath)
//
//            let shop = listOfShopItems[indexPath.row]
//
//            cell.shopItemLabel?.text = "\(shop.shopItem)"
//            return cell
//        }
        

    
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

