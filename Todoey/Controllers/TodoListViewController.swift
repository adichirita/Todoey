//
//  ViewController.swift
//  Todoey
//
//  Created by Adrian Chirita on 10/20/18.
//  Copyright © 2018 Zenegant. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController { //this subclassing saves us from needing to set this class as delegate of the table view, or do IBOutlets

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //prepare a location to save our items list (since we cannot save complex objects in the user defaults
        
        //itemArray = (self.defaults.array(forKey: "TodoListArray") ?? []) as! [String]
        
        loadItems()
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print("gege could not decode locally saved data \(error)")
            }
        }
        
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
        
        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done  ? .checkmark : .none //toggle on and off the checkmark accessory type of the cell
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //deselect after being tapped
        
        saveItems()
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the "Add Item" button on our UIAlert
            let item = Item()
            item.title = textField.text!
            self.itemArray.append(item)
            //FIXME: prevent the action from going through if the text field is empty
            
            self.tableView.reloadData()
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item here"
            print("gege ", alertTextField.text)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("gege Error encoding item array! \(error)")
        }
        print("gege Success")

    }
    

}

