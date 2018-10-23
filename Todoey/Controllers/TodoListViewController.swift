//
//  ViewController.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/20/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController { //this subclassing saves us from needing to set this class as delegate of the table view, or do IBOutlets

    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            let nocateg = "nocateg"
            print("gege Selected category: \(selectedCategory?.name ?? nocateg)")
            loadItems()
        }
    }
    
    var todoItems : Results<Item>?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //prepare a location to save our items list (since we cannot save complex objects in the user defaults
        
        //itemArray = (self.defaults.array(forKey: "TodoListArray") ?? []) as! [String]
        
        //fireRequest() //no argument, all items
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - Control what cell gets displayed in each row of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items"
        }
        
        return cell
    }
    
    //MARK - TableView delegate methods fired whenever we selected/tapped on any cell in tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done //update the "done" indicator
                    //realm.delete(item) //delete the row when tapped
                }
            } catch {
                print("gege error updating 'done' \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) //deselect after being tapped
    }
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        //item.dateCreated = Date() //Date.init(timeIntervalSinceNow: 0)
                        currentCategory.items.append(item)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
                
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item here"
            print("gege3 ", alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        

    }

    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }

}

//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //keyboard dissappears. without the dispatch queue block, focus dissapears only when using backspace, not also when clicking on the X sign in the searchbar
            }
        }
    }
    
}

