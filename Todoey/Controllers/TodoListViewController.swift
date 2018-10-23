//
//  ViewController.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/20/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController { //this subclassing saves us from needing to set this class as delegate of the table view, or do IBOutlets

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet { //triggered once set with a value
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
            print("gege searching category \(selectedCategory?.name)")
            fireRequest(with: request)
        }
    }
    
    var itemArray = [Item]()
    
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
        return itemArray.count
    }
    
    //MARK - Control what cell gets displayed in each row of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView delegate methods fired whenever we selected/tapped on any cell in tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //deselect after being tapped
    }
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the "Add Item" button on our UIAlert
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            //FIXME: prevent the action from going through if the text field is empty
            
            self.tableView.reloadData()
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item here"
            print("gege ", alertTextField.text!)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        

    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("gege Error saving context! \(error)")
        }
        self.tableView.reloadData()

    }
    
    func fireRequest(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
            print("gege searching..")
        } catch {
            print("gege Error searching data from coreData \(error)")
        }
        self.tableView.reloadData()
    }

}

//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fireRequest(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fireRequest()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //keyboard dissappears. without the dispatch queue block, focus dissapears only when using backspace, not also when clicking on the X sign in the searchbar
            }
        }
    }
    
}

