//
//  ViewController.swift
//  MC1-G4-FoodStock
//
//  Created by Diana Ambarwati Febriani on 11/04/20.
//  Copyright © 2020 Melina Dewi. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController {
    
    var shopItems = [String]()
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        //setup initial saving
        if !UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count") // number of item
        }
        
        //get all current saved items
        updateItems()
    }
    
    func updateItems(){
        
        shopItems.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        
        //iterate to add each item to array
        for i in 0..<count{
            if let item = UserDefaults().value(forKey: "item_\(i + 1)") as? String{
                shopItems.append(item)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addShopItem(){
        let vc = storyboard?.instantiateViewController(identifier: "add") as! AddShopItemVC
        vc.title = "New Item"
        vc.update = {
            DispatchQueue.main.async {
                self.updateItems()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //hilangin tanda yg udah ke klik
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let vc = storyboard?.instantiateViewController(identifier: "save") as! SaveShopItemVC
//        vc.item = shopItems[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, nil) in
            
            self.shopItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            UserDefaults.sndard.removeObject(forKey: "item_\(indexPath.row)")ta
        }
        
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
extension ShoppingListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = shopItems[indexPath.row]
        return cell
    }
}
