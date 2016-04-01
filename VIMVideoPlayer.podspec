#
#  Be sure to run `pod spec lint VIMVideoPlayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "VIMVideoPlayer"
  s.version      = "6.0.1"
  s.summary      = "A simple wrapper around the AVPlayer and AVPlayerLayer classes."
  s.description  = <<-DESC
                   VIMVideoPlayer is a simple wrapper around the AVPlayer and AVPlayerLayer classes. Check out the README for details. And the Pegasus project for a demo.
                   DESC

  s.homepage     = "https://github.com/vimeo/VIMVideoPlayer"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.authors            = { "Alfie Hanssen" => "alfiehanssen@gmail.com",
                            "Rob Huebner" => "robh@vimeo.com",
                            "Gavin King" => "gavin@vimeo.com",
                            "Kashif Muhammad" => "support@vimeo.com",
                            "Andrew Whitcomb" => "support@vimeo.com",
                            "Stephen Fredieu" => "support@vimeo.com",
                            "Rahul Kumar" => "support@vimeo.com" }

  s.social_media_url   = "http://twitter.com/vimeoapi"

  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/vimeo/VIMVideoPlayer.git", :tag => s.version.to_s }
  s.source_files  = "VIMVideoPlayer-Source/**/*.{h,m}"

  s.requires_arc = true

end