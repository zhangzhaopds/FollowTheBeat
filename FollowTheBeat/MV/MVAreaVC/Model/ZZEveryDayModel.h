//
//  ZZEveryDayModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZEveryDayModel : BaseModel


@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, copy) NSString *bigPicUrl;
@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, strong) NSNumber *bulletCount;
@property (nonatomic, strong) NSArray *mvList;

+ (instancetype)videoModelWithDictionary:(NSDictionary *)dic;


@end
