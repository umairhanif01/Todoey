//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Umair Hanif on 13/05/2020.
//  Copyright © 2020 Umair Hanif. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var catArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let catName = catArray[indexPath.row]
        cell.textLabel?.text = catName.name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCat()
        
    }

    
    
    
    
    //MARK: - Add Alert with Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        
        //Creating Alert
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        //Creating Action
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //Saving into context
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            
            //Showing in table
            self.catArray.append(newCat)
            
            //Go to Save Function
            self.saveCat()
            
            
            
        }
        
        //Adding Text Field to Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        //Adding the action
        alert.addAction(action)
        
        //Presenting Alert
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - Model Manipulating Methods
    
    //Saving in Database
    func saveCat() {
        
        
        do{
            try context.save()
        } catch{
            print("Error Saving Context \(error)")
        }

        self.tableView.reloadData()
        
    }
    
    //Load Categories from Database
    
    func loadCat(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            catArray = try context.fetch(request)
        } catch {
            print("Error fetching Categories from Context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    

}
