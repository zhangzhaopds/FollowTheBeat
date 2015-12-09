//
//  ZZReadCollectionCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZReadCollectionCell.h"
#import "ZZNewsListVC.h"

@interface ZZReadCollectionCell ()

@property (nonatomic, strong) UIImageView *bgPic;
@property (nonatomic, strong) UIButton *mvButton;

@end

@implementation ZZReadCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.bgPic = [[UIImageView alloc] init];
        [self.contentView addSubview:self.bgPic];
        self.bgPic.image = [UIImage imageNamed:@"36464"];
        self.bgPic.userInteractionEnabled = YES;
        
        self.mvButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.mvButton];
        self.mvButton.layer.cornerRadius = 10;
        self.mvButton.layer.masksToBounds = YES;
        self.mvButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.mvButton.layer.borderWidth = 0.5;
        self.mvButton.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.430];
        
        [self.mvButton setTitle:@"爱读书" forState:UIControlStateNormal];
        [self.mvButton setTitleColor:[UIColor colorWithRed:130 / 255.f green:197/255.f blue:0 alpha:1] forState:UIControlStateNormal];
       
        [self.mvButton addTarget:self action:@selector(enterNext:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)enterNext:(UIButton *)button {
    ZZNewsListVC *nn = [[ZZNewsListVC alloc] init];
    [self.passVC.navigationController pushViewController:nn animated:YES];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.bgPic.frame = CGRectMake(0, 0, KScreen_Width, KScreen_Height);
    self.mvButton.frame = CGRectMake(60, self.contentView.frame.size.height * 2 / 3 + 80, KScreen_Width - 120, 50);

}

@end
