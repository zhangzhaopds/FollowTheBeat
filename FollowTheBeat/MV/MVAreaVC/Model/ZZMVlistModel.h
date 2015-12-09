//
//  ZZMVlistModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZMVlistModel : BaseModel


@property (nonatomic, strong) NSNumber *singerId;
@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *bitRate;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, copy) NSString *suffix;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *typeDescription;
@property (nonatomic, strong) NSNumber *praiseCount;
@property (nonatomic, strong) NSNumber *stepCount;
@property (nonatomic, strong) NSNumber *pickCount;
@property (nonatomic, strong) NSNumber *bulletCount;
@property (nonatomic, copy) NSString *desc;

+ (instancetype)mvListModelWithDictionary:(NSDictionary *)dic;

@end
