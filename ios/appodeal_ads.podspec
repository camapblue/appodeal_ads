#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appodeal_ads.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appodeal_ads'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resource_bundles = {"AppodealBundle" => ["Assets/*"] }
  s.dependency 'Flutter'
  s.dependency 'Appodeal'
  s.dependency 'StackConsentManager'
  s.dependency 'HCSStarRatingView'
  s.static_framework = true
  s.ios.deployment_target = '10.2'
end
