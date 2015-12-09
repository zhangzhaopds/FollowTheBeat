//
//  ZZSongsListTVC.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZZSongsModel.h"

@interface ZZSongsListTVC : BaseTableViewCell

@property (nonatomic, strong) ZZSongsModel *model;
@property (nonatomic, assign) CGFloat indexPathRow;
@property (nonatomic, strong) UIViewController *passVC;

@end
