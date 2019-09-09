//
//  ViewController.swift
//  Todoey
//
//  Created by Ess on 25/08/2019.
//  Copyright © 2019 Ess. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [DataModel]()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems ()
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.status ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle:.alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //Once user clicks add item button
            if (textField.text != ""){
               
                let newItem = DataModel()
                
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                
                self.saveItems()
                
               // self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
                
            }
        }
        
        alert.addTextField { (alertTexfield) in
            alertTexfield.placeholder = "Add item"
            textField = alertTexfield
        }
        
        alert.addAction(action)
        print("Sucess")
        present(alert, animated: true, completion: nil)

    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print ("Error encoding data - \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([DataModel].self, from: data)
            } catch {
                print("Error decoding items array")
            }
        }
    }
}

