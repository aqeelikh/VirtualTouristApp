# VirtualTouristApp

<p align="center">
    <img width="180" src="AppScreenshots/Logo.png" alt="logo">
</p>

> The VirtualTourist project allows users to specify travel locations around the world, and create virtual photo albums for each location. The locations and photo albums will be stored in Core Data.


[![Swift Version][swift-image]][swift-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)


## Introduction
This app allows users specify travel locations around the world, and create virtual photo albums for each location. The locations and photo albums will be stored in Core Data. The app will have three view controller scenes.

• Travel Locations Map View: Allows the user to drop pins around the world.

• Photo Album View: Allows the users to download and edit an album for a location.

• Random Pin View: Allow users to pick random images from droped pins in the map vie.



**Travel Locations Map View** When the app first starts it will open to the map view. Users will be able to zoom and scroll around the map using standard pinch and drag gestures. The center of the map and the zoom level should be persistent. If the app is turned off, the map should return to the same state when it is turned on again. Tapping and holding the map drops a new pin. Users can place any number of pins on the map. When a pin is tapped, the app will navigate to the Photo Album view associated with the pin.

<img src="./AppScreenshots/FirstPage.png" width="50%" height="100%" />

**Photo Album View**: Photo Album If the user taps a pin that does not yet have a photo album, the app will download Flickr images associated with the latitude and longitude of the pin. If no images are found a “No Images” label will be displayed. If there are images, then they will be displayed in a collection view. While the images are downloading, the photo album is in a temporary “downloading” state in which the New Collection button is disabled. The app should determine how many images are available for the pin location, and display a placeholder image for each.

Once the images have all been downloaded, the app should enable the New Collection button at the bottom of the page. Tapping this button should empty the photo album and fetch a new set of images. Note that in locations that have a fairly static set of Flickr images, “new” images might overlap with previous collections of images. Users should be able to remove photos from an album by tapping them. Pictures will flow up to fill the space vacated by the removed photo. All changes to the photo album should be automatically made persistent. Tapping the back button should return the user to the Map view. If the user selects a pin that already has a photo album then the Photo Album view should display the album and the New Collection button should be enabled.

<img src="./AppScreenshots/LocationCollectionView.png" width="50%" height="100%" />


Random Pin View: After the user add location pins to the map view it will serach core data and select a rondom pin, and will pull a random image related to the selected pin, it will also return location dispction. The user also can click on on `Random image` button it will randomly choose another pin. 


Random Pin View: After the user adds location pins to the `Mapview` it will search core data and select a random pin, and will pull a random image related to the selected pin, it will also return location description. The user also can click on on `Random image` button it will randomly choose another pin. 

<img src="./AppScreenshots/RandomPin.png" width="50%" height="100%" />


## Features

- [x] Users will be able to zoom and scroll around the map using standard pinch and drag gestures.
- [x] The center of the map and the zoom level should be persistent. If the app is turned off, the map should return to the same state when it is turned on again.
- [x] Tapping and holding the map drops a new pin.
- [x] When a pin is tapped, the app will navigate to the Photo Album view associated with the pin
- [x] the app will download Flickr images associated with the latitude and longitude of the pin.
- [x] The app should determine how many images are available for the pin location
- [x] Users are able to remove photos from an album by tapping them.
- [x] Pick a random image from downloaded pins and display information about the location of the image.

## Requirements

- iOS 12.0+
- Xcode 10

## Installation

Open terminal and change you current directory

`$ cd /Users/user/project_folders`

Clone project repository

`$ git clone https://github.com/aqeelikh/VirtualTouristApp`

#### CocoaPods
Installed CocoaPods `Kingfisher` and `ReachabilitySwif` :

```ruby
platform :ios, '8.0'
pod 'Kingfisher', '~> 5.0'
pod 'ReachabilitySwift'
``` 


[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
