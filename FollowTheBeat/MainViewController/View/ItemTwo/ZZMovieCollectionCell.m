//
//  ZZMovieCollectionCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMovieCollectionCell.h"
#import "ZZMVAreaVC.h"

@interface ZZMovieCollectionCell ()

@property (nonatomic, strong) UIImageView *bgPicView;
@property (nonatomic, strong) UIButton *mvButton;
@property (nonatomic, strong) UIButton *movieBtn;

@end

@implementation ZZMovieCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor purpleColor];
        
        self.bgPicView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgPicView];
        self.bgPicView.image = [UIImage imageNamed:@"60004"];
        self.bgPicView.userInteractionEnabled = YES;
        
        self.mvButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.mvButton];
        self.mvButton.layer.cornerRadius = 10;
        self.mvButton.layer.masksToBounds = YES;
        self.mvButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.mvButton.layer.borderWidth = 0.5;
        self.mvButton.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.250];
        [self.mvButton setTitle:@"MV精选" forState:UIControlStateNormal];
        
        [self.mvButton addTarget:self action:@selector(enterNext:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)enterNext:(UIButton *)button {
    
    ZZMVAreaVC *area = [[ZZMVAreaVC alloc] init];
    [self.passVC.navigationController pushViewController:area animated:YES];
    
}



- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.bgPicView.frame = CGRectMake(0, 0, KScreen_Width, KScreen_Height);
    self.mvButton.frame = CGRectMake(60, self.contentView.frame.size.height * 2 / 3 + 80, KScreen_Width - 120, 50);

}

@end
