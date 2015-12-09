//
//  ZZNewsListCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/8.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZNewsListCell.h"
#import "UIImageView+WebCache.h"

@interface ZZNewsListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;

@end

@implementation ZZNewsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.922 alpha:1.000];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        
        self.picImageView = [[UIImageView alloc] init];
        [self.bgView addSubview:self.picImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.bgView addSubview:self.titleLabel];
        self.titleLabel.numberOfLines = 0;
        
        self.sourceLabel = [[UILabel alloc] init];
        [self.bgView addSubview:self.sourceLabel];
        self.sourceLabel.textAlignment = NSTextAlignmentRight;
        self.sourceLabel.font = [UIFont systemFontOfSize:14];
        self.sourceLabel.textColor = [UIColor grayColor];
        
//        self.picImageView.backgroundColor = [UIColor redColor];
//        self.titleLabel.backgroundColor = [UIColor yellowColor];
//        self.sourceLabel.backgroundColor = [UIColor greenColor];
        
        self.bgView.backgroundColor = [UIColor whiteColor];
//        self.sourceLabel.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(10, 10, KScreen_Width - 20, 125);
    
    self.picImageView.frame = CGRectMake(10, 10, self.bgView.frame.size.width / 3 - 10, 100);
    
    self.titleLabel.frame = CGRectMake(self.bgView.frame.size.width / 3 + 20, 10, self.bgView.frame.size.width * 2 / 3 - 30, 100);
    
    self.sourceLabel.frame = CGRectMake(self.bgView.frame.size.width / 3 + 20, 90, self.bgView.frame.size.width * 2 / 3 - 30, 20);
    
    
}


- (void)setModel:(ZZNewsModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"default_nmv_260-147"]];
        self.titleLabel.text = model.title;
        if (model.ptime.length) {
            NSString *time = [model.ptime substringWithRange:NSMakeRange(5, 11)];
            self.sourceLabel.text = [NSString stringWithFormat:@"%@  ", time];
        } else {
            self.sourceLabel.text = @"---  ";
        }
        
    }
}

@end
