//
//  ViewController.swift
//  DTPhotoViewerController
//
//  Created by Tung Vo on 05/07/2016.
//  Copyright (c) 2016 Tung Vo. All rights reserved.
//

import UIKit
import DTPhotoViewerController

private let kCollectionViewCellIdentifier = "Cell"
private let kNumberOfRows: Int = 3
private let kRowSpacing: CGFloat = 5
private let kColumnSpacing: CGFloat = 5

/// Class ViewController
/// Display collection of photos
class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate var selectedImageIndex: Int = 0
    
    var images = [UIImage]()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = kColumnSpacing
        flowLayout.minimumLineSpacing = kRowSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: kRowSpacing, left: kColumnSpacing, bottom: kRowSpacing, right: kColumnSpacing)
        
        super.init(collectionViewLayout: flowLayout)
        
        for i in 0...9 {
            images.append(UIImage(named: "mario\(i%5 + 1)")!)
        }
        
        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCellIdentifier)
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        title = "Example"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionViewLayout.invalidateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionViewCellIdentifier, for: indexPath) as! CollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(kNumberOfRows - 1)
        let itemSize = floor(width/CGFloat(kNumberOfRows))
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageIndex = indexPath.row
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            if let viewController = SimplePhotoViewerController(referencedView: cell.imageView, image: cell.imageView.image) {
                viewController.dataSource = self
                viewController.delegate = self
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: DTPhotoViewerControllerDataSource
extension ViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        // Set text for each item
        if let cell = cell as? CustomPhotoCollectionViewCell {
            cell.extraLabel.text = "Index \(index)"
        }
    }
    
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
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        imageView.image = images[index]
    }
}

//MARK: DTPhotoViewerControllerDelegate
extension ViewController: SimplePhotoViewerControllerDelegate {
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        if let collectionView = collectionView {
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
            
            // If cell for selected index path is not visible
            if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
                // Scroll to make cell visible
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    
    func simplePhotoViewerController(_ viewController: SimplePhotoViewerController, savePhotoAt index: Int) {
        UIImageWriteToSavedPhotosAlbum(images[index], nil, nil, nil)
    }
}

/// Class CollectionViewCell
/// Add extra UI element to photo.
public class CollectionViewCell: UICollectionViewCell {
    public private(set) var imageView: UIImageView!
    
    var delegate: DTPhotoCollectionViewCellDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        backgroundColor = UIColor.white
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let margin = CGFloat(5)
        imageView.frame = CGRect(x: margin, y: margin, width: bounds.size.width - 2*margin, height: bounds.size.height - 2*margin)
    }
}

