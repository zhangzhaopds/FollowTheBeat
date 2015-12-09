//
//  ZZCustomStatusView.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZCustomStatusView.h"

@implementation ZZCustomStatusView

// 自定义 navigationBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.BGImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.BGImageView];
        
        
        UIView *status = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        [self.BGImageView addSubview:status];
        
        self.naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 44)];
        [self.BGImageView addSubview:self.naviBarView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width - 100, 30)];
        self.titleLabel.center = self.naviBarView.center;
        [self.BGImageView addSubview:self.titleLabel];
        
        
        
    }
    return self;
}


@end
