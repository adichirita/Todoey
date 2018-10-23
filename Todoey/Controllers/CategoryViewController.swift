//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/22/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() //not as bad as it looks apparently
    
    var categoriesArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the "Add Item" button on our UIAlert
            let category = Category()
            category.name = textField.text!

            //self.categoriesArray.append(category) //not needed, Result will AUTO UPDATE!
            //FIXME: prevent the action from going through if the text field is empty
            
            self.tableView.reloadData()
            
            self.save(category: category)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category here"
            print("gege2 ", alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Category Selected"
    
        return cell
    }
    
    //MARK: - TableView Delegate methods (when we click a cell)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
            print("gege destination \(String(describing: categoriesArray?[indexPath.row]))")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true) //deselect after being tapped
    }
    
    //MARK: - Data Manipulation methods CRUD
    func loadCategories(){
        
        categoriesArray = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("gege Error saving realm! \(error)")
        }
        self.tableView.reloadData()
        
    }
    
}
