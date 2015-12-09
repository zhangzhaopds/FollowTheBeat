//
//  Song+CoreDataProperties.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *singerName;
@property (nullable, nonatomic, retain) NSString *singerId;
@property (nullable, nonatomic, retain) NSString *songId;
@property (nullable, nonatomic, retain) NSString *songName;
@property (nullable, nonatomic, retain) NSString *songUrl;
@property (nullable, nonatomic, retain) NSString *albumUrl;
@property (nullable, nonatomic, retain) NSString *songPicUrl;

@end

NS_ASSUME_NONNULL_END
