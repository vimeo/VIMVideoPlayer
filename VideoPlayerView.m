//
//  VideoPlayerView.m
//  Smokescreen
//
//  Created by Alfred Hanssen on 2/9/14.
//  Copyright (c) 2014 Vimeo. All rights reserved.
//

#import "VideoPlayerView.h"
#import "VideoPlayer.h"

#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerView () <VideoPlayerDelegate>

@end

@implementation VideoPlayerView

- (void)dealloc
{
    [self detachPlayer];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _player = [[VideoPlayer alloc] init];
        _player.muted = YES;
        _player.looping = YES;
        
        [self attachPlayer];
    }
    
    return self;
}

#pragma mark - Public API

- (void)setPlayer:(VideoPlayer *)player
{
    if (_player == player)
    {
        return;
    }

    [self detachPlayer];
    
    _player = player;
    
    [self attachPlayer];
}

- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}

#pragma mark - Private API

- (void)attachPlayer
{
    if (_player)
    {
        _player.delegate = self;
        
        [(AVPlayerLayer *)[self layer] setPlayer:_player.player];
    }
}

- (void)detachPlayer
{
    if (_player && _player.delegate == self)
    {
        _player.delegate = nil;
    }
    
    [(AVPlayerLayer *)[self layer] setPlayer:nil];
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

#pragma mark - VideoPlayerDelegate

- (void)videoPlayerIsReadyToPlayVideo:(VideoPlayer *)videoPlayer
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewIsReadyToPlayVideo:)])
    {
        [self.delegate videoPlayerViewIsReadyToPlayVideo:self];
    }
}

- (void)videoPlayerDidReachEnd:(VideoPlayer *)videoPlayer
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewDidReachEnd:)])
    {
        [self.delegate videoPlayerViewDidReachEnd:self];
    }
}

- (void)videoPlayer:(VideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:timeDidChange:)])
    {
        [self.delegate videoPlayerView:self timeDidChange:cmTime];
    }
}

- (void)videoPlayer:(VideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:loadedTimeRangeDidChange:)])
    {
        [self.delegate videoPlayerView:self loadedTimeRangeDidChange:duration];
    }
}

- (void)videoPlayer:(VideoPlayer *)videoPlayer didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(videoPlayerView:didFailWithError:)])
    {
        [self.delegate videoPlayerView:self didFailWithError:error];
    }
}

@end
