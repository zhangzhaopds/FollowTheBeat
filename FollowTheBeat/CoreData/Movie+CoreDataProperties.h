//
//  Movie+CoreDataProperties.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mvUrl;
@property (nullable, nonatomic, retain) NSString *mvName;
@property (nullable, nonatomic, retain) NSString *mvDetail;
@property (nullable, nonatomic, retain) NSString *mvPicUrl;
@property (nullable, nonatomic, retain) NSString *mvAuthor;

@end

NS_ASSUME_NONNULL_END
