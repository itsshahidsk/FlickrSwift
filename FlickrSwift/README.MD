NOTE: This is demo project which shows how to make a webservice request and parse its results.

Flickr API has been used to demo.

Flicker API Details: 
https://www.flickr.com/services/api/explore/flickr.photos.search

PhotoSearch: 

https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(kAPIKey)&text=\(searchURLAllowedText)&per_page=30&page=\(page)&format=json&nojsoncallback=1


Photo URL : "http://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")

where we get the farm, server , photoid and secret details from the photosearch API 

