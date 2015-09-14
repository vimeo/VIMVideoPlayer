# VIMVideoPlayer

`VIMVideoPlayer` is a simple wrapper around the [`AVPlayer`](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVPlayer_Class/index.html) and [`AVPlayerLayer`](https://developer.apple.com/library/prerelease/ios/documentation/AVFoundation/Reference/AVPlayerLayer_Class/index.html#//apple_ref/occ/cl/AVPlayerLayer) classes. Check out the [Pegasus](https://github.com/vimeo/Pegasus) project for a demo. 

## Setup

Add the `VIMVideoPlayerView` and `VIMVideoPlayer` classes to your project. 

Do this by including it as a git submodule or by using cocoapods:

```Ruby
# Add this to your podfile
target 'MyTarget' do
	pod 'VIMVideoPlayer', '5.4.2'
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

See `VIMVideoPlayer.h` for additional configuration options and functionality. 

See the [Pegasus](https://github.com/vimeo/Pegasus) project for an example of how to encapsulate a `VIMVideoPlayerView` instance with playback controls (play/pause/seek/airplay etc).

## License

`VIMVideoPlayer` is available under the MIT license. See the LICENSE file for more info.

## Questions?

Tweet at us here: @vimeoapi

Post on [Stackoverflow](http://stackoverflow.com/questions/tagged/vimeo-ios) with the tag `vimeo-ios`

Get in touch [here](Vimeo.com/help/contact)
