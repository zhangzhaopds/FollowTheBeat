//
//  ZZGameImageView.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZGameImageView.h"

@implementation ZZGameImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        
    }
    return self;
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"move" object:nil userInfo:@{@"image": self}];
}


@end
