// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DTPhotoViewerController",
    products: [
        .library(name: "DTPhotoViewerController", targets: ["DTPhotoViewerController"]),
    ],
    targets: [
        .target(
            name: "DTPhotoViewerController",
            path: "DTPhotoViewerController/Classes"),
    ]
)
