//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/22/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoriesArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the "Add Item" button on our UIAlert
            let category = Category(context: self.context)
            category.name = textField.text!

            self.categoriesArray.append(category)
            //FIXME: prevent the action from going through if the text field is empty
            
            self.tableView.reloadData()
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category here"
            print("gege ", alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView Delegate methods (when we click a cell)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
            print("gege destination \(categoriesArray[indexPath.row])")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //deselect after being tapped
        performSegue(withIdentifier: "categoryToItems", sender: self)
    }
    
    //MARK: - Data Manipulation methods CRUD
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoriesArray = try context.fetch(request)
            print("gege searching..")
        } catch {
            print("gege Error searching data from coreData \(error)")
        }
        self.tableView.reloadData()
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("gege Error saving context! \(error)")
        }
        self.tableView.reloadData()
        
    }
    
}
