//
//  ZZSongsModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZSongsModel : BaseModel

@property (nonatomic, strong) NSNumber *songId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *librettistId;
@property (nonatomic, strong) NSNumber *composerId;
@property (nonatomic, strong) NSNumber *singerId;
@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, strong) NSNumber *albumId;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, strong) NSNumber *favorites;
@property (nonatomic, strong) NSArray *mvList;


+ (instancetype)songsModelWithDictionary:(NSDictionary *)dic;

@end
