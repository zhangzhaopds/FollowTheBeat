//
//  ZZMusicAlbumModel.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMusicAlbumModel.h"

@implementation ZZMusicAlbumModel

+ (instancetype)musicAlbumModelWithDictionary:(NSDictionary *)dic {
    ZZMusicAlbumModel *model = [[ZZMusicAlbumModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
