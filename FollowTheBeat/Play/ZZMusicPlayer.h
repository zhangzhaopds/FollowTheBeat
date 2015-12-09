//
//  ZZMusicPlayer.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface ZZMusicPlayer : NSObject

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isSingleModel;

@property (nonatomic, strong) NSString *currentUrl;

@property (nonatomic, strong) NSMutableArray *playList;
@property (nonatomic, strong) NSMutableArray *singerList;
@property (nonatomic, strong) NSMutableDictionary *songsDictionary;
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) NSInteger indexOfItemInArr;
@property (nonatomic, assign) NSInteger index;

+ (ZZMusicPlayer *)shareMusicPlayer;

- (void)setMusicURLString:(NSString *)urlString;

- (void)play;
- (void)pause;
- (void)stop;


// 从指定时间开始播放
// time 时间

- (void)seekToTime:(CGFloat)time;


@end
