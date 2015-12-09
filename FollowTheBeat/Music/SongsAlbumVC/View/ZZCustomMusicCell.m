//
//  ZZCustomMusicCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZCustomMusicCell.h"
#import "UIImageView+WebCache.h"




@interface ZZCustomMusicCell ()

@property (nonatomic, strong) UIImageView *picImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZCustomMusicCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor yellowColor];
        
        self.picImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.picImage];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.titleLabel.backgroundColor = [UIColor colorWithWhite:0.374 alpha:0.630];
        
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    self.picImage.frame = self.contentView.frame;
    
    self.titleLabel.frame = CGRectMake(0, self.contentView.frame.size.height - 20, self.contentView.frame.size.width, 20);
    
}

- (void)setModel:(ZZMusicAlbumModel *)model {
    if (_model == model) {
        _model = model;
    }
    
    if (model) {
        
        [self.picImage sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        self.titleLabel.text = model.title;
        self.titleLabel.textColor = [UIColor whiteColor];
        
    }
    
}



@end
