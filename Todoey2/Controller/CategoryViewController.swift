//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Chris Manik on 9/2/19.
//  Copyright © 2019 Natanail Manik. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories: Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Nothing added Category"
        return cell
    }
    
    // MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Manupulation Method
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving Category \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - ADD NEW CATEGORY
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add new Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            field.placeholder = "Create a new Category"
            textField = field
        }
        present(alert, animated: true, completion: nil)
        
    }
    
}
