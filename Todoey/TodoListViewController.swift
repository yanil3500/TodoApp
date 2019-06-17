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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            
            // get 
            guard let textFields = alert.textFields else { fatalError("Failed to get text field.") }
            let alertTextField = textFields[0]
            guard let itemText = alertTextField.text, !itemText.isEmpty else { return }
            
            self.items.append(itemText)
            
            self.tableView.reloadData()
            
            print(self.items.count)
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}