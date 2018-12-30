//
//  WordCheckVC.swift
//  Anagram Checker
//
//  Created by Jeroen Dunselman on 24/11/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

class WordCheckVC: UIViewController {
 
 var anagrams: AnagramService?
 @IBOutlet weak var txtCheck: UITextField!
 @IBOutlet weak var lblHeader: UILabel!
 
 @IBAction func btnCheck(_ sender: UIButton) {
  if let word = anagrams?._word,
   let current = self.txtCheck.text, current != "",
   let result = anagrams?.isAnagram(check: current) {
   lblHeader.text = "\(result ? "Yes" : "No"), \(current) is\(result ? "" : " not") an anagram of \(word)"
  }
 }
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  self.view.endEditing(true)
  super.touchesBegan(touches, with: event)
 }
 
 override func viewDidLoad() {
  super.viewDidLoad()
 }
 
 override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
 }
 
}
