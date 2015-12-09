//
//  ZZMVPlayerVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMVPlayerVC.h"
#import "ZZMVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZMusicPlayer.h"
#import "HTTPTOOL.h"

#import "UIImageView+WebCache.h"

@interface ZZMVPlayerVC ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) ZZMVPlayerView *playerView;
@property (nonatomic, strong) UIView *brightnessView;

@property (nonatomic, strong) UIButton *stateButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) id playbackTimeObserver;
@property (nonatomic, strong) UISlider *videoSlider;
@property (nonatomic, strong) UIProgressView *videoProgress;
@property (nonatomic, strong) UISlider *volumeSlider;

@property (nonatomic, assign) BOOL played;
@property (nonatomic, copy) NSString *totalTime;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL isHide;
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGFloat curMoveAmtX;
@property (nonatomic, assign) CGFloat curMoveAmtY;
@property (nonatomic, strong) UIView *frontOrBack;

@property (nonatomic, strong) UIView *volumeView;

@property (nonatomic, assign) BOOL isSwitch;
@property (nonatomic, assign) BOOL isSingleSong;
@property (nonatomic, strong) UIButton *singleBt;
@end

@implementation ZZMVPlayerVC

- (void)dealloc {
    
    
    [self.playerItem removeObserver:self forKeyPath:@"status" context:@"mv"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:@"mv"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerRate" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        
        
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
        
    }
    
    if ([ZZMusicPlayer shareMusicPlayer].player.rate) {
        [[ZZMusicPlayer shareMusicPlayer].player pause];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.dataArray = [NSMutableArray array];
    
    
    
    
    [self creatUI];
    [self dateFormatter];
}


#pragma mark - 界面
- (void)creatUI {
    //视频界面
    self.playerView = [[ZZMVPlayerView alloc] initWithFrame:CGRectMake((KScreen_Height - KScreen_Width - 100) / 2, 0, KScreen_Width + 100, KScreen_Width)];
    //    self.playerView = [[LPZ_MVPlayerView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Height, KScreen_Width - 40)];
    [self.view addSubview:self.playerView];
    
    self.playerView.backgroundColor = [UIColor blackColor];
    self.playerView.userInteractionEnabled = YES;
    self.playerView.player.volume = 0.5;
    
    // 屏幕亮度
    self.brightnessView = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 70, KScreen_Width - 160)];
    [self.view addSubview:self.brightnessView];
    self.brightnessView.backgroundColor = [UIColor clearColor];
    
    
    
    // 标题
    NSString *str = [self.mvPlayerDic objectForKey:@"videoName"];
    CGFloat length = str.length * 22.f;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreen_Height - length) / 2, 20, length, 30)];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.titleLabel];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.text = [self.mvPlayerDic objectForKey:@"videoName"];
    
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.layer.masksToBounds = YES;
    
    
    // 暂停
    self.frontView = [[UIView alloc] initWithFrame:CGRectMake(10, KScreen_Width - 40, 30, 30)];
    self.frontView.backgroundColor = [UIColor colorWithWhite:0.931 alpha:0.580];
    [self.view addSubview:self.frontView];
    
    self.frontView.layer.cornerRadius = 15;
    self.frontView.layer.masksToBounds = YES;
    self.frontView.hidden = YES;
    
    // 暂停
    UIView *bt = [[UIView alloc] init];
    bt.frame = CGRectMake(5, 5, 20, 20);
    bt.layer.cornerRadius = 10;
    bt.layer.masksToBounds = YES;
    bt.backgroundColor = [UIColor whiteColor];
    [self.frontView addSubview:bt];
    bt.tag = 333;
    bt.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFrontVC:)];
    [bt addGestureRecognizer:tap];
    
    // 返回上个界面
    self.stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.stateButton];
    self.stateButton.frame = CGRectMake(20, 20, 30, 30);
    [self.stateButton setImage:[UIImage imageNamed:@"iconfont-xiangzuo"] forState:UIControlStateNormal];
    [self.stateButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
#pragma mark - playerItem
    //创建playerItem
    NSURL *videoUrl = [NSURL URLWithString:[self.mvPlayerDic objectForKey:@"url"]];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    
    // 监听视频播放状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:@"mv"];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:@"mv"];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView.player = self.player;
    
#pragma mark - 播放进度条
    //播放控制条
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake((KScreen_Height - KScreen_Width - 60) / 2, KScreen_Width - 45, KScreen_Width + 60, 40)];
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgView];
    self.bgView.hidden = NO;
    
    // 单曲循环
    self.singleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.singleBt.frame = CGRectMake(5, self.bgView.frame.size.height - 35, 30, 30);
    [self.bgView addSubview:self.singleBt];
    [self.singleBt setImage:[UIImage imageNamed:@"iconfont-mv"] forState:UIControlStateNormal];
    [self.singleBt addTarget:self action:@selector(isSelectedSingleSong:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // progressView
    self.videoProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.bgView addSubview:self.videoProgress];
    self.videoProgress.frame = CGRectMake(40, self.bgView.frame.size.height / 2 - 2, self.bgView.frame.size.width - 90, 2);
    self.bgView.hidden = YES;
    
    //slider
    self.videoSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, self.bgView.frame.size.height / 2 - 9, self.bgView.frame.size.width - 90, 15)];
    [self.bgView addSubview:self.videoSlider];
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"jindu"] forState:UIControlStateNormal];
    [self.videoSlider addTarget:self action:@selector(videoSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.videoSlider addTarget:self action:@selector(videoSliderChangeValueEnd:) forControlEvents:UIControlEventValueChanged];
    self.videoSlider.enabled = NO;
    
    // 计时器
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreen_Height - 120, KScreen_Width - 35, 80, 20)];
    [self.view addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.text = @"00:00/00:00";
    self.timeLabel.layer.cornerRadius = 4;
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    
    // 声音
    self.volumeView = [[UIView alloc] initWithFrame:CGRectMake(KScreen_Height - 90, 80, 70, KScreen_Width - 160)];
    [self.view addSubview:self.volumeView];
    self.volumeView.backgroundColor = [UIColor clearColor];
    
    
    // 快进 后退
    self.frontOrBack = [[UIView alloc] init];
    [self.view addSubview:self.frontOrBack];
    self.frontOrBack.backgroundColor = [UIColor clearColor];
    self.frontOrBack.frame = CGRectMake(KScreen_Height / 2 - 100, KScreen_Width / 2 - 50, 200, 100);
    self.frontOrBack.hidden = YES;
    self.frontOrBack.userInteractionEnabled = NO;
    
    
    // 正在加载中
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [self.view addSubview:self.loadingLabel];
    self.loadingLabel.center = self.playerView.center;
    self.loadingLabel.text = @"努力加载中...";
    self.loadingLabel.textColor = [UIColor grayColor];
    self.loadingLabel.font = [UIFont systemFontOfSize:23];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.userInteractionEnabled = NO;
    
    
    [self.view bringSubviewToFront:self.frontView];
}

// 单曲
- (void)isSelectedSingleSong:(UIButton *)button {
    
    button.selected = !button.selected;
    if (button.selected) {
        self.isSingleSong = YES;
        [self.singleBt setImage:[UIImage imageNamed:@"iconfont-danquxunhuan"] forState:UIControlStateNormal];
        NSLog(@"单曲循环");
    } else  {
        self.isSingleSong = NO;
        [self.singleBt setImage:[UIImage imageNamed:@"iconfont-mv"] forState:UIControlStateNormal];
        NSLog(@"非单曲循环");
    }
}



// 音量控制
- (void)volumeSlider:(UISlider *)volume {
    self.playerView.player.volume = volume.value;
}

// 暂停 播放
- (void)tapToFrontVC:(UITapGestureRecognizer *)tap {
    
    if (!self.isSwitch) {
        [self.playerView.player pause];
        
        [self.frontView viewWithTag:333].backgroundColor = [UIColor redColor];
        
    } else {
        [self.playerView.player play];
        
        [self.frontView viewWithTag:333].backgroundColor = [UIColor whiteColor];
        
    }
    self.isSwitch = !self.isSwitch;
}


- (void)videoSliderChangeValue:(UISlider *)sender {
    
    if (sender.value == 0.000000) {
        __weak typeof(self) weakSelf = self;
        [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.playerView.player play];
        }];
    }
    
}

// 通过 slider 来改变 播放进度
- (void)videoSliderChangeValueEnd:(UISlider *)sender {
    
    CMTime changeTime = CMTimeMakeWithSeconds(sender.value, 1);
    __weak ZZMVPlayerVC *Self = self;
    [self.playerView.player seekToTime:changeTime completionHandler:^(BOOL finished) {
        [Self.playerView.player play];
        
        [self.frontView viewWithTag:333].backgroundColor = [UIColor whiteColor];
        
    }];
}

// 对于视频播放结束的监听
- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __weak ZZMVPlayerVC *Self = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [Self.videoSlider setValue:0.0 animated:YES];
        
        [self.frontView viewWithTag:333].backgroundColor = [UIColor whiteColor];
    }];
    
    if (self.isSingleSong) {
        [self.playerView.player play];
    } else {
        [self.playerView.player pause];
    }
    
    
}


//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    //获取当前对象 AVPlayerItem
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"视频准备播放");
            
            //进入播放状态后 ， 自动进行播放
            [self.playerView.player play];
            self.loadingLabel.hidden = YES;
            self.frontOrBack.hidden = NO;
            self.frontOrBack.userInteractionEnabled = YES;
            self.frontView.hidden = NO;
            self.videoSlider.enabled = YES;
            
            //获取视频总时长
            CMTime duration = self.playerItem.duration;
            
            //将总时长转换成总秒数
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
            
            //将总时长转换成小时
            self.totalTime = [self convertTime:totalSecond];
            
            // 自定义slider
            [self customVideoSlider:duration];
            
            // 监听播放状态
            [self monitoringPlayback:self.playerItem];
            
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        // 视频缓冲的时长
        NSTimeInterval timeInterval = [self availableDuration];
        
        // 视频总的播放时长
        CMTime duration = self.playerItem.duration;
        
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        // 缓冲进度
        [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    }
    
}

//监听播放状态 实时更改播放时间label
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak ZZMVPlayerVC *weakSelf = self;
    
    // 每秒监测一次
    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        CGFloat currentSecond = playerItem.currentTime.value / playerItem.currentTime.timescale;
        [weakSelf.videoSlider setValue:currentSecond animated:YES];
        
        //将秒数转换为时间
        NSString *timeString = [weakSelf convertTime:currentSecond];
        
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@", timeString, weakSelf.totalTime];
        
    }];
}


//自定义slider
- (void)customVideoSlider:(CMTime)duration {
    
    self.videoSlider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){1, 1}, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    [self.videoSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}


//将 秒数 转换成 时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    
    if (second / 3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showTimeNew = [[self dateFormatter] stringFromDate:date];
    return showTimeNew;
}


- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [[self.playerView.player currentItem] loadedTimeRanges];
    
    //获取缓冲区域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    //计算 视频加载总时长
    NSTimeInterval result = startSeconds + durationSeconds;
    
    return result;
    
}

#pragma mark - 返回按钮
// 返回
- (void)clickedButton:(UIButton *)button {
    
    [self.playerView.player pause];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - touch 事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch=[touches anyObject];
    
    self.startPoint = CGPointZero;
    
    if (touch.view == self.brightnessView) {
        self.startPoint = [touch locationInView:self.brightnessView];
    }
    
    if (touch.view == self.frontOrBack) {
        self.startPoint = [touch locationInView:self.frontOrBack];
    }
    
    if (touch.view == self.volumeView) {
        self.startPoint = [touch locationInView:self.volumeView];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    self.endPoint = CGPointZero;
    self.curMoveAmtX = 0.f;
    self.curMoveAmtY = 0.f;
    
    if (touch.view == [self.frontView viewWithTag:333]) {
        self.frontView.center = point;
        
    }
    
    if (touch.view == self.brightnessView) {
        self.endPoint = [touch locationInView:self.brightnessView];
        CGFloat moveAmtX = self.endPoint.x - self.startPoint.x;
        CGFloat moveAmtY = self.endPoint.y - self.startPoint.y;
        self.curMoveAmtY = moveAmtY;
        self.curMoveAmtX = moveAmtX;
    }
    
    if (touch.view == self.frontOrBack) {
        self.endPoint = [touch locationInView:self.frontOrBack];
        CGFloat moveAmtX = self.endPoint.x - self.startPoint.x;
        CGFloat moveAmtY = self.endPoint.y - self.startPoint.y;
        self.curMoveAmtY = moveAmtY;
        self.curMoveAmtX = moveAmtX;
        
    }
    
    if (touch.view == self.volumeView) {
        self.endPoint = [touch locationInView:self.volumeView];
        CGFloat moveAmtX = self.endPoint.x - self.startPoint.x;
        CGFloat moveAmtY = self.endPoint.y - self.startPoint.y;
        self.curMoveAmtY = moveAmtY;
        self.curMoveAmtX = moveAmtX;
    }
    
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.playerView) {
        
        if (!self.isHide) {
            self.bgView.hidden = NO;
            self.volumeSlider.hidden = NO;
        } else {
            self.bgView.hidden = YES;
            self.volumeSlider.hidden = YES;
        }
        self.isHide = !self.isHide;
    }
    
    // 亮度
    if (touch.view == self.brightnessView) {
        if (self.curMoveAmtY > 50.f && self.curMoveAmtX < 20.f && self.curMoveAmtX > -20.f) {
            if (self.playerView.alpha > 0.3) {
                self.playerView.alpha -= 0.2;
            }
        } else if (self.curMoveAmtY < 50.f && self.curMoveAmtX < 20.f && self.curMoveAmtX > -20.f){
            if (self.playerView.alpha < 1) {
                self.playerView.alpha += 0.2;
            }
        }
    }
    
    
    // 快进 后退
    if (touch.view == self.frontOrBack) {
        if (self.curMoveAmtX > 50.f && self.curMoveAmtY < 20.f && self.curMoveAmtY > -20.f) {
            self.videoSlider.value += 3;
            [self videoSliderChangeValueEnd:self.videoSlider];
        } else if (self.curMoveAmtX < -50.f && self.curMoveAmtY < 20.f && self.curMoveAmtY > -20.f) {
            self.videoSlider.value -= 3;
            [self videoSliderChangeValueEnd:self.videoSlider];
        }
    }
    
    
    // 声音
    if (touch.view == self.volumeView) {
        if (self.curMoveAmtY > 50.f && self.curMoveAmtX < 20.f && self.curMoveAmtX > -20.f) {
            if (self.playerView.player.volume > 0.1) {
                self.playerView.player.volume -= 0.2;
            }
        } else if (self.curMoveAmtY < 50.f && self.curMoveAmtX < 20.f && self.curMoveAmtX > -20.f){
            if (self.playerView.player.volume < 1) {
                self.playerView.player.volume += 0.2;
            }
        }
    }
    self.curMoveAmtX = 0.f;
    self.curMoveAmtY = 0.f;
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
