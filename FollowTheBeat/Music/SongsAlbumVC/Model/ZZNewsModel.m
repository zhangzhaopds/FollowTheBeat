//
//  ZZNewsModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/8.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZNewsModel.h"

@implementation ZZNewsModel

+ (instancetype)newsModelWithDictionary:(NSDictionary *)dic {
    ZZNewsModel *model = [[ZZNewsModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
    
}
@end
