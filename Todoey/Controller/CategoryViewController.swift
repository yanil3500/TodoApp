//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 6/20/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import CoreData
import UIKit

let list = """
Shopping List
Home
Work
Misc.
"""

class CategoryViewController: UITableViewController {
    // Entrance point into Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    let CELL_REUSE_IDENTIFIER = "CategoryCell"

    let SEGUE_IDENTIFIER = "goToItems"

    var categories = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        loadCategories()
    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_IDENTIFIER)!
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return categories.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SEGUE_IDENTIFIER {
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let category = categories[index]
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = category
        }
    }

    // MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SEGUE_IDENTIFIER, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Categories

    @IBAction func addButtonPressed(_: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)

        // adds text field so the user can provide new categories
        alert.addTextField { textField in
            textField.placeholder = "Ex: Shopping List"
        }

        let action = UIAlertAction(title: "Add Category", style: .default) {
            _ in
            // what will happen once the user clicks the Add Category button on our UIAlert

            // get list of text fields
            guard let textFields = alert.textFields else {
                fatalError("Failed to get text field")
            }

            // grab the first one
            let alertTextField = textFields[0]

            // grab the text from the text field and assign to local constant if value is not an empty string
            guard let categoryName = alertTextField.text, !categoryName.isEmpty else { return }

            let newCategory = Category(context: self.context)
            newCategory.name = categoryName

            self.categories.append(newCategory)

            // save categories to disk
            self.saveCategories()

            // reloads the table view so that the new data is shown
            self.tableView.reloadData()
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Data Manipulation Methods

    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving data to context: \(error)")
        }
    }

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error).")
        }
    }
}
