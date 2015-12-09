//
//  ZZMVPlayerDetailVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMVPlayerDetailVC.h"
#import "ZZMVPlayerView.h"
#import "HTTPTOOL.h"
#import "UIImageView+WebCache.h"
#import "ZZMVlistModel.h"
#import "ZZCustomStatusView.h"
#import "ZZMoreMVCell.h"
#import "ZZMusicPlayer.h"

@interface ZZMVPlayerDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZZMVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;


@property (nonatomic, strong) UIButton *stateButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) id playbackTimeObserver;
@property (nonatomic, strong) UISlider *videoSlider;
@property (nonatomic, strong) UIProgressView *videoProgress;
@property (nonatomic, strong) UISlider *volumeSlider;

@property (nonatomic, assign) BOOL played;
@property (nonatomic, copy) NSString *totalTime;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL isHide;
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIButton *zoomChangeBt;
@property (nonatomic, strong) ZZCustomStatusView *customStatus;
@property (nonatomic, strong) NSMutableArray *listMVArray;

@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, assign) BOOL isReadyToPlay;

@end

@implementation ZZMVPlayerDetailVC

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerRate" object:nil];
}

- (void)dealloc {
    
    
    [self.playerItem removeObserver:self forKeyPath:@"status" context:@"detail"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:@"detail"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
    
    
}

- (void)creatActivity {
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activity];
    self.activity.frame = [UIScreen mainScreen].bounds;
    [self.activity startAnimating];
}

#pragma mark - 数据处理
- (void)handleData {
    
    
    //  http://api.dongting.com/sim/mv/2259276/similarity?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F&v=v8.2.0.2015091720&f=ff8000&mid=m2%2Bnote&tid=194420874
    
    NSString *list = [NSString stringWithFormat:@"http://api.dongting.com/sim/mv/%@", self.videoId];
    NSString *listUrl = [list stringByAppendingString:@"/similarity?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F&v=v8.2.0.2015091720&f=ff8000&mid=m2%2Bnote&tid=194420874"];
    
    listUrl = [listUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [HTTPTOOL GETWithURL:listUrl body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *dataArr = [resu objectForKey:@"data"];
            for (NSDictionary *dd in dataArr) {
                ZZMVlistModel *model = [ZZMVlistModel mvListModelWithDictionary:dd];
                NSArray *arr = [dd objectForKey:@"mvList"];
                
                [model setValuesForKeysWithDictionary:[arr firstObject]];
                
                [self.listMVArray addObject:model];
            }
            
            [self.activity stopAnimating];
            
            [self.tabelView reloadData];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
    //http://api.dongting.com/song/video/2001470?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F
    
    NSString *str = [NSString stringWithFormat:@"http://api.dongting.com/song/video/%@", self.videoId];
    str = [str stringByAppendingString:@"?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F"];
    
    [HTTPTOOL GETWithURL:str body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            ZZMVlistModel *model = [ZZMVlistModel mvListModelWithDictionary:[resu objectForKey:@"data"]];
            NSDictionary *dic = [resu objectForKey:@"data"];
            
            if ([dic objectForKey:@"mvList"]) {
                [model setValuesForKeysWithDictionary:[[dic objectForKey:@"mvList"] firstObject]];
                
            }
            
            [self.dataArray  addObject:model];
            
            [self creatUI];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
    
    if ([ZZMusicPlayer shareMusicPlayer].player.rate) {
        [[ZZMusicPlayer shareMusicPlayer].player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerRate" object:nil];
    }
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    self.listMVArray = [NSMutableArray array];
    
    [self handleData];
    
    [self creatTableView];
    
    [self dateFormatter];
    
    [self creatActivity];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(logPlayerRate) userInfo:nil repeats:YES];
}
//- (void)logPlayerRate {
//    NSLog(@"%g", self.player.rate);
//}
#pragma mark - 创建 播放视图
- (void)creatUI {
    
    ZZMVlistModel *model = [self.dataArray firstObject];
    
    
#pragma mark - 视频界面
    //视频界面
    //KScreen_Height * 0.375 ==
    self.playerView = [[ZZMVPlayerView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Height * 0.375)];
    [self.view addSubview:self.playerView];
    
    self.playerView.backgroundColor = [UIColor blackColor];
    self.playerView.userInteractionEnabled = YES;
    self.playerView.player.volume = 1;
    
    
    
    // 正在加载中
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [self.view addSubview:self.loadingLabel];
    self.loadingLabel.center = self.playerView.center;
    self.loadingLabel.text = @"努力加载中...";
    self.loadingLabel.textColor = [UIColor grayColor];
    self.loadingLabel.font = [UIFont systemFontOfSize:17];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //返回 三角 button
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customStatus addSubview:back];
    [back setImage:[UIImage imageNamed:@"iconfont-xiangzuo"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backTofrontVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(10, 20, 40, 40);
    self.customStatus.hidden = NO;
    
    // 歌名
    NSString *str = model.videoName;
    CGFloat length = str.length * 22.f;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreen_Width - length) / 2, 30, length, 30)];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.titleLabel];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.text = model.videoName;
    
    self.titleLabel.layer.cornerRadius = 5;
    self.titleLabel.layer.masksToBounds = YES;
    
    
    
    //创建playerItem
    NSURL *videoUrl = [NSURL URLWithString:model.url];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    
    // 监听视频播放状态
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:@"detail"];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:@"detail"];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mvPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView.player = self.player;
    
#pragma mark - 播放控制条
    //播放控制条
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.playerView.frame.size.height - 45, self.playerView.frame.size.width, 40)];
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.masksToBounds = YES;
    [self.playerView addSubview:self.bgView];
    self.bgView.hidden = NO;
    //    self.bgView.backgroundColor = [UIColor colorWithWhite:0.840 alpha:0.580];
    
    
    
    // 播放 暂停 按钮
    self.stateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.bgView addSubview:self.stateButton];
    self.stateButton.frame = CGRectMake(5, self.bgView.frame.size.height - 35, 30, 30);
    [self.stateButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    self.stateButton.hidden = YES;
    self.stateButton.tintColor = [UIColor whiteColor];
    
    [self.stateButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    self.stateButton.enabled = NO;
    
    
    
    
    // progressView
    self.videoProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.bgView addSubview:self.videoProgress];
    self.videoProgress.frame = CGRectMake(45, self.bgView.frame.size.height / 2 - 2, self.bgView.frame.size.width - 100, 2);
    
    self.bgView.hidden = YES;
    
    //slider
    self.videoSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, self.bgView.frame.size.height / 2 - 9, self.bgView.frame.size.width - 100, 15)];
    [self.bgView addSubview:self.videoSlider];
    self.videoSlider.enabled = NO;
    
    
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"iconfont-erjiline"] forState:UIControlStateNormal];
    
    [self.videoSlider addTarget:self action:@selector(videoSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.videoSlider addTarget:self action:@selector(videoSliderChangeValueEnd:) forControlEvents:UIControlEventValueChanged];
    
    // 时间显示
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width - 130, self.bgView.frame.size.height - 15, 80, 15)];
    [self.bgView addSubview:self.timeLabel];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.text = @"00:00/00:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    // 屏幕切换
    self.zoomChangeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:self.zoomChangeBt];
    [self.zoomChangeBt setImage:[UIImage imageNamed:@"iconfont-zoomin2"] forState:UIControlStateNormal];
    self.zoomChangeBt.frame = CGRectMake(self.bgView.frame.size.width - 50, - 3, 45, 45);
    self.zoomChangeBt.hidden = YES;
    [self.zoomChangeBt addTarget:self action:@selector(zoomChange:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)zoomChange:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            
            
            self.playerView.frame = CGRectMake(0, 0, KScreen_Height, KScreen_Width);
            self.bgView.frame = CGRectMake(50, KScreen_Width - 45, KScreen_Height - 100, 40);
            self.zoomChangeBt.frame = CGRectMake(self.bgView.frame.size.width - 50, - 3, 45, 45);
            
            self.videoProgress.frame = CGRectMake(45, self.bgView.frame.size.height / 2 - 2, self.bgView.frame.size.width - 100, 2);
            self.videoSlider.frame = CGRectMake(50, self.bgView.frame.size.height / 2 - 9, self.bgView.frame.size.width - 100, 15);
            self.stateButton.frame = CGRectMake(5, self.bgView.frame.size.height - 35, 30, 30);
            self.timeLabel.frame = CGRectMake(self.bgView.frame.size.width - 135, self.bgView.frame.size.height - 15, 80, 15);
            
            self.titleLabel.frame = CGRectMake((KScreen_Height - 200) / 2, 30, 200, 30);
            self.loadingLabel.frame = CGRectMake(0, 0, 200, 30);
            self.loadingLabel.center = self.playerView.center;
            self.customStatus.hidden = YES;
            self.frontView.hidden = NO;
            [invocation invoke];
        }
    } else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            
            [invocation invoke];
            
            self.playerView.frame = CGRectMake(0, 0, KScreen_Width, 250);
            
            self.bgView.frame = CGRectMake(0, self.playerView.frame.size.height - 45, self.playerView.frame.size.width, 40);
            self.videoProgress.frame = CGRectMake(45, self.bgView.frame.size.height / 2 - 2, self.bgView.frame.size.width - 100, 2);
            self.videoSlider.frame = CGRectMake(50, self.bgView.frame.size.height / 2 - 9, self.bgView.frame.size.width - 100, 15);
            self.stateButton.frame = CGRectMake(5, self.bgView.frame.size.height - 35, 30, 30);
            self.zoomChangeBt.frame = CGRectMake(self.bgView.frame.size.width - 50, - 3, 45, 45);
            self.timeLabel.frame = CGRectMake(self.bgView.frame.size.width - 135, self.bgView.frame.size.height - 15, 80, 15);
            self.titleLabel.frame = CGRectMake((KScreen_Width - 200) / 2, 30, 200, 30);
            self.loadingLabel.frame = CGRectMake(0, 0, 200, 30);
            self.loadingLabel.center = self.playerView.center;
            self.customStatus.hidden = NO;
            self.frontView.hidden = YES;
            
        }
    }
    
}


- (void)backTofrontVC {
    [self.playerView.player pause];
    [self.player pause];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - touch 事件

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (touch.view == [self.frontView viewWithTag:333]) {
        self.frontView.center = point;
        
    }
    
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.playerView) {
        
        if (!self.isHide) {
            self.bgView.hidden = NO;
            self.volumeSlider.hidden = NO;
            self.stateButton.hidden = NO;
            self.zoomChangeBt.hidden = NO;
            
        } else {
            self.bgView.hidden = YES;
            self.volumeSlider.hidden = YES;
            self.stateButton.hidden = YES;
            self.zoomChangeBt.hidden = YES;
            
        }
        self.isHide = !self.isHide;
    }
    
}

- (void)videoSliderChangeValue:(UISlider *)sender {
    
    if (sender.value == 0.000000) {
        __block typeof(self) weakSelf = self;
        [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.playerView.player play];
        }];
    }
    
}

// 通过 slider 来改变 播放进度
- (void)videoSliderChangeValueEnd:(UISlider *)sender {
    
    CMTime changeTime = CMTimeMakeWithSeconds(sender.value, 1);
    __block ZZMVPlayerDetailVC *Self = self;
    [self.playerView.player seekToTime:changeTime completionHandler:^(BOOL finished) {
        [Self.playerView.player play];
        
        [self.stateButton setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateSelected];
    }];
}

// 对于视频播放结束的监听
- (void)mvPlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __block ZZMVPlayerDetailVC *Self = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [Self.videoSlider setValue:0.0 animated:YES];
        
        [self.stateButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        
    }];
}


//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    NSLog(@"后台装填%ld", [UIApplication sharedApplication].applicationState);
//    if ([UIApplication sharedApplication].applicationState == 1) {
//        [self.player pause];
//    }
    //获取当前对象 AVPlayerItem
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"视频准备播放");
            
            self.isReadyToPlay = YES;
            //进入播放状态后 ， 自动进行播放
            [self.playerView.player play];
            self.loadingLabel.hidden = YES;
            self.stateButton.enabled = YES;
            self.titleLabel.hidden = YES;
            self.videoSlider.enabled = YES;
            
            //获取视频总时长
            CMTime duration = self.playerItem.duration;
            
            //总秒数
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
            
            //将总时长转换成小时
            self.totalTime = [self convertTime:totalSecond];
            
            // 自定义slider
            [self customVideoSlider:duration];
            
            // 监听播放状态
            [self monitoringPlayback:self.playerItem];
            
        } else {
            self.isReadyToPlay = NO;
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
    
    __block ZZMVPlayerDetailVC *weakSelf = self;
    
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

// 懒加载
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


//播放 暂停 按钮d
- (void)clickedButton:(UIButton *)button {
    NSLog(@"%g", self.player.rate);
    
    if (!self.played) {
        [self.playerView.player pause];
        [self.player pause];
        [self.stateButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        
        self.titleLabel.hidden = NO;
        self.titleLabel.center = self.playerView.center;
        NSLog(@"暂停");
    } else {
        [self.playerView.player play];
        [self.stateButton setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        self.titleLabel.hidden = YES;
        NSLog(@"播放");
    }
    
    self.played = !self.played;
}


#pragma mark - 创建 tabelView
- (void)creatTableView {
    
    // 更多标签
    self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 120, 20)];
    self.moreLabel.text = @" 推荐MV";
    [self.view addSubview:self.moreLabel];
    self.moreLabel.font = [UIFont systemFontOfSize:20];
    self.moreLabel.textColor = KButton_Color;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 300, KScreen_Width - 20, 1)];
    [self.view addSubview:lineView];
    lineView.backgroundColor = KButton_Color;
    
    
    // tableView
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 310, KScreen_Width, KScreen_Height - 310) style:UITableViewStylePlain];
    [self.view addSubview:self.tabelView];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.tabelView registerClass:[ZZMoreMVCell class] forCellReuseIdentifier:@"reuse"];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.listMVArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ZZMoreMVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    ZZMVlistModel *model = [self.listMVArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    if (!self.isReadyToPlay) {
        return;
    }
    
    [self.playerView.player pause];
    
    ZZMVlistModel *model = [self.listMVArray objectAtIndex:indexPath.row];
    
    // 移除观察者 和 通知中心
    [self.playerItem removeObserver:self forKeyPath:@"status" context:@"detail"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:@"detail"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
    
    // 创建新的item
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.url]];;
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    self.playerView.player = self.player;
    
    __block ZZMVPlayerDetailVC *Self = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [Self.videoSlider setValue:0.0 animated:YES];
        
        [self.stateButton setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        
    }];
    
    // 注册新的观察者 和 通知中心
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:@"detail"];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:@"detail"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mvPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    
    self.titleLabel.text = model.videoName;
    NSString *str = model.videoName;
    CGFloat length = str.length * 22.f;
    self.titleLabel.frame = CGRectMake((KScreen_Width - length) / 2, 30, length, 30);
    [self.playerView.player play];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 170.f;
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
