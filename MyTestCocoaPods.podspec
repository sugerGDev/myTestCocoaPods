
Pod::Spec.new do |s|


  s.name         = "MyTestCocoaPods"
  s.version      = "0.0.1"
  s.summary      = "play with cocoaPods"

  s.description  = <<-DESC
                      play with cocoaPods 
                   DESC

  s.homepage     = "https://github.com/sugerGDev/myTestCocoaPods"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "suger" => "gjw_2007@163.com" }


  s.platform     = :ios

  s.source       = { :git => "https://github.com/sugerGDev/myTestCocoaPods.git", :tag => "0.0.1" }


  s.source_files  = "MyObject", "MyTestCocoaPods/MyObject/**/*.{h,m}"

  s.public_header_files = "MyTestCocoaPods/MyCocoaPodsHeader.h","MyTestCocoaPods/MyObject/**/*.h"

  s.requires_arc = true


end