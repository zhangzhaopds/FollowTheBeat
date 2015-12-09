//
//  ZZEveryDayTableViewCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZEveryDayTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZZMVPlayerDetailVC.h"


@interface ZZEveryDayTableViewCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UIImageView *smallImage;
@property (nonatomic, strong) UIImageView *bigImage;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *boFang;
@property (nonatomic, strong) UIView *yuanView;
@property (nonatomic, strong) UIView *headView;

//@property (nonatomic, strong) LPZ_MVPlayerView *mvPlayerView;
//@property (nonatomic, strong) AVPlayer *player;
//@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation ZZEveryDayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor colorWithWhite:0.951 alpha:1.000];
        
        self.headView = [[UIView alloc] init];
        [self.contentView addSubview:self.headView];
        
        self.dayLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.dayLabel];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        
        self.monthLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.monthLabel];
        
        self.descLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.descLabel];
        
        self.firstLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.firstLabel];
        
        self.secondLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.secondLabel];
        
        self.thirdLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.thirdLabel];
        
        self.smallImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.smallImage];
        
        
        self.bigImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bigImage];
        self.bigImage.userInteractionEnabled = YES;
        
        self.countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.countLabel];
        
        self.bottomView = [[UIView alloc] init];
        [self.contentView addSubview:self.bottomView];
        
        self.yuanView = [[UIView alloc] init];
        [self.bigImage addSubview:self.yuanView];
        self.yuanView.tag = 100;
        
        
        self.boFang = [[UIImageView alloc] init];
        [self.yuanView addSubview:self.boFang];
        self.boFang.tag = 200;
        self.boFang.userInteractionEnabled = YES;
        
        self.headView.backgroundColor = [UIColor grayColor];
        self.boFang.backgroundColor = [UIColor clearColor];
        self.yuanView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        self.lineView.backgroundColor = [UIColor blackColor];
        self.descLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.bottomView.backgroundColor = [UIColor lightGrayColor];
        
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    self.dayLabel.frame = CGRectMake(10, 10, KScreen_Width / 5 - 10, KScreen_Width / 5 - 20);
    self.lineView.frame = CGRectMake(10, KScreen_Width / 5 - 8, KScreen_Width / 5 - 10, 2);
    
    self.monthLabel.frame = CGRectMake(10, KScreen_Width / 5, KScreen_Width / 5 - 10, 20);
    
    self.descLabel.frame = CGRectMake(KScreen_Width / 5 + 10, 10, KScreen_Width * 4 / 5 - 20, KScreen_Width / 5 - 20);
    
    self.firstLabel.frame = CGRectMake(KScreen_Width / 5 + 10, KScreen_Width / 5 - 3, KScreen_Width * 2 / 15, 20);
    self.secondLabel.frame = CGRectMake(20 + KScreen_Width / 3, KScreen_Width / 5 - 3, KScreen_Width * 2 / 15, 20);
    self.thirdLabel.frame = CGRectMake(30 + KScreen_Width * 7 / 15, KScreen_Width / 5 - 3, KScreen_Width * 2 / 15, 20);
    
    self.smallImage.frame = CGRectMake(KScreen_Width - 60, KScreen_Width / 5, 20, 20);
    self.countLabel.frame = CGRectMake(KScreen_Width - 40, KScreen_Width / 5, 30, 20);
    
    self.bigImage.frame = CGRectMake(10, KScreen_Width / 5 + 30, KScreen_Width - 20, KScreen_Width * 3 / 5);
    
    
    self.bottomView.frame = CGRectMake(10, KScreen_Width * 4 / 5 + 40, KScreen_Width - 20, 1);
    
    self.yuanView.frame = CGRectMake((self.bigImage.frame.size.width - 80) / 2, (self.bigImage.frame.size.height - 80) / 2, 80, 80);
    
    self.yuanView.layer.cornerRadius = 40;
    self.yuanView.layer.masksToBounds = YES;
    
    self.boFang.frame = CGRectMake(22.5, 22.5, 35, 35);
    
    
    
}

- (void)setModel:(ZZEveryDayModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    
    
    NSArray *sub = [_model.title componentsSeparatedByString:@"/"];
    
    self.dayLabel.text = [sub firstObject];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.font = [UIFont systemFontOfSize:45];
    
    self.monthLabel.text = [sub lastObject];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.font = [UIFont systemFontOfSize:20];
    
    
    self.descLabel.text = _model.desc;
    self.descLabel.numberOfLines = 0;
    
    if (_model.tag.count > 0) {
        self.firstLabel.text = [[_model.tag firstObject] objectForKey:@"tagName"];
        NSString *color1 = [[_model.tag objectAtIndex:0] objectForKey:@"tagColor"];
        NSArray *arr = [color1 componentsSeparatedByString:@","];
        NSString *red = [[arr firstObject] substringFromIndex:4];
        NSString *green = [arr objectAtIndex:1];
        NSString *leng = [arr lastObject];
        NSString *blue = [leng substringToIndex:leng.length - 1];
        
        CGFloat r = [red floatValue];
        CGFloat g = [green floatValue];
        CGFloat b = [blue floatValue];
        self.firstLabel.backgroundColor = [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1];
        
        
        self.firstLabel.textAlignment = NSTextAlignmentCenter;
        self.firstLabel.font = [UIFont systemFontOfSize:14];
        
        
        
        
    }
    if (_model.tag.count > 1) {
        self.secondLabel.text = [[_model.tag objectAtIndex:1] objectForKey:@"tagName"];
        NSString *color2 = [[_model.tag objectAtIndex:1] objectForKey:@"tagColor"];
        NSArray *arr = [color2 componentsSeparatedByString:@","];
        NSString *red = [[arr firstObject] substringFromIndex:4];
        NSString *green = [arr objectAtIndex:1];
        NSString *leng = [arr lastObject];
        NSString *blue = [leng substringToIndex:leng.length - 1];
        NSArray *array = @[red, green, blue];
        
        self.secondLabel.backgroundColor = [UIColor colorWithRed:[array[0] floatValue] / 255.f green:[array[1] floatValue] / 255.f blue:[array[2] floatValue] / 255.f alpha:1];
        self.secondLabel.textAlignment = NSTextAlignmentCenter;
        self.secondLabel.font = [UIFont systemFontOfSize:14];
        
        self.dayLabel.textColor = [UIColor colorWithRed:[array[0] floatValue] / 255.f green:[array[1] floatValue] / 255.f blue:[array[2] floatValue] / 255.f alpha:1];
        
    }
    if (_model.tag.count > 2) {
        self.thirdLabel.text = [[_model.tag objectAtIndex:2] objectForKey:@"tagName"];
        NSString *color3 = [[_model.tag objectAtIndex:2] objectForKey:@"tagColor"];
        NSArray *arr = [color3 componentsSeparatedByString:@","];
        
        NSString *red = [[arr firstObject] substringFromIndex:4];
        NSString *green = [arr objectAtIndex:1];
        NSString *leng = [arr lastObject];
        NSString *blue = [leng substringToIndex:leng.length - 1];
        NSArray *array = @[red, green, blue];
        
        self.thirdLabel.backgroundColor = [UIColor colorWithRed:[array[0] floatValue] / 255.f green:[array[1] floatValue] / 255.f blue:[array[2] floatValue] / 255.f alpha:1];
        
        self.thirdLabel.textAlignment = NSTextAlignmentCenter;
        self.thirdLabel.font = [UIFont systemFontOfSize:14];
        
    }
    
    
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:_model.bigPicUrl] placeholderImage:[UIImage imageNamed:@"nrecommend_newsongs"]];
    
    
    NSString *count = [NSString stringWithFormat:@"%@", _model.bulletCount];
    
    
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    if (count.length > 2) {
        self.countLabel.text = @"98";
    } else {
        self.countLabel.text = count;
    }
    
    self.smallImage.image = [UIImage imageNamed:@"iconfont-xiaoxi"];
    
    self.boFang.image = [UIImage imageNamed:@"iconfont-bofang-4"];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.boFang || touch.view == self.yuanView) {
        
        
        ZZMVPlayerDetailVC *mvDetail = [[ZZMVPlayerDetailVC alloc] init];
        
        mvDetail.videoId = self.model.nID;
        
        [self.passVC.navigationController pushViewController:mvDetail animated:YES];
    }
}


@end
