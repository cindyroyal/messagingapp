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
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func addPost(_ sender: Any) {
  ref?.child("Posts").childByAutoId().setValue(textView.text)   
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ref=Database.database().reference()
        
        //retrieve posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            //code to execute when a child is added
            //take the value from snapshot, add to postData array
            let post = snapshot.value as? String
            self.postData.append(post!)
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

