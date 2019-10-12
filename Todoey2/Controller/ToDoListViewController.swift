//
//  ViewController.swift
//  Todoey2
//
//  Created by Chris Manik on 8/6/19.
//  Copyright © 2019 Natanail Manik. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {

    let realm = try! Realm()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoItems : Results<Item>? //["Find Mike", "Buy Eggs","Destroy Demogorgon"]
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    

    }
    
    //MARK: Table View Data Source Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark: .none
        }else{
            cell.textLabel?.text = "No Items added"
        }
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving item status\(error)")
                
            }
            tableView.reloadData()
        }
//        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What Will happen once the click add items
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.currentDate = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving a new Itmes")
                }
                
            }
            self.tableView.reloadData()
            
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
//    func saveItems(){
//        do{
//            try context.save()
//        }catch{
//            print("Error saving context \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func loadItems(){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    
}

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "currentDate", ascending: true)
        tableView.reloadData()
    }
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


