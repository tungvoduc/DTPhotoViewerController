# DTPhotoViewerController

[![Version](https://img.shields.io/cocoapods/v/DTPhotoViewerController.svg?style=flat)](http://cocoapods.org/pods/DTPhotoViewerController)
[![License](https://img.shields.io/cocoapods/l/DTPhotoViewerController.svg?style=flat)](http://cocoapods.org/pods/DTPhotoViewerController)
[![Platform](https://img.shields.io/cocoapods/p/DTPhotoViewerController.svg?style=flat)](http://cocoapods.org/pods/DTPhotoViewerController)

## Example
![Screenshot](demo.gif)

Demo video: https://youtu.be/aTLx4M4zsKk

DTPhotoViewerController is very simple to use, if you want to display only one image in the photo viewer, all you need to do is to pass UIImageView and UIImage instances:
```
if let viewController = DTPhotoViewerController(referencedView: imageView, image: image) {
    self.presentViewController(viewController, animated: true, completion: nil)
}
```

For multiple images, what you have to do is providing an dataSource to the DTPhotoViewerController instance. DTPhotoViewerControllerDataSource has three required methods and one optional method, here is an example how to implement them which is also available in the Demo:

```
func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
    let indexPath = IndexPath(item: index, section: 0)
    if let cell = self.collectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
        return cell.imageView
    }
        
    return nil
}

func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
    return images.count
}

func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
     // You need to implement this method usually when using custom DTPhotoCollectionViewCell and configure each photo differently.
}
    
func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
    imageView.image = images[index]
}
```

In case you want to add more UI elements to each photo, the best way is to create a subclass of DTPhotoCollectionViewCell and then call either one of these methods registerClassPhotoViewer: or registerNibForPhotoViewer:
```
if let viewController = BDFPostPhotoViewerController(referencedView: cell.imageView, image: cell.imageView.image) {
     viewController.registerClassPhotoViewer(DTCustomPhotoCollectionViewCell.self)
}
```

There is also delegate(DTPhotoViewerControllerDelegate) if you want to customize the behavior of DTPhotoViewerController.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

### CocoaPods
DTPhotoViewerController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

For Swift 5:

```ruby
pod "DTPhotoViewerController"
```

For Swift 4.2:

```ruby
pod 'DTPhotoViewerController', '~> 1.2.5'
```

### Swift package manager
`DTPhotoViewerController` is available for SPM from version `3.0.2`.
Add the following to the dependencies of your `Package.swift`:

```swift
.package(url: "https://github.com/tungvoduc/DTPhotoViewerController", from: "version")
```

## Author

Tung Vo, tung98.dn@gmail.com

## License

DTPhotoViewerController is available under the MIT license. See the LICENSE file for more info.

## Feedbacks & requests
- Open an issue if you find a bug, make a proposal or simply need some help.
- You can also contact me via [email](mailto:tung98.dn@gmail.com).
