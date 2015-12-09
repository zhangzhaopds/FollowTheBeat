//
//  ZZCustomPlayView.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/27.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseView.h"

@interface ZZCustomPlayView : BaseView


@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UILabel *songLabel;
@property (nonatomic, strong) UIProgressView *songProgress;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *lastSong;
@property (nonatomic, strong) UIButton *stopOrstart;
@property (nonatomic, strong) UIButton *nextSong;
@property (nonatomic, strong) UIButton *listSongView;


//+ (ZZCustomPlayView *)shareCustomPlayView;

@end
