//
//  ViewController.swift
//  messagingapp
//
//  Created by Cindy Royal on 4/23/19.
//  Copyright © 2019 Cindy Royal. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //var postData = ["Message 1", "Message 2", "Message 3"]
    var postData = [String]()
    var postKey = [String]()
    var theKey = String()
    
    @IBOutlet weak var textView: UITextView!
    
    //adds the message, resigns keyboard, removes the text in textView
    @IBAction func addPost(_ sender: Any) {
    ref?.child("Posts").childByAutoId().setValue(textView.text)
    textView.resignFirstResponder()
    textView.text = ""
    }
    
    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            //delete row from TableView
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //get the key for the selected row
            theKey = postKey[indexPath.row]
            //remove the key and value from the array
            postData.remove(at: indexPath.row)
            postKey.remove(at: indexPath.row)
            
            //remove value from Firebase
            ref?.child("Posts").child("\(theKey)").removeValue()
            tableView.endUpdates()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        // focus the cursor in the TextView
        textView.becomeFirstResponder()
       
        //Important: this allows the swipe-for-delete feature
        tableView.allowsMultipleSelectionDuringEditing = true
        
        ref=Database.database().reference()
        
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            //code to execute when a child is added
            //take the value and key from snapshot, add to postData and postKey arrays
            
            let post = snapshot.value as! String
            self.postData.append(post)
            let key = snapshot.key
            self.postKey.append(key)
            self.tableView.reloadData()
        })
    }
}
