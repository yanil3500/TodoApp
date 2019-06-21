//
//  TodoViewController.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/17/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import CoreData
import UIKit

class TodoListViewController: UITableViewController {
    // Entrance point into Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    let CELL_REUSE_IDENTIFIER = "TodoItemCell"

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER)!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items.count
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]

        // changes the done property when the user checks (or unchecks) the item from in the list
        selectedItem.done = !selectedItem.done

        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)

        // since the items have changed, let's save them to disk
        saveItems()
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

            let newItem = Item(context: self.context)
            newItem.title = itemText
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.items.append(newItem)

            // save items to disk
            self.saveItems()

            // reloads the table view so that the new data is shown
            self.tableView.reloadData()
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Model Manipulation Methods

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }

        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error).")
        }
    }
}

// MARK: - SearchBar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, and: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
        // when searchBar has been cleared, load all of the todo items
        if searchBar.text?.count == 0 {
            loadItems()

            // this where one would update their app's UI elements
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
