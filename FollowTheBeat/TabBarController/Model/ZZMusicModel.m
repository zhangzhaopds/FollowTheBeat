//
//  ZZMusicModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/7.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMusicModel.h"

@implementation ZZMusicModel

+ (instancetype)songsModelWithDictionary:(NSDictionary *)dic {
    ZZMusicModel *model = [[ZZMusicModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
