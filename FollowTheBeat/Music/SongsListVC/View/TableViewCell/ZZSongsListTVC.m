//
//  ZZSongsListTVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongsListTVC.h"
#import "ZZMVPlayerVC.h"
#import "HTTPTOOL.h"
#import "ZZMusicPlayer.h"

@interface ZZSongsListTVC ()

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UIImageView *favoriteImage;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, assign) CGFloat titleLength;
@property (nonatomic, assign) CGFloat singerLength;
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) UIView *BView;
@property (nonatomic, strong) UILabel *mvLabel;

@end

@implementation ZZSongsListTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        // 背景
        self.BGView = [[UIView alloc] init];
        [self.contentView addSubview:self.BGView];
        
        self.BView = [[UIView alloc] init];
        [self.contentView addSubview:self.BView];
        
        // 播放 或 序号
        self.numLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.numLabel];
        
        // mv 标签
        self.mvLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.mvLabel];
        self.mvLabel.userInteractionEnabled = YES;
        
        // 歌曲名字
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        // 歌手
        self.singerLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.singerLabel];
        
        // 收藏的心
        self.favoriteImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.favoriteImage];
        
        // 收藏的数量
        self.countLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.countLabel];
        
        // 更多  button
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.moreButton];
        [self.moreButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = [UIColor colorWithWhite:0.974 alpha:0.980];
        self.BGView.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
        
        self.BView.backgroundColor = [UIColor colorWithWhite:0.952 alpha:1.000];
        
        
        self.mvLabel.backgroundColor = KButton_Color;
        
    }
    return self;
}

// 添加单曲
- (void)buttonClicked:(UIButton *)button {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"songList" object:nil userInfo:@{@"songId": self.model.songId, @"singerId": self.model.singerId}];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.BGView.frame = CGRectMake(5, 5, KScreen_Width - 10, 65);
    self.BGView.layer.cornerRadius = 3;
    self.BGView.layer.masksToBounds = YES;
    
    self.BView.frame = CGRectMake(5, 5, KScreen_Width - 10, 64);
    self.BView.layer.cornerRadius = 3;
    self.BView.layer.masksToBounds = YES;
    
    self.numLabel.frame = CGRectMake(20, 15, 40, 40);
    
    self.titleLabel.frame = CGRectMake(70, 10, KScreen_Width - 120, 20);
    
    self.singerLabel.frame = CGRectMake(70, 40, self.singerLength, 20);
    
    self.favoriteImage.frame = CGRectMake(70 + self.singerLength + 5, 40, 20, 20);
    
    self.countLabel.frame = CGRectMake(100 + self.singerLength, 40, 40, 20);
    
    self.mvLabel.frame = CGRectMake(140 + self.singerLength, 40, 35, 20);
    
    self.moreButton.frame = CGRectMake(KScreen_Width - 60, 20, 40, 40);
    
    
}



- (void)setModel:(ZZSongsModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)self.indexPathRow + 1];
    self.numLabel.textColor = KButton_Color;
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.font = [UIFont systemFontOfSize:24];
    
    
    self.titleLabel.text = model.name;
    self.titleLabel.font = [UIFont systemFontOfSize:23];
    self.titleLength = self.titleLabel.text.length * 24;
    
    
    self.singerLabel.text = model.singerName;
    self.singerLength = [self countWord:model.singerName] * 15 + 10;
    
    
    self.singerLabel.textAlignment = NSTextAlignmentCenter;
    self.singerLabel.textColor = [UIColor grayColor];
    self.singerLabel.font = [UIFont systemFontOfSize:14];
    self.singerLabel.textAlignment = NSTextAlignmentLeft;
    
    self.countLabel.text = [NSString stringWithFormat:@"%d", (int)model.favorites % 100];
    self.countLabel.textColor = [UIColor grayColor];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    
    self.favoriteImage.image = [UIImage imageNamed:@"iconfont-xin"];
    
    
//    [self.moreButton setImage:[UIImage imageNamed:@"about_arrow"] forState:UIControlStateNormal];
    
    [self.moreButton setImage:[UIImage imageNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
    // iconfont-tianjia
    if (model.mvList.count) {
        self.mvLabel.text = @"MV";
        self.mvLabel.textColor = [UIColor whiteColor];
        self.mvLabel.hidden = NO;
        self.mvLabel.textAlignment = NSTextAlignmentCenter;
        self.mvLabel.layer.cornerRadius = 3;
        self.mvLabel.layer.masksToBounds = YES;
        
    } else {
        self.mvLabel.hidden = YES;
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch.view == self.mvLabel) {
        
        NSMutableDictionary *passDic = [NSMutableDictionary dictionary];
        
        NSDictionary *dic = [self.model.mvList firstObject];
        
        [passDic setObject:self.model.singerName forKey:@"singerName"];
        [passDic setObject:self.model.name forKey:@"videoName"];
        [passDic setObject:[dic objectForKey:@"picUrl"] forKey:@"picUrl"];
        [passDic setObject:[dic objectForKey:@"url"] forKey:@"url"];
        
        ZZMVPlayerVC *player = [[ZZMVPlayerVC alloc] init];
        player.mvPlayerDic = passDic;
        [self.passVC.navigationController pushViewController:player animated:YES];
        
    }
}

- (int)countWord:(NSString *)s
{
    int i, n = (int)s.length ,l = 0, a = 0, b = 0;
    unichar c = 0;
    for(i = 0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        
    }
    if(a==0 && l==0) return 0;
    
    return l+(int)ceilf((float)(a+b)/2.0);
}



@end
