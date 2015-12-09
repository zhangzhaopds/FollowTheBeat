//
//  ZZMusicPlayer.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMusicPlayer.h"

@interface ZZMusicPlayer ()

@property (nonatomic, assign) NSInteger songsCount;

@end

@implementation ZZMusicPlayer

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification];
}

+ (ZZMusicPlayer *)shareMusicPlayer {
    
    static ZZMusicPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[ZZMusicPlayer alloc] init];
        player.playList = [NSMutableArray array];
        player.indexOfItemInArr = 0;
       
    });
    return player;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        // 注册通知,  当音乐播放完成的时候, 执行方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeEndAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleModel:) name:@"singleSong" object:nil];
    }
    return self;
}

- (void)singleModel:(NSNotification *)noti {
    self.isSingleModel = [[noti.userInfo objectForKey:@"key"] integerValue];
    
}

- (void)timeEndAction {
    
    if (!self.playList.count) {
        return;
    }
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
   
    // 创建Item对象
    if (!self.isSingleModel) {
        self.indexOfItemInArr ++;
        if (self.indexOfItemInArr == self.playList.count) {
            self.indexOfItemInArr = 0;
        }
    }
    
    NSDictionary *dic = [self.playList objectAtIndex:self.indexOfItemInArr];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[dic objectForKey:@"songUrl"]]];
 
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    self.playerItem = item;
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentIndex" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentIndexIn" object:nil];
    
}


- (AVPlayer *)player {
    
    if (!_player) {
        self.player = [AVPlayer new];
        self.player.volume = 0.5;
    }
    
    return _player;
    
}

- (void)playingAction:(NSTimer *)timer {
    
    self.progress = 1.0 * self.player.currentTime.value / self.player.currentTime.timescale;
    
    CGFloat totalSeconds = CMTimeGetSeconds(self.player.currentItem.duration);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pro" object:nil userInfo:@{@"progress": [NSString stringWithFormat:@"%f", self.progress], @"totalSeconds": [NSString stringWithFormat:@"%f", totalSeconds]}];
}

- (BOOL)isPlaying {
    
    return _isPlaying;
}

- (void)setMusicURLString:(NSString *)urlString {
    
    if (!urlString) {
        return;
    }
    if (_currentUrl == nil) {
        _currentUrl = urlString;
    }
    
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    [self.player replaceCurrentItemWithPlayerItem:item];
    self.playerItem = item;
//    CMTime tim = self.playerItem.duration;
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentIndex" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentIndexIn" object:nil];
 }


- (void)play {
    
    if (!_isReady) {
        return;
    }
    
    [self.player play];
    
    _isPlaying = YES;
    
    // 更新进度
    // 设置定时器
    
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pause {
    
    if (!_isPlaying) {
        return;
    }
    [self.player pause];
    
    _isPlaying = NO;
    
    
    // 暂停 停止定时
    // 使timer无效
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)stop {
    
    
    if (!_isPlaying) {
        return;
    }
    
    [self.player pause];
    
    // 播放时间  设置到0秒
    [self.player seekToTime:CMTimeMake(0, self.player.currentTime.timescale)];
    _isPlaying = NO;
}


- (void)seekToTime:(CGFloat)time {
    
    [self pause];
    
    // 设置时间开始播放
    
    // 参数1：当前时间   每秒多少帧 CMTime
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        
        if (finished) {
            _isPlaying = YES;
            [self play];
        }
    }];
}


- (CGFloat)volume {
    
    return self.player.volume;
}


- (void)setVolume:(CGFloat)volume {
    
    self.player.volume = volume;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:{
                
                // 准备好了  可以播放  直接播放
                _isReady = YES;
                [self play];
                break;
            }
            case AVPlayerItemStatusFailed:{
                
                _isReady = NO;
                break;
            }
            case AVPlayerItemStatusUnknown: {
                
                _isReady = NO;
                break;
            }
        }
    }
}





@end
