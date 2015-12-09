//
//  ZZSongModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/23.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZSongModel : BaseModel


//  http://api.dongting.com/song/song/1021525?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F

@property (nonatomic, copy) NSString *songId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *singerId;
@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSString *favorites;
@property (nonatomic, copy) NSString *originalId;
@property (nonatomic, copy) NSString *releaseYear;

@property (nonatomic, copy) NSString *auditionList;
@property (nonatomic, copy) NSString *urlList;
@property (nonatomic, copy) NSString *llList;
@property (nonatomic, copy) NSString *mvList;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *commentCount;

+ (instancetype)songModelWithDictionary:(NSDictionary *)dic;

@end
