# Be sure to run `pod lib lint QGGImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|


  s.name         = "MyTestCocoaPods"
  s.version      = "0.0.2"
  s.summary      = "play with cocoaPods"

  s.description  = <<-DESC
                    I play with cocoaPods where this one project
                   DESC

  s.homepage     = "https://github.com/sugerGDev/myTestCocoaPods"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "suger" => "gjw_2007@163.com" }

  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/sugerGDev/myTestCocoaPods.git", :tag => s.version.to_s }


  s.source_files  = "MyTestCocoaPods/MyObject/**/*.{h,m}"

  s.public_header_files = "MyTestCocoaPods/MyObject/**/*.h"

  s.requires_arc = true


  s.frameworks = "UIKit", "Foundation"

 #s.dependency 'Masonry', '~> 0.6.3'


end