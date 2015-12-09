//
//  ZZSongsListCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/7.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongsListCell.h"
#import "ZZMusicPlayer.h"

@interface ZZSongsListCell ()

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *singer;


@end


@implementation ZZSongsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
      
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.numLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.numLabel];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.font = [UIFont systemFontOfSize:22];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        
        self.songName = [[UILabel alloc] init];
        [self.contentView addSubview:self.songName];
        self.songName.textColor = [UIColor whiteColor];
        self.songName.font = [UIFont systemFontOfSize:17];
        
        
        self.singer = [[UILabel alloc] init];
        [self.contentView addSubview:self.singer];
        self.singer.textColor = [UIColor whiteColor];
        self.singer.font = [UIFont systemFontOfSize:13];
        
        self.jiaBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.jiaBtn];
        
        
        
//        self.numLabel.backgroundColor = [UIColor redColor];
//        self.songName.backgroundColor = [UIColor yellowColor];
//        self.singer.backgroundColor = [UIColor greenColor];
//        self.jiaBtn.backgroundColor = [UIColor purpleColor];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.numLabel.frame = CGRectMake(5, 15, 30, 30);
    
    self.songName.frame = CGRectMake(40, 10, self.contentView.frame.size.width - 90, 25);
    
    self.singer.frame = CGRectMake(40, 35, self.contentView.frame.size.width - 90, 15);
    

//    [self.jiaBtn setImage:[UIImage imageNamed:@"iconfont-shoushizuohua"] forState:UIControlStateNormal];
//    self.jiaBtn.frame = CGRectMake(self.contentView.frame.size.width - 40, 15, 30, 30);
}

- (void)setSongsListDic:(NSDictionary *)songsListDic {
    if (_songsListDic != songsListDic) {
        _songsListDic = songsListDic;
    }
    
    if (songsListDic.allKeys.count) {
        self.songName.text = [songsListDic objectForKey:@"songName"];
        self.singer.text = [songsListDic objectForKey:@"singerName"];

    }
}

- (void)setIndex:(NSInteger)index {
    if (_index != index) {
        _index = index;
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld", index + 1];
    if ([ZZMusicPlayer shareMusicPlayer].indexOfItemInArr == index) {
        self.numLabel.textColor = KButton_Color;
    } else {
        self.numLabel.textColor = [UIColor whiteColor];
        
    }
}


@end
