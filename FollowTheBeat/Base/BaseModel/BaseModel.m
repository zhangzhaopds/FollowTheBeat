//
//  BaseModel.m
//  跟着节拍
//
//  Created by 张昭 on 15/10/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.nID = value;
    }
}

@end
