//
//  ZZMusicAlbumModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZMusicAlbumModel : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *listen_count;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, strong) NSNumber *quan_id;

+ (instancetype)musicAlbumModelWithDictionary:(NSDictionary *)dic;

@end
