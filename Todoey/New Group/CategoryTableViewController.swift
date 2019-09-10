//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ess on 09/09/2019.
//  Copyright © 2019 Ess. All rights reserved.

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let cellIdentifier : String = "categoryCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let categoryItem = categoryArray[indexPath.row]
        categoryCell.textLabel?.text = categoryItem.categoryName
        return categoryCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: - Table view data manipulation methods
    
    //Mark: - Add catedory items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if (textField.text != ""){
                let newCategory = Category(context: self.context)
                newCategory.categoryName = textField.text!
                self.categoryArray.append(newCategory)
                self.saveCategory()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    
    //Mark: - Model Manipulation Methods
    
    func saveCategory(){
        do {
            try context.save()
        } catch {
            print("There was an error saving context -> \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fecthing from context - > \(error)")
        }
        tableView.reloadData()
    }
}
