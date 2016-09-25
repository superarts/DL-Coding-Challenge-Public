source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'WeatherPOV' do
	pod "SAKit", :path => "../LFramework2/"
	pod "SAKit/SAClient", :path => "../LFramework2/"
#	pod "LFramework", :path => "../LFramework2/"
#	pod "LFramework/LClient", :path => "../LFramework2/"
#	pod "LFramework", :git => 'https://github.com/superarts/LSwift.git', :branch => 'refactor/framework'
#	pod "LFramework/LClient", :git => 'https://github.com/superarts/LSwift.git', :branch => 'refactor/framework'

	pod 'iCarousel', '~> 1.8.2'
	pod 'UIImage+animatedGif', '~> 0.1.0'
	pod 'Parse', '~> 1.13.0'
	pod 'MBProgressHUD', '~> 0.9.2'
	pod 'Flurry-iOS-SDK', '~> 7.6.4'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['SWIFT_VERSION'] = '3.0'
		end
	end
end