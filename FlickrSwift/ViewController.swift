//
//  ViewController.swift
//  FlickrSwift
//
//  Created by Shahid on 4/19/16.
//  Copyright © 2016 Sk. All rights reserved.
//

import UIKit


let kTableViewCellIdentifier = "Cell"

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableview.registerClass(UITableViewCell.self, forCellReuseIdentifier:kTableViewCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK: UISearch Bar Delegate Methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Entered text is \(searchBar.text)")
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier(kTableViewCellIdentifier)
        cell?.textLabel?.text = "Shahid"
        return cell!
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected index path is \(indexPath)")
    }
}