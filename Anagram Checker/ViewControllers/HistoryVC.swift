//
//  HistoryVC.swift
//  Anagram Checker
//
//  Created by Jeroen Dunselman on 25/11/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//
import UIKit

class HistoryVC: UIViewController {
    var history: [AnagramService]?
    var selected: AnagramService?
    
    @IBOutlet var tableView: UITableView!
    let textCellIdentifier = "HistoryCell"
    @IBAction func showSelection(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = history![indexPath.row]
        self.showSelection(indexPath.row)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history!.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let selectedAnagrams: AnagramService = (history?[row])!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        cell.textLabel?.text = selectedAnagrams._word
        cell.detailTextLabel?.text = String(selectedAnagrams.anagrams.count)
        
        return cell
    }
}
