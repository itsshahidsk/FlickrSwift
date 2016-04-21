//
//  FlickrSearchRequest.swift
//  FlickrSwift
//
//  Created by Shahid on 4/19/16.
//  Copyright © 2016 Sk. All rights reserved.
//

import UIKit
import Alamofire

let kAPIKey = "bb0743ec1df4ea2f3a99248d551e115e"


class FlickrRequest: NSObject {
    
    typealias FlickrResponse = (error: NSError? , photos: [FlickrPhoto]?) -> ()
    
    let invalidResponseError = NSError(domain: "flickr.api.com", code:100, userInfo: ["errorMessage": "Invalid Flickr Response"])
    
    let defaultSession: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    
    
    //MARK - Search Using NSURLSession
    func searchPhotosWithSearchText(searchText: String,forPage page:Int, andCompletionHandler completionHandler:FlickrResponse){
        
        let searchURLText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        guard let searchURLAllowedText = searchURLText else {
            print("Invalid Search Text")
            return
        }
        
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(kAPIKey)&text=\(searchURLAllowedText)&per_page=30&page=\(page)&format=json&nojsoncallback=1"
        
        let validURL = NSURL(string: urlString)
        
        guard let url = validURL else {
            print("Invalid URL")
            return
        }
        
        let dataTask = defaultSession.dataTaskWithURL(url) { (data, response, error) in
            
            if let error = error {
                print("Error has occured \(error)")
                return
            }
            
            do {
                let response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject]
                
                guard let responseDictionary = response , photosObject = responseDictionary["photos"] , photosArray = photosObject["photo"] else {
                    completionHandler(error: self.invalidResponseError, photos: nil)
                    return
                }
                
                guard let photos = photosArray as? [AnyObject] else {
                    completionHandler(error: self.invalidResponseError, photos: nil)
                    return
                }
                
                let downloadedFlickrPhotos:[FlickrPhoto] = photos.map({ (photo) -> FlickrPhoto in
                    let farm = photo["farm"] as? Int ?? 0
                    let photoId = photo["id"] as? String ?? ""
                    let secret = photo["secret"] as? String ?? ""
                    let server = photo["server"] as? String ?? ""
                    let title = photo["title"] as? String ?? ""
                    return FlickrPhoto(photoId:photoId ,farm:farm,secret:secret ,server: server,title: title)
                })
                completionHandler(error: nil,photos: downloadedFlickrPhotos)
                
            } catch let error as NSError {
                completionHandler(error: error,photos: nil)
                print("Error occurred \(error.userInfo)")
            }
        }
        
        dataTask.resume()
    }
    
    
    func searchPhotosUsingAlamofireWithSearchText(searchText: String , forPage page: Int,andCompletionHandler completionHandler: FlickrResponse) {
        
        guard  let searchURLAllowedString = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            print("Invalid URL Text")
            completionHandler(error:invalidResponseError , photos: nil)
            return
        }
        
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(kAPIKey)&text=\(searchURLAllowedString)&per_page=30&page=\(page)&format=json&nojsoncallback=1"

        guard let validURL = NSURL(string: urlString) else {
            print("Invalid url string")
            return
        }
        
        Alamofire.request(.GET, validURL).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                completionHandler(error: self.invalidResponseError, photos:nil)
                return
            }
            
            guard let responseDictionary = response.result.value , photosObject = responseDictionary["photos"] , photosArray = photosObject!["photo"] else {
                completionHandler(error: self.invalidResponseError, photos: nil)
                return
            }
            
            guard let photos = photosArray as? [AnyObject] else {
                completionHandler(error: self.invalidResponseError, photos: nil)
                return
            }
            
            let downloadedFlickrPhotos:[FlickrPhoto] = photos.map({ (photo) -> FlickrPhoto in
                let farm = photo["farm"] as? Int ?? 0
                let photoId = photo["id"] as? String ?? ""
                let secret = photo["secret"] as? String ?? ""
                let server = photo["server"] as? String ?? ""
                let title = photo["title"] as? String ?? ""
                return FlickrPhoto(photoId:photoId ,farm:farm,secret:secret ,server: server,title: title)
            })
            completionHandler(error: nil,photos: downloadedFlickrPhotos)
        }
        
    }
    
}
