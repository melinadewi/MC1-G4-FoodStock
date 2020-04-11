//
//  ShoppingVC.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 11/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ShoppingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddItem {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listOfShopItems: [ShoppingModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listOfShopItems.append(ShoppingModel(itemName: "Apel"))
        listOfShopItems.append(ShoppingModel(itemName: "Kiwi"))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfShopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShoppingCell
        
        cell.shopItemLabel.text = listOfShopItems[indexPath.row].itemName
        cell.listOfShopItems = listOfShopItems
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddShopItemVC
        vc.delegate = self
    }
    func addItem(itemName: String) {
        listOfShopItems.append(ShoppingModel(itemName: itemName))
        tableView.reloadData()
        print(listOfShopItems)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
