# Uncomment this line to define a global platform for your project
# platform :ios, '7.0'
# Uncomment this line if you're using Swift
# use_frameworks!

target 'WCMoments' do
    pod 'AFNetworking', '~> 3.0'
end

post_install do |installer|
    
    installer.pods_project.targets.each do |target|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
        
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

