//
//  VideoPlayer.h
//  Smokescreen
//
//  Created by Alfred Hanssen on 2/9/14.
//  Copyright (c) 2014 Vimeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVPlayer;
@class VideoPlayer;

@protocol VideoPlayerDelegate <NSObject>

@optional

- (void)videoPlayerIsReadyToPlayVideo:(VideoPlayer *)videoPlayer;
- (void)videoPlayerDidReachEnd:(VideoPlayer *)videoPlayer;
- (void)videoPlayer:(VideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime;
- (void)videoPlayer:(VideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration;
- (void)videoPlayer:(VideoPlayer *)videoPlayer didFailWithError:(NSError *)error;

@end

@interface VideoPlayer : NSObject

@property (nonatomic, strong, readonly) AVPlayer *player;

@property (nonatomic, weak) id<VideoPlayerDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isScrubbing;

@property (nonatomic, assign, getter=isLooping) BOOL looping;
@property (nonatomic, assign, getter=isMuted) BOOL muted;


- (void)setURL:(NSURL *)URL;
- (void)setPlayerItem:(AVPlayerItem *)playerItem;
- (void)setAsset:(AVAsset *)asset;

// Playback

- (void)play;
- (void)pause;
- (void)seekToTime:(float)time;
- (void)reset;

// AirPlay

- (void)enableAirplay;
- (void)disableAirplay;
- (BOOL)isAirplayEnabled;

// Time Updates

- (void)enableTimeUpdates; // TODO: need these? no
- (void)disableTimeUpdates;

// Scrubbing

- (void)startScrubbing;
- (void)scrub:(float)time;
- (void)stopScrubbing;

// Volume

- (void)setVolume:(float)volume;
- (void)fadeInVolume;
- (void)fadeOutVolume;

@end
