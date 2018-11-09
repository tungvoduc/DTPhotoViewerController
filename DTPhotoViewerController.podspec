#
# Be sure to run `pod lib lint DTPhotoViewerController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DTPhotoViewerController"
  s.version          = "1.2.4"
  s.summary          = "DTPhotoViewerController provides a Facebook-like photo viewer."
  s.platform 	       = :ios, '8.3'
  s.swift_version    = '4.2'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
DTPhotoViewerController gives you a Facebook-like photo viewer with similar transition between your view controller and the photo viewer controller. You can create more sophisticated photo viewer by subclassing DTPhotoViewerController.
DESC
  s.homepage         = "https://github.com/tungvoduc/DTPhotoViewerController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Tung Vo" => "tung98.dn@gmail.com" }
  s.source           = { :git => "https://github.com/tungvoduc/DTPhotoViewerController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.3'

  s.source_files = 'DTPhotoViewerController/Classes/**/*'
 
  # s.resource_bundles = {
  #   'DTPhotoViewerController' => ['DTPhotoViewerController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
end
