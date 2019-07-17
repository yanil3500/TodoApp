//
//  TodoViewController.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/17/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import ChameleonFramework
import RealmSwift
import UIKit

class TodoListViewController: SwipeTableViewController {
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }

    var items: Results<Item>?

    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = selectedCategory?.name
        
        guard let color = selectedCategory?.color else { fatalError() }
        
        updateNavigationBar(withHexCode: color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavigationBar(withHexCode: UIColor.whiteColorHexString)
    }
    
    
    // MARK: - Navigation Bar Setup
    func updateNavigationBar(withHexCode colorHexCode: String){
        guard let navigationBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.") }
        
        let barTintColor = UIColor(hexString: colorHexCode)!
        
        navigationBar.barTintColor = barTintColor
        
        navigationBar.tintColor = ContrastColorOf(barTintColor, returnFlat: true)
        
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(barTintColor, returnFlat: true)]
        
        searchBar.barTintColor = barTintColor
    }
    
    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none

            // creating a gradient flow
            // the cell's background color is going to be set based on the current indexPath and the total # of items
            // backgroundColor = current index path / # of items
            let colorDarknessPercentage = CGFloat(indexPath.row) / CGFloat(items!.count)
            let selectedCategoryBackgroundColor = UIColor(hexString: selectedCategory!.color!)!
            if let backgroundColor = selectedCategoryBackgroundColor.darken(byPercentage: colorDarknessPercentage) {
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }

        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items?.count ?? 1
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = items?[indexPath.row] else { return }

        // changes the done property when the user checks (or unchecks) the item from in the list
        // since the items have changed, let's store them
        CategoryStorage.shared.save { _ in
            selectedItem.done = !selectedItem.done
        }

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items

    @IBAction func addButtonPressed(_: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        // adds text field so the user can provide new items
        alert.addTextField { textField in
            textField.placeholder = "Ex: Buy Soap"
        }

        let action = UIAlertAction(title: "Add Item", style: .default) { _ in
            // what will happen once the user clicks the Add Item button on our UIAlert

            // get list of text fields
            guard let textFields = alert.textFields else { fatalError("Failed to get text field.") }

            // grab the first one
            let alertTextField = textFields[0]

            // grab the text from the text field and assign to local constant if the value is not an empty string.
            guard let itemText = alertTextField.text, !itemText.isEmpty else { return }

            // add the item to the list
            if let selectedCategory = self.selectedCategory {
                let newItem = Item(date: Date())
                newItem.title = itemText
                CategoryStorage.shared.save { _ in
                    selectedCategory.items.append(newItem)
                }
            }

            // reloads the table view so that the new data is shown
            self.tableView.reloadData()
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Model Manipulation Methods

    private func load() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }

    // MARK: - Delete Data From Swipe

    override func updateModel(at indexPath: IndexPath) {
        CategoryStorage.shared.update { [unowned self] realm in
            guard let item = self.items?[indexPath.row] else { return }
            realm?.delete(item)
        }
    }
}

// MARK: - SearchBar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
        // when searchBar has been cleared, load all of the todo items
        if searchBar.text?.count == 0 {
            load()

            // this where one would update their app's UI elements
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
