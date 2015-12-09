//
//  ZZMVlistModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMVlistModel.h"

@implementation ZZMVlistModel

+ (instancetype)mvListModelWithDictionary:(NSDictionary *)dic {
    ZZMVlistModel *model = [[ZZMVlistModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
