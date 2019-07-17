//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Elyanil Liranzo Castro on 7/8/19.
//  Copyright © 2019 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }

    // MARK: - Swipe Cell Delegate Methods

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [unowned self] _, indexPath in
            self.updateModel(at: indexPath)
        }

        deleteAction.image = #imageLiteral(resourceName: "delete-icon.png")

        return [deleteAction]
    }

    func tableView(_: UITableView, editActionsOptionsForRowAt _: IndexPath, for _: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        // Describes the behavior when the cell is swiped past a defined threshold.
        // In this case, the behavior will trigger a delete
        options.expansionStyle = .destructive
        return options
    }

    func updateModel(at _: IndexPath) {
        // Update our model
    }
}
