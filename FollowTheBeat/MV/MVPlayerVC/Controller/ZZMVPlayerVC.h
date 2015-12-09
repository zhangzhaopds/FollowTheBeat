//
//  ZZMVPlayerVC.h
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "BaseViewController.h"

@interface ZZMVPlayerVC : BaseViewController
/**
 * 本页的接口：   mvPlayerDic
 *
 * 可变字典， 有4个key值，V值均为字符串
 * url :       mv 的 播放地址
 * picUrl:     mv 的 视频截图
 * singerName: mv 歌手名字
 * videoName:  mv 的名字
 *
 */

@property (nonatomic, strong) NSMutableDictionary *mvPlayerDic;


@end
