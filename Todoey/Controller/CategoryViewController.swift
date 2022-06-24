//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Cory Carte on 6/16/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm() // Can throw on first call. Safe call exists within AppDelegate.swift
    
    let defaults = UserDefaults.standard
    
    var categoryList: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        loadData()
    }
    
    //MARK: - IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What heppens once user clicks Add button
            
            if textField.text! != "" {
                // Set up new category
                let newCategory = Category()
                newCategory.name = textField.text!
                
                // Add new category to array, and save data
                self.save(category: newCategory)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return categoryList?.count ?? 1 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Categories"
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Perform seque
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVc.selectedCategory = categoryList?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    // READ
    func loadData() {
        categoryList = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // CREATE / UPDATE
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("save category error: \(error)")
        }
    }
    
    //MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deleteCategory = categoryList?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteCategory)
                }
            } catch {
                print("Delete category error: \(error)")
            }
        }
    }
}
