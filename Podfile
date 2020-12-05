# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MoneyManageApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MoneyManageApp

  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'PKHUD', '~> 5.0'
  pod 'Google-Mobile-Ads-SDK'
  pod 'EmptyDataSet-Swift'
  pod 'Parchment'
  pod 'RAMAnimatedTabBarController'
  pod 'FSCalendar'
  pod 'CalculateCalendarLogic'
  pod 'RealmSwift'
  pod 'TextFieldEffects'
  pod 'Charts'
  pod 'SwiftEntryKit', '1.2.6'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end

  target 'MoneyManageAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MoneyManageAppUITests' do
    # Pods for testing
  end

end
