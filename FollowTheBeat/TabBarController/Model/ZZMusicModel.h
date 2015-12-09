//
//  ZZMusicModel.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/7.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@interface ZZMusicModel : BaseModel

@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, copy) NSString *singerPic;
@property (nonatomic, copy) NSString *songName;

+ (instancetype)songsModelWithDictionary:(NSDictionary *)dic;



@end
