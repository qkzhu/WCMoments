# Uncomment this line to define a global platform for your project
# platform :ios, '7.0'
# Uncomment this line if you're using Swift
# use_frameworks!

def shared_pods
    pod 'AFNetworking', '~>3.0'
end

target 'WCMoments' do
   shared_pods
end

target 'WCMomentsTests' do
   shared_pods
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

