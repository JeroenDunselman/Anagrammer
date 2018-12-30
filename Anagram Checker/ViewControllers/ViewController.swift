//
//  ViewController.swift
//  Anagram Checker
//
//  Created by Jeroen Dunselman on 24/11/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var anagrams : AnagramService?
    var anagramsInView : [String] = []
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    
    let hint = "Enter text, then hit List to show anagrams"
    @IBOutlet weak var userInput: UITextField!
    var currentInput = ""
    @IBOutlet weak var btnList: UIButton!
    @IBAction func btnShowList(_ sender: Any) {
        self.refreshList()
    }
    var isCalculating = false
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    //  Show and hide viewcontroller for checking if words are anagrams
    var vcCheck: WordCheckVC?
    @IBOutlet weak var btnCheck: UIButton!
    @IBAction func btnCheck(_ sender: Any) {
        if let current = self.anagrams {
            vcCheck?.anagrams = current
            vcCheck?.navigationItem.title = "Anagram of \(current._word)?"
        }

        let navController = UINavigationController(rootViewController: vcCheck!)
        present(navController, animated: false, completion: nil)
    }
    
    //  Show and hide viewcontroller for selection of previously listed anagrams
    var history: [AnagramService] = []
    var vcHistory: HistoryVC?
    @IBOutlet weak var btnHistory: UIButton!
    @IBAction func btnHistory(_ sender: UIButton) {
        vcHistory?.history = self.history
        let navController = UINavigationController(rootViewController: vcHistory!)
        present(navController, animated: false, completion: nil)
    }
    @IBAction func unwindSegueToVC(segue:UIStoryboardSegue) {
        //  Update input to selected word from History
        self.userInput.text = vcHistory?.selected?._word
        //  List anagrams for current input
        self.refreshList()
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    func refreshList() {
        //      update controls
        self.btnList.isEnabled = false
        self.btnHistory.isEnabled = self.history.count > 0
        
        //      update current
        currentInput = self.userInput.text!
        
        //      Show permutations for current input
        //      Look in session history for previous AnagramService
        if let previous = self.history.first(where: { $0._word == currentInput}) {
            anagrams = previous
            anagramsInView = previous.anagrams
            self.btnCheck.isEnabled = anagramsInView.count > 0
            self.tableView.isHidden = (self.anagramsInView.count == 0)
            self.tableView.reloadData()
            let info = "Number of permutations: \(previous.anagrams.count) \n Length:\(previous._word.count)"
            self.lblInfo.text = info as String
            return
        }
        
        //      Prepare screen for new calculation
        self.tableView.isHidden = true
        self.lblInfo.text = "Calculating..."
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        //      In background make anagrams for input
        isCalculating = true
        DispatchQueue.global(qos: .background).async {
            let service = AnagramService(word: self.currentInput)
            self.anagrams = service
            self.history.append(service)
            self.anagramsInView = service.anagrams
            let info = "Number of permutations: \(service.anagrams.count) \n Length:\(service._word.count)"
            
            self.isCalculating = false
            //  Update view in foreground for new anagrams
            DispatchQueue.main.async() { () -> Void in
                
                self.btnCheck.isEnabled = (self.anagramsInView.count > 0)
                self.btnHistory.isEnabled = true
                self.tableView.isHidden = (self.anagramsInView.count == 0)
                self.tableView.reloadData()
                self.lblInfo.text = info as String
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var enableButtons = false
        if let inputText = self.userInput.text,
            inputText != currentInput,
            inputText.count > 1,
            !isCalculating {
            enableButtons = true
        }
        self.btnList.isEnabled = enableButtons
        self.btnCheck.isEnabled = enableButtons &&
            //  disable unless calculation finished for current userInput.text
            self.history.contains(where: { $0._word == self.userInput.text})
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: textCellIdentifier)
        tableView.dataSource = self
        
        vcHistory = self.storyboard?.instantiateViewController(withIdentifier: "History") as? HistoryVC
        vcHistory?.navigationItem.title = "History"
        vcHistory?.navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        
        vcCheck = self.storyboard?.instantiateViewController(withIdentifier: "WordCheck") as? WordCheckVC
        vcCheck?.navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        
        self.activityIndicator.isHidden = true
        btnList.isEnabled = false
        btnCheck.isEnabled = false
        btnHistory.isEnabled = false
        userInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anagramsInView.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = anagramsInView[row]
        
        return cell
    }
}

