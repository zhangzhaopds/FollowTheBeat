//
//  BaseModel.h
//  跟着节拍
//
//  Created by 张昭 on 15/10/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KScreen_Width [UIScreen mainScreen].bounds.size.width
#define KScreen_Height [UIScreen mainScreen].bounds.size.height
#define KNaviBar_Height 64
#define KTabBar_Height 49

@interface BaseModel : NSObject


@property (nonatomic, copy) NSString *nID;


@end
