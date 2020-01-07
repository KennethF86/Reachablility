Pod::Spec.new do |s|
  s.name           = 'Reachablility'
  s.version        = '1.0.4'
  s.summary        = 'A small framework to monitor network changes in Swift.'
  s.homepage       = 'http://www.mustache.dk'
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { 'Kenneth Frandsen' => 'Kf@mustache.dk' }
  s.source         = { :git => 'https://github.com/KennethF86/Reachablility.git', :tag => s.version.to_s }
  s.swift_version  = '5.0'
  s.platform     = :ios, "11.0"

  s.source_files   = 'Reachablility/*.swift'

  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration'
end