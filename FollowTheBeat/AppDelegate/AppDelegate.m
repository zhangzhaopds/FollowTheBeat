//
//  AppDelegate.m
//  跟着节拍
//
//  Created by 张昭 on 15/10/18.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "AppDelegate.h"
#import "RESideMenu.h"
#import <AVFoundation/AVFoundation.h>

#import "ZZLeftViewController.h"
#import "ZZTabBarViewController.h"
#import "UMSocial.h"
#import "ZZMusicPlayer.h"


@interface AppDelegate ()<RESideMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
   

    
    
    ZZTabBarViewController *tab = [[ZZTabBarViewController alloc] init];
    ZZLeftViewController *left = [[ZZLeftViewController alloc] init];

    RESideMenu *reside = [[RESideMenu alloc] initWithContentViewController:tab leftMenuViewController:left rightMenuViewController:nil];
    
    
    
    reside.delegate = self;
    reside.contentViewShadowColor =
    [UIColor colorWithWhite:0.863 alpha:1.000];
    reside.contentViewShadowOffset = CGSizeMake(0, 0);
    reside.contentViewShadowOpacity = 0.6;
    reside.contentViewShadowRadius = 12;
    reside.contentViewShadowEnabled = YES;
    
    //设置后台播放会话
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];

    // 分享
    [UMSocialData setAppKey:@"5613563067e58e3e17001756"];
    
    self.window.rootViewController = reside;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //开启后台播放
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
