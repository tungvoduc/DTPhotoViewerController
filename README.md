# DTPhotoViewerController

[![CI Status](http://img.shields.io/travis/Tung Vo/DTPhotoViewerController.svg?style=flat)](https://travis-ci.org/Tung Vo/DTPhotoViewerController)
[![Version](https://img.shields.io/cocoapods/v/DTPhotoViewerController.svg?style=flat)](http://cocoapods.org/pods/DTPhotoViewerController)
[![License](https://img.shields.io/cocoapods/l/DTPhotoViewerController.svg?style=flat)](http://cocoapods.org/pods/DTPhotoViewerController)
[![Platform](https://img.shields.io/cocoapods/p/DTPhotoViewerController.svg?style=flat)](http://cocoapods.org/pods/DTPhotoViewerController)

## Example
![Screenshot](example.gif)

Demo video: https://www.youtube.com/watch?v=ccvrV8UdUhE&feature=youtu.be

It is very easy to use DTPhotoViewerController, all you need to do is to get UIImageView and UIImage instances, then:
```
if let viewController = DTPhotoViewerController(referenceView: imageView, image: image) {
    self.presentViewController(viewController, animated: true, completion: nil)
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DTPhotoViewerController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DTPhotoViewerController"
```

## Author

Tung Vo, tung98.dn@gmail.com

## License

DTPhotoViewerController is available under the MIT license. See the LICENSE file for more info.
