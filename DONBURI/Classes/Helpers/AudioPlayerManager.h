//
//  DemoPepper
//
//  Created by 株式会社OA推進センター on 2016/10/27.
//  Copyright © 2016年 OA-Promotion-Center. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class AudioPlayerManager;
@protocol AudioPlayerManagerDelegate <NSObject>
@end

@interface AudioPlayerManager : NSObject <AVAudioPlayerDelegate>
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSString *audioFileName;
@property (strong, nonatomic) id <AudioPlayerManagerDelegate> audioPlayerDelegate;
- (void)stopPlay;
- (void)playAudioMenu:(NSString *)fileName inPathType:(PathType)pathType;
- (void)playAudioMenuNoLoop:(NSString *)fileName inPathType:(PathType)pathType;
- (BOOL)isPlaying;
@end
