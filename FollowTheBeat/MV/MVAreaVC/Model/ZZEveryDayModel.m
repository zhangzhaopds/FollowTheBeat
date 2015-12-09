//
//  ZZEveryDayModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZEveryDayModel.h"

@implementation ZZEveryDayModel

+ (instancetype)videoModelWithDictionary:(NSDictionary *)dic {
    ZZEveryDayModel *model = [[ZZEveryDayModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
