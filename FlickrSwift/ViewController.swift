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
    
    
    let flickrRequest = FlickrRequest()
    
    var flickrPhotos = [FlickrPhoto]()
    
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
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text where searchText.characters.count > 0 {
            performSearchWithText(searchText)
        }
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flickrPhotos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier(kTableViewCellIdentifier)
        let flickrPhoto = flickrPhotos[indexPath.row]
        cell?.textLabel?.text = flickrPhoto.title
     //   cell?.imageView?.sd_setImageWithURL(flickrPhoto.photoUrl)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected index path is \(indexPath)")
    }
}

extension ViewController {
    
    func performSearchWithText(searchText:String) {
        //Show the activity indicator view
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        flickrRequest.searchPhotosWithSearchText(searchText, forPage: 1, andCompletionHandler: {[weak self] (error, photos) in
            
            dispatch_async(dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            
            guard error == nil else {
                print("Error is \(error)")
                return
            }
            
            if let photos = photos where photos.count > 0 {
                //print(photos)dogs
                self?.flickrPhotos =  photos.filter({ (photo) -> Bool in
                    return photo.title.characters.count > 0
                })
                
                dispatch_async(dispatch_get_main_queue(), {
                    self?.tableview.reloadData()
                })
            }
            
            })
        
    }
}