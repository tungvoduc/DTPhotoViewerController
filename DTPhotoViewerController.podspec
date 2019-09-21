Pod::Spec.new do |s|
  s.name             = "DTPhotoViewerController"
  s.version          = "3.1.0"
  s.summary          = "DTPhotoViewerController provides a Facebook-like photo viewer."
  s.platform 	       = :ios, '10.0'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
DTPhotoViewerController gives you a Facebook-like photo viewer with similar transition between your view controller and the photo viewer controller. You can create more sophisticated photo viewer by subclassing DTPhotoViewerController.
DESC
  s.homepage         = "https://github.com/tungvoduc/DTPhotoViewerController"
  s.license          = 'MIT'
  s.author           = { "Tung Vo" => "tung98.dn@gmail.com" }
  s.source           = { :git => "https://github.com/tungvoduc/DTPhotoViewerController.git", :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'DTPhotoViewerController/Classes/**/*'
end
