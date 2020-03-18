#
# Be sure to run `pod lib lint ProtocolOrientedNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ProtocolOrientedNetworking'
s.version          = '0.2.0'
s.summary          = 'This is a simple test for an approach to Protocol Oriented Networking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
This project is intended to provide a proof of concept for a Data Access Layer focused on Network requests, using Protocol Oriented concepts
DESC

s.homepage         = 'https://github.com/pmlbrito/ProtocolOrientedNetworking'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Pedro Brito' => 'pedroml.brito@gmail.com' }
s.source           = { :git => 'https://github.com/pmlbrito/ProtocolOrientedNetworking.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/pedromlbrito'

s.ios.deployment_target = '8.0'

s.source_files = 'ProtocolOrientedNetworking/Sources/**/*'
s.resources = 'ProtocolOrientedNetworking/Assets/**/*'

# s.resource_bundles = {
#   'ProtocolOrientedNetworking' => ['ProtocolOrientedNetworking/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'Foundation'
# s.dependency 'AFNetworking', '~> 2.3'
end
