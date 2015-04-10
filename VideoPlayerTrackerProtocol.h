//
//  VideoPlayerTrackerProtocol.h
//  Smokescreen
//
//  Created by Hanssen, Alfie on 11/14/14.
//  Copyright (c) 2014 Vimeo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VideoPlayerTracker <NSObject>

@required

- (void)startSessionWithSessionID:(NSString *)sessionID;
- (void)playerDidPlay;
- (void)playerDidPause;
- (void)playerDidFinishPlaying;

@end

