//
//  BaseTableViewCell.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KScreen_Width [UIScreen mainScreen].bounds.size.width
#define KScreen_Height [UIScreen mainScreen].bounds.size.height
#define KNaviBar_Height 64
#define KTabBar_Height 49
#define KPlaceHolderImage [UIImage imageNamed:@"placeholderImage"]
#define KButton_Color [UIColor colorWithRed:130 / 255.f green:197/255.f blue:0 alpha:1];
@interface BaseTableViewCell : UITableViewCell

@end
