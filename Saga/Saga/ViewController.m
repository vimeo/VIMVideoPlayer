//
//  ViewController.m
//  Saga
//
//  Created by Alfred Hanssen on 4/2/15.
//  Copyright (c) 2015 Alfie Hanssen. All rights reserved.
//

#import "ViewController.h"
#import "VIMVideoPlayerView.h"
#import "VIMVideoPlayer.h"

static NSString *const YosemiteVideoURLString = @"https://secure-c.vimeocdn.com/p/video/yosemite_hd_ii_hd.mp4";

@interface ViewController () <VIMVideoPlayerViewDelegate>

@property (nonatomic, strong) VIMVideoPlayerView *videoPlayerView;

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UISlider *playerScrubber;
@property (nonatomic, weak) IBOutlet UILabel *playerTimeLabel;

@property (nonatomic, strong) UISlider *playerBufferSlider;

@property (nonatomic, assign) BOOL isScrubbing;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupVideoPlayer];
    [self setupPlayerUI];
    
    [self requestPlayback];
}

#pragma mark - Setup

- (void)setupVideoPlayer
{
    self.videoPlayerView = [[VIMVideoPlayerView alloc] init];
    self.videoPlayerView.player.muted = NO;
    self.videoPlayerView.player.looping = NO;
    self.videoPlayerView.player.player.volume = 1.0f;
    self.videoPlayerView.delegate = self;
    self.videoPlayerView.backgroundColor = [UIColor clearColor];
    self.videoPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.videoPlayerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [self.videoPlayerView.player enableTimeUpdates];
    
    [self.view insertSubview:self.videoPlayerView atIndex:0];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_videoPlayerView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_videoPlayerView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_videoPlayerView]-0-|" options:0 metrics:nil views:views]];
}

- (void)setupPlayerUI
{
    // Init Slider UI
    
    UIImage *minImage = [UIImage imageNamed:@"player-track-progress.png"];
    [self.playerScrubber setMinimumTrackImage:minImage forState:UIControlStateNormal];
    
    UIImage *maxImage = [UIImage imageNamed:@"player-track-outline.png"];
    maxImage = [maxImage resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.playerScrubber setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    
    UIImage *thumbImage= [UIImage imageNamed:@"HandleIcon.png"];
    [self.playerScrubber setThumbImage:thumbImage forState:UIControlStateNormal];
    
    // Init buffer slider
    
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 10 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *bufferImage = [UIImage imageNamed:@"player-track-buffer.png"];
    //bufferImage = [bufferImage stretchableImageWithLeftCapWidth:100.0f topCapHeight:0];
    
    self.playerBufferSlider = [[UISlider alloc] initWithFrame:self.playerScrubber.bounds];
    [self.playerBufferSlider setValue:0.0f];
    [self.playerBufferSlider setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.playerBufferSlider.translatesAutoresizingMaskIntoConstraints = YES;
    [self.playerScrubber addSubview:self.playerBufferSlider];
    [self.playerScrubber sendSubviewToBack:self.playerBufferSlider];
    
    self.playerBufferSlider.userInteractionEnabled = NO;
    
    [self.playerBufferSlider setMinimumTrackImage:bufferImage forState:UIControlStateNormal];
    [self.playerBufferSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.playerBufferSlider setThumbImage:transparentImage forState:UIControlStateNormal];
}

#pragma mark - Private API

- (void)requestPlayback
{
    NSURL *URL = [NSURL URLWithString:YosemiteVideoURLString];

    [self.videoPlayerView.player setURL:URL];
    
    [self.videoPlayerView.player play];
    
    [self updatePlayUI];
}

- (void)updatePlayUI
{
    [self updateScrubberTime];
    
    [self.playButton setSelected:self.videoPlayerView.player.isPlaying];
}

- (void)updateScrubberTime
{
    if (self.isScrubbing)
    {
        return;
    }
    
    float currentTime = 0.0f;
    if (CMTIME_IS_INVALID(self.videoPlayerView.player.player.currentTime) == NO)
    {
        currentTime = CMTimeGetSeconds(self.videoPlayerView.player.player.currentTime);
    }
    
    float videoDuration = 0.0f;
    if (self.videoPlayerView.player.player.currentItem)
    {
        videoDuration = CMTimeGetSeconds(self.videoPlayerView.player.player.currentItem.duration);
    }
    
    if (videoDuration > 0.0f)
    {
        double progress = currentTime / videoDuration;
        [self.playerScrubber setValue:progress animated:YES];
        
        int timeRemaining = videoDuration - currentTime;
        self.playerTimeLabel.text = [self stringFromDurationInSeconds:timeRemaining];
    }
    else
    {
        [self.playerScrubber setValue:0.0f animated:YES];
        self.playerTimeLabel.text = [self stringFromDurationInSeconds:0];
    }
}
#pragma mark - Actions

- (IBAction)didTapPlay:(id)sender
{
    if ([self.videoPlayerView.player isPlaying])
    {
        [self.videoPlayerView.player pause];
    }
    else
    {
        [self.videoPlayerView.player play];
    }

    [self updatePlayUI];
}

- (IBAction)scrubberSliderDidStartScrubbing:(UISlider *)sender
{
    self.isScrubbing = YES;
}

- (IBAction)scrubberSliderValueDidChange:(UISlider *)sender
{
    float videoDuration = 0.0f;
    if (self.videoPlayerView.player.player.currentItem)
    {
        videoDuration = CMTimeGetSeconds(self.videoPlayerView.player.player.currentItem.duration);
    }

    float time = self.playerScrubber.value * videoDuration;
    
    [self.videoPlayerView.player scrub:time];
}

- (IBAction)scrubberSliderDidStopScrubbing:(UISlider *)sender
{
    self.isScrubbing = NO;
    
    [self.videoPlayerView.player stopScrubbing];
}

#pragma mark - VideoPlayerView Delegate

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime
{
    [self updateScrubberTime];
}

- (void)videoPlayerViewDidReachEnd:(VIMVideoPlayerView *)videoPlayerView
{
    [self updatePlayUI];
}

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)loadedDuration
{
    float videoDuration = 0.0f;
    if (self.videoPlayerView.player.player.currentItem)
    {
        videoDuration = CMTimeGetSeconds(self.videoPlayerView.player.player.currentItem.duration);
    }
    
    if (videoDuration > 0.0f)
    {
        double progress = loadedDuration / videoDuration;
        [self.playerBufferSlider setValue:progress animated:YES];
    }
    else
    {
        [self.playerBufferSlider setValue:0.0f animated:YES];
    }
}

- (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error
{
    NSLog(@"videoPlayerView:didFailWithError: %@", error);

    [self.videoPlayerView.player reset];
    
    [self updatePlayUI];
}

#pragma mark - Utilities

- (NSString *)stringFromDurationInSeconds:(int)duration
{
    int secondsPerHour = 60 * 60;
    int secondsPerMinute = 60;
    
    int hours = duration / secondsPerHour;
    int seconds = duration % secondsPerMinute;
    int minutes = ((duration % secondsPerHour) - seconds) / secondsPerMinute;
    
    NSString *hoursString = nil;
    if (hours < 10) {
        hoursString = [NSString stringWithFormat:@"0%d", hours];
    } else {
        hoursString = [NSString stringWithFormat:@"%d", hours];
    }
    
    NSString *minutesString = nil;
    if (minutes < 10) {
        minutesString = [NSString stringWithFormat:@"0%d", minutes];
    } else {
        minutesString = [NSString stringWithFormat:@"%d", minutes];
    }
    
    NSString *secondsString = nil;
    if (seconds < 10) {
        secondsString = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        secondsString = [NSString stringWithFormat:@"%d", seconds];
    }
    
    NSString *durationString = [NSString stringWithFormat:@"%@:%@", minutesString, secondsString];
    if (hours > 0) {
        durationString = [NSString stringWithFormat:@"%@:%@", hoursString, durationString];
    }
    
    return durationString;
}

@end
