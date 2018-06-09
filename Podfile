source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'YoutubeSearcher' do
  # Pods for YoutubeSearcher
  pod 'ImageLoader'
  pod 'Reachability'
  #pod "youtube-ios-player-helper", "~> 0.1.4"
  pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'

  target 'YoutubeSearcherTests' do
    inherit! :search_paths
    pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
    # Pods for testing
  end

  target 'YoutubeSearcherUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
