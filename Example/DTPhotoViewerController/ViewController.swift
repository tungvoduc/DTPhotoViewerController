//
//  ViewController.swift
//  DTPhotoViewerController
//
//  Created by Tung Vo on 05/07/2016.
//  Copyright (c) 2016 Tung Vo. All rights reserved.
//

import DTPhotoViewerController
import UIKit

private let kCollectionViewCellIdentifier = "Cell"
private let kNumberOfRows: Int = 3
private let kRowSpacing: CGFloat = 5
private let kColumnSpacing: CGFloat = 5

/// Class CollectionViewCell
/// Add extra UI element to photo.
public class CollectionViewCell: UICollectionViewCell {
    public private(set) var imageView: UIImageView!

    weak var delegate: DTPhotoCollectionViewCellDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        imageView = UIImageView(frame: CGRect.zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.white
        contentView.addSubview(imageView)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        let margin = CGFloat(5)
        imageView.frame = CGRect(x: margin, y: margin, width: bounds.size.width - 2 * margin, height: bounds.size.height - 2 * margin)
    }
}

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

        for index in 0...9 {
            //swiftlint:disable force_unwrapping
            images.append(UIImage(named: "mario\(index % 5 + 1)")!)
        }

        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: kCollectionViewCellIdentifier)

        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        title = "Example"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        collectionViewLayout.invalidateLayout()
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
        let itemSize = floor(width / CGFloat(kNumberOfRows))
        return CGSize(width: itemSize, height: itemSize)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageIndex = indexPath.row

        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            let viewController = SimplePhotoViewerController(referencedView: cell.imageView, image: cell.imageView.image)
            viewController.dataSource = self
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: DTPhotoViewerControllerDataSource
extension ViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        // Set text for each item
        if let cell = cell as? CustomPhotoCollectionViewCell {
            cell.extraLabel.text = "Image no \(index + 1)"
        }
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
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

// MARK: DTPhotoViewerControllerDelegate
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
