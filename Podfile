platform :ios, '9.0'
use_frameworks!

def common_pods_for_target

pod 'RxSwift', '~> 3.0'
pod 'RxCocoa', '~> 3.0'
pod 'ObjectMapper'
pod 'Alamofire'
pod 'AlamofireImage'

end

target 'KonradZdunczyk_elpassion' do

common_pods_for_target

end

target 'KonradZdunczyk_elpassionTests' do

common_pods_for_target

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
