//
//  ZZSongsListCell.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/7.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ZZSongsListCell : BaseTableViewCell

@property (nonatomic, strong) NSDictionary *songsListDic;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIButton *jiaBtn;
@end
