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

    var items = ["Find Mike", "Buy Eggos", "Pick up laundry"]
    
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let itemArray = defaults.array(forKey: "TodoListArray") as? [String] {
            items = itemArray
        }
        
    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER)!
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        let isChecked = selectedCell?.accessoryType == .checkmark
        
        // if the selected cell has the .checkmark accessory type, then set it to the .none accessory type
        selectedCell?.accessoryType = isChecked ? .none : .checkmark

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
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
            self.items.append(itemText)
            
            self.defaults.set(self.items, forKey: "TodoListArray")
            
            // reloads the table view so that the new data is shown
            self.tableView.reloadData()
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}
