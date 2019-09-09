//
//  ViewController.swift
//  Todoey
//
//  Created by Ess on 25/08/2019.
//  Copyright © 2019 Ess. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Item One", "Item Two", "Item Three"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle:.alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //Once user clicks add item button
            if (textField.text != ""){
                self.itemArray.append(textField.text!)
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

