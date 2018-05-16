//
//  DemoPepper
//
//  Created by 株式会社OA推進センター on 2016/10/27.
//  Copyright © 2016年 OA-Promotion-Center. All rights reserved.
//

#import "AudioPlayerManager.h"

@implementation AudioPlayerManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [self.audioPlayer release];
    self.audioPlayer = nil;
    [super dealloc];
}
- (void)playAudioMenuNoLoop:(NSString *)fileName inPathType:(PathType)pathType
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[FileUtil pathForPathType:pathType], fileName]];
    NSError *error;
    self.audioFileName = fileName;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    if (self.audioPlayer) {
        [self.audioPlayer play];
    }
    else  NSLog(@"Audio Error: %@ at URL: %@",[error description],url);
}
- (void)playAudioMenu:(NSString *)fileName inPathType:(PathType)pathType
{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[FileUtil pathForPathType:pathType], fileName]];
    NSError *error;
    self.audioFileName = fileName;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    self.audioPlayer.numberOfLoops = -1;
    if (self.audioPlayer) {
        [self.audioPlayer play];
    }
    else  NSLog(@"Audio Error: %@ at URL: %@",[error description],url);
}

- (void)stopPlay
{
    if (self.audioPlayer && self.audioPlayer.playing) {
        [self.audioPlayer stop];
    }
}
- (BOOL)isPlaying
{
    if (self.audioPlayer && self.audioPlayer.playing) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -
#pragma mark AVAudioPlayer delegate
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) appSoundPlayer successfully: (BOOL) flag {
}
- (void) audioPlayerBeginInterruption: player {
}

- (void) audioPlayerEndInterruption: player {
}
@end

