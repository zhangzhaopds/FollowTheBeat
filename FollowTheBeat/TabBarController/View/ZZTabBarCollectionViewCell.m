//
//  ZZTabBarCollectionViewCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/23.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZTabBarCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ZZTabBarCollectionViewCell ()

@property (nonatomic, strong) UIImageView *photoImage;
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UILabel *singerLabel;

@end

@implementation ZZTabBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        /* 圆形的专辑照片 */
        self.photoImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photoImage];
        
        /* 歌曲名字 */
        self.titleName = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleName];
        
        /* 歌手 */
        self.singerLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.singerLabel];
        
        
        self.photoImage.backgroundColor = [UIColor clearColor];
        self.titleName.backgroundColor = [UIColor clearColor];
        self.singerLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    /* 专辑照片 */
    self.photoImage.frame = CGRectMake(5, 5, 42, 42);
    self.photoImage.layer.cornerRadius = 21;
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.borderColor = [UIColor colorWithRed:0.411 green:0.813 blue:0.173 alpha:1.000].CGColor;
    self.photoImage.layer.borderWidth = 0.5;
   
    /* 歌名 */
    self.titleName.frame = CGRectMake(60, 5, KScreen_Width * 2 / 3 - 70, 20);

    self.titleName.font = [UIFont systemFontOfSize:20];
    
    /* 歌手 */
    self.singerLabel.frame = CGRectMake(60, 26, KScreen_Width * 2 / 3 - 70, 22);
  
    self.singerLabel.font = [UIFont systemFontOfSize:13];
    self.singerLabel.textColor = [UIColor grayColor];
    
}

- (void)setModel:(ZZMusicModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    self.singerLabel.text = model.singerName;
    self.titleName.text = model.songName;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.singerPic] placeholderImage:[UIImage imageNamed:@"default_nmv_260-147"]];
    
}

@end
