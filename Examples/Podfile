# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
    
    # Reactive
    pod 'RxSwift', '~> 4.3'
    pod 'Action', '~> 3.8'
    pod 'RxSwiftExt', '~> 3.3'
    pod 'RxOptional', '~> 3.5'
    pod 'RxDataSources', '~> 3.1'
    
    # Style and conventions
    pod 'SwiftLint', '~> 0.27'

    pod 'R.swift', '~> 5.0.0.alpha.2'

    pod 'DateToolsSwift', '~> 4.0'
end

def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'RxBlocking', '~> 4.3'
    pod 'RxTest',     '~> 4.3'
end

target 'Boilerplate' do
    use_frameworks!
    inhibit_all_warnings!

    shared_pods
    pod 'PINRemoteImage/PINCache', '=3.0.0-beta.13'
    pod 'HyperioniOS/Core', :configurations => ['Debug']

    #"Configurations => Debug" ensures it is only included in debug builds. Add any configurations you would like Hyperion to be included in.
    pod 'HyperioniOS/AttributesInspector', :configurations => ['Debug'] # Optional plugin
    pod 'HyperioniOS/Measurements', :configurations => ['Debug'] # Optional plugin
    pod 'HyperioniOS/SlowAnimations', :configurations => ['Debug'] # Optional plugin

    pod 'Moya/RxSwift', '~> 11.0'
    pod 'ObjectMapper', '~> 3.3'
    pod 'Moya-ObjectMapper/RxSwift', '~> 2.7'
    pod 'ReachabilitySwift', '~> 4.2'
    pod 'KeychainAccess'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'RxSwift'
                target.build_configurations.each do |config|
                    if config.name == 'Debug'
                        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                    end
                end
            end
        end
    end
    target 'BoilerplateTests' do
        inherit! :search_paths
        # Pods for testing
        testing_pods
    end
end


