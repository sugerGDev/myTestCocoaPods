
Pod::Spec.new do |s|


  s.name         = "MyTestCocoaPods"
  s.version      = "0.0.1"
  s.summary      = “play with cocoaPods”

  s.description  = <<-DESC
                      play with cocoaPods 
                   DESC

  s.homepage     = "https://github.com/sugerGDev/myTestCocoaPods"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { “suger” => “gjw_2007@163.com" }


  s.platform     = :ios

  s.source       = { :git => "https://github.com/sugerGDev/myTestCocoaPods.git", :tag => "0.0.1" }


  s.source_files  = "Classes", "iOS_Category/Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.public_header_files = "iOS_Category/Classes/UIKit/UI_Categories.h","iOS_Category/Classes/Foundation/Foundation_Category.h","iOS_Category/Classes/**/*.h"

  s.requires_arc = true


end