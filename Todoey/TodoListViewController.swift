//
//  ViewController.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/20/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController { //this subclassing saves us from needing to set this class as delegate of the table view, or do IBOutlets

    var itemArray = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        itemArray = (self.defaults.array(forKey: "TodoListArray") ?? []) as! [String]
    }
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Control what cell gets displayed in each row of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        cell.accessoryType = .none
        
        return cell
    }
    
    //MARK - TableView delegate methods fired whenever we selected/tapped on any cell in tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        let accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = accessoryType == .checkmark ? .none : .checkmark //toggle on and off the checkmark accessory type of the cell
        
        tableView.deselectRow(at: indexPath, animated: true) //deselect after being tapped
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the "Add Item" button on our UIAlert
            self.itemArray.append(textField.text!)
            //FIXME: prevent the action from going through if the text field is empty
            
            self.tableView.reloadData()
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            print("gege Success")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item here"
            print("gege ", alertTextField.text)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}

