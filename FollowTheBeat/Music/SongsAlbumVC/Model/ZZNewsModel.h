//
//  ZZNewsModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/8.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZNewsModel : BaseModel

@property (nonatomic, copy) NSString *TAG;
@property (nonatomic, copy) NSString *digest;
@property (nonatomic, copy) NSString *docid;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *recReason;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *picCount;
@property (nonatomic, copy) NSString *ptime;

+ (instancetype)newsModelWithDictionary:(NSDictionary *)dic;

@end
