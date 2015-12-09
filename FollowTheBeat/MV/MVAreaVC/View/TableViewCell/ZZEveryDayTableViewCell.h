//
//  ZZEveryDayTableViewCell.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZZEveryDayModel.h"

@interface ZZEveryDayTableViewCell : BaseTableViewCell

@property (nonatomic, strong) ZZEveryDayModel *model;
@property (nonatomic, strong) UIViewController *passVC;

@end
