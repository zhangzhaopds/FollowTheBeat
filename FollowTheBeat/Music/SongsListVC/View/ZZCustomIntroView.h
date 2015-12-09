//
//  ZZCustomIntroView.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseView.h"
#import "ZZSongListModel.h"

@interface ZZCustomIntroView : BaseView

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *ErJiImageview;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) ZZSongListModel *model;

@end
