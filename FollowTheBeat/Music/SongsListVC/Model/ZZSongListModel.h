//
//  ZZSongListModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZSongListModel : BaseModel

@property (nonatomic, strong) NSNumber *songlist_id;
@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDictionary *image;
@property (nonatomic, strong) NSDictionary *owner;
@property (nonatomic, strong) NSNumber *song_count;
@property (nonatomic, strong) NSNumber *comment_count;
@property (nonatomic, strong) NSNumber *listen_count;
@property (nonatomic, strong) NSNumber *share_count;
@property (nonatomic, strong) NSNumber *favorite_count;


+ (instancetype)songListModelWithDictionary:(NSDictionary *)dic;

@end
