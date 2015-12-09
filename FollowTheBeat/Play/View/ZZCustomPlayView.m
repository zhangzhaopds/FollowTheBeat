//
//  ZZCustomPlayView.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/27.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZCustomPlayView.h"

@implementation ZZCustomPlayView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.924 alpha:0.910];

        // 歌曲名字
        self.songLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 25)];
        [self addSubview:self.songLabel];
        self.songLabel.textAlignment = NSTextAlignmentCenter;
        self.songLabel.text = @"有点甜";
        self.songLabel.font = [UIFont systemFontOfSize:25];
        
        // 歌手名字
        self.singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, 20)];
        [self addSubview:self.singerLabel];
        self.singerLabel.text = @"汪苏泷";
        self.singerLabel.textAlignment = NSTextAlignmentCenter;
        self.singerLabel.textColor = [UIColor lightGrayColor];
        
        CGFloat width = frame.size.width;
        CGFloat heigh = frame.size.height;
        
        //  圆形刷新按钮
        self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.refreshButton];
        self.refreshButton.frame = CGRectMake(30, 95, 20, 20);
        
        [self.refreshButton setImage:[UIImage imageNamed:@"iconfont-shuaxin"] forState:UIControlStateNormal];
 
        
        // 前一首歌曲
        self.lastSong = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lastSong.frame = CGRectMake(30 + (width / 2 - 45) / 2, 92.5, 25, 25);
        
        [self addSubview:self.lastSong];
        [self.lastSong setImage:[UIImage imageNamed:@"iconfont-houtuijian"] forState:UIControlStateNormal];

        
        // 暂停按钮
        self.stopOrstart = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stopOrstart.frame = CGRectMake(width / 2 - 15, 90, 30, 30);
        [self addSubview:self.stopOrstart];
       
        [self.stopOrstart setImage:[UIImage imageNamed:@"iconfont-iconfont67"] forState:UIControlStateNormal];
        
        // 下一首按钮
        self.nextSong = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextSong.frame = CGRectMake(width / 2 + 15 + (width / 2 - 45) / 2 - 30, 92.5, 25, 25);
        [self addSubview:self.nextSong];
        
        [self.nextSong setImage:[UIImage imageNamed:@"iconfont-qianjinjian"] forState:UIControlStateNormal];
        
        // 音乐符号按钮
        self.listSongView =[UIButton buttonWithType:UIButtonTypeCustom];
        self.listSongView.frame = CGRectMake(width - 60, 95, 20, 20);
        [self addSubview:self.listSongView];
        
        [self.listSongView setImage:[UIImage imageNamed:@"iconfont-bofangliebiao"] forState:UIControlStateNormal];
       
        
        // 播放进度条
        self.songProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(22, 120 + (heigh - 120) / 2, width - 54, 8)];
        [self addSubview:self.songProgress];
        
        
        self.songSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 118 + (heigh - 120) / 2, width - 50, 8)];
        [self addSubview:self.songSlider];
        
        self.beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 90 + (heigh - 120) / 2, 60, 20)];
        [self addSubview:self.beginTimeLabel];
        
        // 正在播放的时间
        self.beginTimeLabel.font = [UIFont systemFontOfSize:13];
        self.beginTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.beginTimeLabel.text = @"00:00";
        
        // 播放接收的时间
        self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 90, 90 + (heigh - 120) / 2, 60, 20)];
        [self addSubview:self.endTimeLabel];
        
        self.endTimeLabel.font = [UIFont systemFontOfSize:13];
        self.endTimeLabel.textAlignment = NSTextAlignmentRight;
        self.endTimeLabel.text = @"00:00";
        

    }
    return self;
}



@end
