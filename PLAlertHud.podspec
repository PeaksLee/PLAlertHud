#
# Be sure to run `pod lib lint PLAlertHud.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PLAlertHud'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PLAlertHud.'
  s.description      = <<-DESC
                        自定义弹框
                       DESC
  s.homepage         = 'https://github.com/PeaksLee/PLAlertHud.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PeaksLee' => '530044053@qq.com' }
  s.source           = { :git => 'https://github.com/PeaksLee/PLAlertHud.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'PLAlertHud/Classes/**/*'
  
   s.resource_bundles = {
     'PLAlertHud' => ['PLAlertHud/Assets/**/*']
   }

end
