//
//  ZZCustomFavoriteView.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseView.h"
#import "ZZSongListModel.h"

@interface ZZCustomFavoriteView : BaseView


@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UILabel *favLabel;
@property (nonatomic, strong) UIButton *discussButton;
@property (nonatomic, strong) UILabel *discussLabel;


@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) ZZSongListModel *model;


@end
