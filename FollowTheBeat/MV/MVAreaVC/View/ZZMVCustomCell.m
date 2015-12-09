//
//  ZZMVCustomCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMVCustomCell.h"
#import "UIImageView+WebCache.h"


@interface ZZMVCustomCell ()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *singerName;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation ZZMVCustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.picImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.picImageView];
        self.picImageView.userInteractionEnabled = YES;
        
        self.songName = [[UILabel alloc] init];
        [self.contentView addSubview:self.songName];
        
        self.singerName = [[UILabel alloc] init];
        [self.contentView addSubview:self.singerName];
        
        self.typeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.typeLabel];
        
        
        
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    self.picImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 30);
    
    self.songName.frame = CGRectMake(0, self.contentView.frame.size.height - 30, self.contentView.frame.size.width, 30);
    
    self.singerName.frame = CGRectMake(5, self.contentView.frame.size.height - 55, self.contentView.frame.size.width - 10, 20);
    
    self.typeLabel.frame = CGRectMake(5, 5, 40, 20);
    self.songName.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(ZZMVlistModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"mv_cover_default"]];
        self.songName.text = model.videoName;
        self.singerName.text = model.singerName;
        self.singerName.textColor = [UIColor whiteColor];
        self.songName.textColor = [UIColor grayColor];
        
        self.singerName.font = [UIFont systemFontOfSize:14];
        
        if ([model.typeDescription isEqualToString:@"720P"]) {
            self.typeLabel.text = @"高清";
            self.typeLabel.textColor = [UIColor whiteColor];
            self.typeLabel.textAlignment = NSTextAlignmentCenter;
            self.typeLabel.backgroundColor = [UIColor colorWithRed:0.510 green:0.773 blue:0.000 alpha:0.740];
            self.typeLabel.layer.cornerRadius = 2;
            self.typeLabel.layer.masksToBounds = YES;
            
        }
    }
}



@end
