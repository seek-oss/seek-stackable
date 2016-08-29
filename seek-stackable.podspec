Pod::Spec.new do |s|
  s.name         = "seek-stackable"
  s.version      = "0.1.0"
  s.summary      = "iOS framework for laying out nested views vertically and horizontally"
  s.homepage     = "https://github.com/SEEK-Jobs/seek-stackable"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "SEEK" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/SEEK-Jobs/seek-stackable.git", :tag => s.version }
  s.source_files  = "Classes", "Classes/**/*.{h,swift}"
  s.public_header_files = "Classes/**/*.h"
end
