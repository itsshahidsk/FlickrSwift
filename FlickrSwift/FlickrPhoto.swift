//
//  FlickrPhoto.swift
//  FlickrSwift
//
//  Created by Shahid on 4/20/16.
//  Copyright © 2016 Sk. All rights reserved.
//

import UIKit

import Foundation
import UIKit

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: NSURL {
        return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
        //    https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        
    }
    
}
