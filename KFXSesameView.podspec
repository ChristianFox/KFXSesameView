#
# Be sure to run `pod lib lint KFXSesameView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KFXSesameView'
  s.version          = '0.5.0'
  s.summary          = 'KFXSesameView - hidden keypad for unlocking hidden doors.'

  s.description      = <<-DESC
Open Sesame!

The basic idea is to have a hidden keypad in your app that can be used to unlock a secret part area for example a debug mode or an easter egg. Provides a single class: KFXSesameView which contains a UICollectionView. The collection view is used to layout a grid of cells and each cell can be added to a sequence of taps. Tap all in the seqence within a time limit and get a delegate callback. Then you can present a new view controller or do whatever you want.
                       DESC

  s.homepage         = 'https://kfxtech@bitbucket.org/kfxteam/kfxsesameview.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Fox' => 'christianfox890@icloud.com' }
  s.source           = { :git => 'https://kfxtech@bitbucket.org/kfxteam/kfxsesameview.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'KFXSesameView/Classes/**/*'
  
end
