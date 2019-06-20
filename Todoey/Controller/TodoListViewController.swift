//
//  TodoViewController.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/17/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let CELL_REUSE_IDENTIFIER = "TodoItemCell"
    
    var items = [
        Item(title: "Find Mike"),
        Item(title: "Buy Eggos"),
        Item(title: "Pick up laundry")
    ]
    let defaults = UserDefaults.standard
    
    let SAVED_ITEM_KEY = "TodoListArray"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let itemArray = defaults.array(forKey: SAVED_ITEM_KEY) as? [Item] {
            items = itemArray
        }
        
    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER)!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = items[indexPath.row]
        
        // changes the done property when the user checks (or unchecks) the item from in the list
        selectedItem.toggleDone()

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // since the items have changed, let's save them to disk
//        defaults.set(self.items, forKey: SAVED_ITEM_KEY)
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // adds text field so the user can provide new items
        alert.addTextField { (textField) in
            textField.placeholder = "Ex: Buy Soap"
        }
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            // get list of text fields
            guard let textFields = alert.textFields else { fatalError("Failed to get text field.") }
            
            // grab the first one
            let alertTextField = textFields[0]
            
            // grab the text from the text field and assign to local constant if the value is not an empty string.
            guard let itemText = alertTextField.text, !itemText.isEmpty else { return }
            
            // add the item to the list
            let newItem = Item(title: itemText)
            self.items.append(newItem)
            
            self.defaults.set(self.items, forKey: self.SAVED_ITEM_KEY)
            
            // reloads the table view so that the new data is shown
            self.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}
