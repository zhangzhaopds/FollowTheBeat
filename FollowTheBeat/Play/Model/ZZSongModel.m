//
//  ZZSongModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/23.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongModel.h"

@implementation ZZSongModel

+ (instancetype)songModelWithDictionary:(NSDictionary *)dic {
    ZZSongModel *model = [[ZZSongModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
