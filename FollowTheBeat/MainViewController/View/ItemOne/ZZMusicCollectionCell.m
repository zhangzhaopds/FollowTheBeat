//
//  ZZMusicCollectionCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMusicCollectionCell.h"

#import "ZZSongsAlbumVC.h"

@interface ZZMusicCollectionCell ()


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isUpLoading;

@property (nonatomic, strong) UIImageView *bgPic;
@property (nonatomic, strong) UIButton *hotSongBtn;


@end


@implementation ZZMusicCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgPic = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgPic];
        self.bgPic.image = [UIImage imageNamed:@"48413"];
        self.bgPic.userInteractionEnabled = YES;
        
        
        self.hotSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.hotSongBtn];
        self.hotSongBtn.layer.cornerRadius = 10;
        self.hotSongBtn.layer.masksToBounds = YES;
        self.hotSongBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.hotSongBtn.layer.borderWidth = 0.5;
        self.hotSongBtn.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.250];
        [self.hotSongBtn setTitle:@"最新热曲" forState:UIControlStateNormal];
        
        [self.hotSongBtn addTarget:self action:@selector(enterNext:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)enterNext:(UIButton *)button {
    
    ZZSongsAlbumVC *area = [[ZZSongsAlbumVC alloc] init];
    [self.passVC.navigationController pushViewController:area animated:YES];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    self.bgPic.frame = [UIScreen mainScreen].bounds;
    
    self.hotSongBtn.frame = CGRectMake(60, self.contentView.frame.size.height * 2 / 3 + 80, KScreen_Width - 120, 50);
}


@end
