//
//  ZZSongsModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongsModel.h"

@implementation ZZSongsModel

+ (instancetype)songsModelWithDictionary:(NSDictionary *)dic {
    
    ZZSongsModel *model = [[ZZSongsModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
    
}


@end
