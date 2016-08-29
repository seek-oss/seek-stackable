Pod::Spec.new do |s|
  s.name         = 'stackable'
  s.version      = '0.1.4'
  s.license      = { :type => 'MIT, :file => 'LICENSE' }
  s.summary      = 'iOS framework for laying out nested views vertically and horizontally'
  
  s.homepage     = 'https://github.com/SEEK-Jobs/seek-stackable'
  s.author       = 'SEEK'
  
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/SEEK-Jobs/seek-stackable.git', :tag => s.version }
  s.source_files  = 'stackable/Classes/*.swift'
  s.frameworks   = 'UIKit'
end
