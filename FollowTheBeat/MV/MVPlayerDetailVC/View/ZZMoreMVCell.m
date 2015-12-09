//
//  ZZMoreMVCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMoreMVCell.h"
#import "UIImageView+WebCache.h"

@interface ZZMoreMVCell ()

@property (nonatomic, strong) UIImageView *MVPic;
@property (nonatomic, strong) UILabel *typePic;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UILabel *songLabel;

@property (nonatomic, strong) UIView *HLine;
@property (nonatomic, strong) UIView *VLine;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ZZMoreMVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.MVPic = [[UIImageView alloc] init];
        [self.contentView addSubview:self.MVPic];
        
        self.songLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.songLabel];
        
        self.HLine = [[UIView alloc] init];
        [self.contentView addSubview:self.HLine];
        
        self.typePic = [[UILabel alloc] init];
        [self.contentView addSubview:self.typePic];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.MVPic.frame = CGRectMake(10, 10, KScreen_Width * 2 / 3 - 20, 150);
    
    self.typePic.frame = CGRectMake(15, 15, 40, 20);
    
    
    self.timeLabel.frame = CGRectMake(KScreen_Width * 2 / 3 - 55, 135, 40, 20);
    
    
    self.songLabel.frame = CGRectMake(KScreen_Width * 2 / 3 + 5, 10, KScreen_Width / 3 - 20, 150);
    self.songLabel.numberOfLines = 0;
    
    self.HLine.frame = CGRectMake(KScreen_Width * 2 / 3 + 5, 160, KScreen_Width / 3 - 20, 1);
    self.HLine.backgroundColor = KButton_Color;
    
    
}

- (void)setModel:(ZZMVlistModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model) {
        self.songLabel.text = model.videoName;
        self.songLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.MVPic sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"default_nmv_260-147"]];
        
        if ([model.typeDescription isEqualToString:@"720P"]) {
            self.typePic.text = @"高清";
            self.typePic.backgroundColor = KButton_Color;
            self.typePic.textColor = [UIColor whiteColor];
            self.typePic.textAlignment = NSTextAlignmentCenter;
            self.typePic.layer.cornerRadius = 3;
            self.typePic.layer.masksToBounds = YES;
            
        }
        
        self.timeLabel.text = @"03:34";
        NSString *min = [NSString stringWithFormat:@"%.2f", [model.duration floatValue] / 1000];
        self.timeLabel.text = [self convertTime:min.floatValue];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.640];
        self.timeLabel.layer.cornerRadius = 3;
        self.timeLabel.layer.masksToBounds = YES;
        
    }
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

@end
