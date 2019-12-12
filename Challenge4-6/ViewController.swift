//
//  ViewController.swift
//  Challenge4-6
//
//  Created by  Vladislav Bondarev on 12.12.2019.
//  Copyright © 2019 Vladislav Bondarev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRecord)),UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shared))]
        
        title = "Shopping List"
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    @objc func clearList() {
        let ac = UIAlertController(title: "Accept?", message: "Clear shopping list?", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Accept", style: .default) { [weak self] action in
            self?.shoppingList.removeAll(keepingCapacity: true)
            self?.tableView.reloadData()
        }
        ac.addAction(submitAction) 
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(ac,animated: true)
    }
    
    @objc func addRecord() {
        let ac = UIAlertController(title: "New product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.checkAdd(answer)
        }
        
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    @objc func shared() {
        let list = shoppingList.joined(separator: ",")
        print(list)
        let vc =  UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func checkAdd(_ product:String) {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: product.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: product, range: range, startingAt: 0, wrap: false, language: "en")
        if (misspelledRange.location == NSNotFound) {
            shoppingList.insert(product, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
        }
        else {
            let ac = UIAlertController(title: "Wrong", message: "Product: \(product) is not found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Close", style: .cancel))
            present(ac,animated: true)
        }
    }


}

