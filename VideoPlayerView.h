//
//  VideoPlayerView.h
//  Smokescreen
//
//  Created by Alfred Hanssen on 2/9/14.
//  Copyright (c) 2014 Vimeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class VideoPlayer;
@class VideoPlayerView;

@protocol VideoPlayerViewDelegate <NSObject>

@optional

- (void)videoPlayerViewIsReadyToPlayVideo:(VideoPlayerView *)videoPlayerView;
- (void)videoPlayerViewDidReachEnd:(VideoPlayerView *)videoPlayerView;
- (void)videoPlayerView:(VideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime;
- (void)videoPlayerView:(VideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration;
- (void)videoPlayerView:(VideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error;

@end

@interface VideoPlayerView : UIView

@property (nonatomic, weak) id<VideoPlayerViewDelegate> delegate;

@property (nonatomic, strong) VideoPlayer *player;

- (void)setVideoFillMode:(NSString *)fillMode;

@end
