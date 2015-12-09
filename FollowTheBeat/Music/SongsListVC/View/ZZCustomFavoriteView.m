//
//  ZZCustomFavoriteView.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZCustomFavoriteView.h"
#define KFrame_Width frame.size.width
#define KFrame_Height frame.size.height

@interface ZZCustomFavoriteView ()

@end

@implementation ZZCustomFavoriteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        // 收藏
        self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.favoriteButton];
        [self.favoriteButton setImage:[UIImage imageNamed:@"iconfont-shoucangweishoucang"] forState:UIControlStateNormal];
        
        self.favoriteButton.frame = CGRectMake((KFrame_Width - 80) / 8, 5, 30, 30);
        
        //收藏数量
        self.favLabel = [[UILabel alloc] initWithFrame:CGRectMake((KFrame_Width - 80) / 8 - 20 + 5, 33, 60, 20)];
        [self addSubview:self.favLabel];
        self.favLabel.textAlignment = NSTextAlignmentCenter;
        self.favLabel.font = [UIFont systemFontOfSize:13];
        self.favLabel.textColor = [UIColor whiteColor];
        
        
        //评论
        self.discussButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.discussButton];
        [self.discussButton setImage:[UIImage imageNamed:@"iconfont-pinglun"] forState:UIControlStateNormal];
        self.discussButton.frame = CGRectMake((KFrame_Width - 80) * 3 / 8 + 20, 5, 30, 30);
        //        self.discussButton.enabled = NO;
        
        //评论数量
        self.discussLabel = [[UILabel alloc] initWithFrame:CGRectMake((KFrame_Width - 80) * 3 / 8 + 5, 33, 60, 20)];
        [self addSubview:self.discussLabel];
        self.discussLabel.font = [UIFont systemFontOfSize:13];
        self.discussLabel.textAlignment = NSTextAlignmentCenter;
        self.discussLabel.textColor = [UIColor whiteColor];
        
        //分享
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.shareButton];
        self.shareButton.frame = CGRectMake((KFrame_Width - 80) * 5 / 8 + 41.5, 5, 27, 27);
        [self.shareButton setImage:[UIImage imageNamed:@"iconfont-fenxiang-2"] forState:UIControlStateNormal];
        
        
        //分享数量
        self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((KFrame_Width - 80) * 5 / 8 + 20 + 5, 33, 60, 20)];
        [self addSubview:self.shareLabel];
        self.shareLabel.font = [UIFont systemFontOfSize:13];
        self.shareLabel.textAlignment = NSTextAlignmentCenter;
        self.shareLabel.textColor = [UIColor whiteColor];
        
        //简介
        self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.detailButton];
        self.detailButton.frame = CGRectMake((KFrame_Width - 80) * 7 / 8 + 60 , 5, 30, 30);
        [self.detailButton setImage:[UIImage imageNamed:@"iconfont-xiangqing-2"] forState:UIControlStateNormal];
        
        //简介
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake((KFrame_Width - 80) * 7 / 8 + 40 + 5, 33, 60, 20)];
        [self addSubview:self.detailLabel];
        self.detailLabel.font = [UIFont systemFontOfSize:13];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.textColor = [UIColor whiteColor];
        
        
        //        self.favoriteButton.backgroundColor = [UIColor redColor];
        //        self.favLabel.backgroundColor = [UIColor greenColor];
        //        self.discussLabel.backgroundColor = [UIColor redColor];
        //        self.discussButton.backgroundColor = [UIColor greenColor];
        //        self.shareButton.backgroundColor = [UIColor redColor];
        //        self.shareLabel.backgroundColor = [UIColor greenColor];
        //        self.detailButton.backgroundColor = [UIColor redColor];
        //        self.detailLabel.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setModel:(ZZSongListModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model) {
        self.favLabel.text = [NSString stringWithFormat:@"%d", (int)model.favorite_count];
        self.discussLabel.text = [NSString stringWithFormat:@"%d", (int)model.comment_count];
        self.shareLabel.text = [NSString stringWithFormat:@"%d", (int)model.share_count];
        self.detailLabel.text = @"简介";
    }
}


@end
