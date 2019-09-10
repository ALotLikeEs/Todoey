//
//  ViewController.swift
//  Todoey
//
//  Created by Ess on 25/08/2019.
//  Copyright © 2019 Ess. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems() 
        }
    }
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
               
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.status = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTexfield) in
            alertTexfield.placeholder = "Add item"
            textField = alertTexfield
        }
        
        alert.addAction(action)
        print("Success")
        present(alert, animated: true, completion: nil)
    }
    
    //Mark: - Model Manipulation Methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print ("Error saving context - \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName matches %@", selectedCategory!.categoryName!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching from contect \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest <Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                //Stop search bar from being first responder, as in remove cursor
                searchBar.resignFirstResponder()
            }
        }
    }
}
