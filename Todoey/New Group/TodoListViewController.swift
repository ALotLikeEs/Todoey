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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem1 = DataModel()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)
        
        let newItem2 = DataModel()
        newItem2.title = "Buy eggs"
        itemArray.append(newItem2)
        
        let newItem3 = DataModel()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [DataModel] {
            itemArray = items
        }
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator
        cell.accessoryType = item.status ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        tableView.reloadData()
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
                
                self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
                
                self.tableView.reloadData()
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
}

