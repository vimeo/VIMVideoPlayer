# VIMVideoPlayer

`VIMVideoPlayer` is a simple wrapper around the [`AVPlayer`](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVPlayer_Class/index.html) and [`AVPlayerLayer`](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVPlayerLayer_Class/index.html#//apple_ref/occ/cl/AVPlayerLayer) classes. 

## Setup

Add the `VIMVideoPlayerView` and `VIMVideoPlayer` classes to your project. 

Do this by including this repo as a git submodule or by using cocoapods:

```Ruby
# Add this to your podfile
target 'MyTarget' do
	pod 'VIMVideoPlayer', ‘{version_number}’
end
```

## Usage

Create a new `VIMVideoPlayerView` and add it to your view hierarchy:

```Objective-c
#import "VIMVideoPlayerView.h"

...

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.videoPlayerView = [[VIMVideoPlayerView alloc] init];
    self.videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoPlayerView.delegate = self;

    [self.videoPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [self.videoPlayerView.player enableTimeUpdates];
    [self.videoPlayerView.player enableAirplay];

    [self.view addSubview:self.videoPlayerView];

    NSDictionary *views = NSDictionaryOfVariableBindings(_videoPlayerView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_videoPlayerView]-0-|" options:0   metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_videoPlayerView]-0-|" options:0   metrics:nil views:views]];
}

```

Play a video:

```Objective-c
// Using an NSURL

NSURL *URL = ...; 
[self.videoPlayerView.player setURL:URL];
[self.videoPlayerView.player play];

/* 
  Note: This must be a URL to an actual video resource (e.g. http://website.com/video.mp4 or .m3u8 etc.),
  It cannot be a URL to a web page (e.g. https://vimeo.com/67069182),
  See below for info on using VIMVideoPlayer to play Vimeo videos.
*/

// Using an AVPlayerItem

AVPlayerItem *playerItem = ...;
[self.videoPlayerView.player setPlayerItem:playerItem];
[self.videoPlayerView.player play];

// Or using an AVAsset

AVAsset *asset = ...;
[self.videoPlayerView.player setAsset:asset];
[self.videoPlayerView.player play];

```

Optionally implement the `VIMVideoPlayerViewDelegate` protocol methods:

```Objective-c
@protocol VIMVideoPlayerViewDelegate <NSObject>

@optional
- (void)videoPlayerViewIsReadyToPlayVideo:(VIMVideoPlayerView *)videoPlayerView;
- (void)videoPlayerViewDidReachEnd:(VIMVideoPlayerView *)videoPlayerView;
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime;
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration;
- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error;

@end
```

See [`VIMVideoPlayer.h`](https://github.com/vimeo/VIMVideoPlayer/blob/master/VIMVideoPlayer/VIMVideoPlayer.h) for additional configuration options. 

## Playing Vimeo Videos

[Vimeo Pro](https://vimeo.com/pro) members can access playback URLs for Vimeo videos using the [Vimeo API](https://developer.vimeo.com/). Playback URLs are only included in the response object if the requesting account is a [Vimeo Pro](https://vimeo.com/pro) account.

If you have a [Vimeo Pro](https://vimeo.com/pro) account, when you make a request to the [Vimeo API](https://developer.vimeo.com/) for a video object the response object will contain a list of video `files`. These represent the various resolution video files available for this particular video. Each has a `link`. You can use the string value keyed to `link` to create an NSURL. You can pass this NSURL to VIMVideoPlayer for playback.

Check out [this](http://stackoverflow.com/questions/31960338/ios-vimvideoplayerview-cant-load-vimeo-videos) Stack Overflow question for additional info.

You can use the [Vimeo iOS SDK](https://github.com/vimeo/VIMNetworking) to interact with the [Vimeo API](https://developer.vimeo.com/). 

For full documentation on the Vimeo API go [here](https://developer.vimeo.com/).

## License

`VIMVideoPlayer` is available under the MIT license. See the LICENSE file for more info.

## Questions?

Tweet at us here: @vimeoapi

Post on [Stackoverflow](http://stackoverflow.com/questions/tagged/vimeo-ios) with the tag `vimeo-ios`

Get in touch [here](https://vimeo.com/help/contact)
