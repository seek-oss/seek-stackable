Pod::Spec.new do |s|
  s.name         = 'Stackable'
  s.version      = '0.4.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'iOS framework for laying out nested views vertically and horizontally'
  
  s.homepage     = 'https://github.com/seek-oss/seek-stackable'
  s.author       = 'SEEK'
  
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/seek-oss/seek-stackable.git', :tag => s.version }
  s.source_files  = 'stackable/**/*.swift'
  s.frameworks   = 'UIKit'
  s.requires_arc = true
end
