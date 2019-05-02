//
//  ViewController.swift
//  messagingapp
//
//  Created by Cindy Royal on 4/23/19.
//  Copyright © 2019 Cindy Royal. All rights reserved.
//

import UIKit
import FirebaseDatabase

//var postData = ["Message 1", "Message 2", "Message 3"]
var selection:Int = 0
var postData = [[String: String]]() // initialize as an array of dictionaries (key: value pairs)

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var messageView: UITextView!
    
    //adds the subject and message, resigns keyboard, removes the text in textView
    @IBAction func addPost(_ sender: Any) {
        //adds the message, resigns keyboard, removes the text in textView
        let key = ref!.child("NewPosts").childByAutoId().key
        // can include multiple nodes in this array
        let post = [
            "subject": textView.text,
            "body": messageView.text]
        let childUpdates = ["/NewPosts/\(key)": post]
        ref!.updateChildValues(childUpdates)
        // resign keyboard and reset both subject and message fields
        textView.resignFirstResponder()
        textView.text = ""
        messageView.text = ""
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = (postData[indexPath.row]["subject"] as! String)
        return cell!
    }
    
    //Additional TableView functions to allow for editing/deleting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            //delete row from TableView
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //get the key for the selected row
            let theKey = postData[indexPath.row]["id"]!
            //remove the key and value from the array
            postData.remove(at: indexPath.row)

            //remove value from Firebase
            ref?.child("NewPosts").child("\(theKey)").removeValue()
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection = indexPath.row
        performSegue(withIdentifier: "TheSegue", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        // focus the cursor in the TextView
        
        // focus the cursor in the TextView
        textView.becomeFirstResponder()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        // set firebase reference
        ref=Database.database().reference()
        
        //retrieve posts and listen for changes
        //retrieve posts and listen for changes
        ref?.child("NewPosts").observe(.childAdded, with:  {
            (snapshot) in
            let key = snapshot.key
            var post = snapshot.value as? [String: String]
            post!["id"] = key
            postData.append(post as! [String : String])
            self.tableView.reloadData()
        })      
 
    }
}

