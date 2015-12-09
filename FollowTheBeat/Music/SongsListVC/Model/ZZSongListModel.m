//
//  ZZSongListModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongListModel.h"

@implementation ZZSongListModel

+ (instancetype)songListModelWithDictionary:(NSDictionary *)dic {
    
    ZZSongListModel *model = [[ZZSongListModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
    
}

@end
