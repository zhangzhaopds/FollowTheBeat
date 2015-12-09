//
//  ZZLeftViewController.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZLeftViewController.h"

@interface ZZLeftViewController ()

@property (nonatomic, strong) UILabel *aboutLab;

@end

@implementation ZZLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setUpUI];
    
    
    // Do any additional setup after loading the view.
}

- (void)setUpUI {
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:bgImage];
    bgImage.image = [UIImage imageNamed:@"48413"];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visual = [[UIVisualEffectView alloc] initWithEffect:blur];
    visual.frame = bgImage.frame;
    [bgImage addSubview:visual];
    
    
    // 清除缓存
    UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:clear];
    [clear addTarget:self action:@selector(clearCache:) forControlEvents:UIControlEventTouchUpInside];
    [clear setImage:[UIImage imageNamed:@"iconfont-apptubiaojiheqinglihuancun"] forState:UIControlStateNormal];
    clear.frame = CGRectMake(40, KScreen_Height - 60, 30, 30);
    
    UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, KScreen_Height - 55, 100, 30)];
    [self.view addSubview:clearLabel];
    clearLabel.text = @"清除缓存";
    clearLabel.textColor = [UIColor whiteColor];
    clearLabel.textAlignment = NSTextAlignmentCenter;
    
    //  关于我们
    UIButton *about = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:about];
    [about addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    [about setImage:[UIImage imageNamed:@"iconfont-guanyuwomen"] forState:UIControlStateNormal];
    about.frame = CGRectMake(KScreen_Width - 155, KScreen_Height - 57, 30, 30);
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width - 120, KScreen_Height - 55, 80, 30)];
    [self.view addSubview:aboutLabel];
    aboutLabel.textAlignment = NSTextAlignmentRight;
    aboutLabel.text = @"关于我们";
    aboutLabel.textColor = [UIColor whiteColor];
    
    self.aboutLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, KScreen_Width / 2 + 30, 300)];
    [self.view addSubview:self.aboutLab];
//    self.aboutLab.backgroundColor = [UIColor whiteColor];
    self.aboutLab.hidden = YES;
    self.aboutLab.text = @"意见可反馈至：zhangzhaopds@foxmail.com\n功能不断优化中\n由衷感谢您的支持！";
    self.aboutLab.numberOfLines = 0;
    self.aboutLab.textColor = [UIColor whiteColor];
    
}

- (void)about:(UIButton *)about {
    
    about.selected = !about.selected;
    if (about.selected) {
        self.aboutLab.hidden = NO;
    } else {
        self.aboutLab.hidden = YES;
    }
}

//- (void)clearCache:(UIButton *)button {
//    
//    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Caches"];
//    NSLog(@"%@", cachePath);
//    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
//    
//    
//}

#pragma mark - 清除缓存
- (void)clearCache:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    /* 确认按钮 */
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        /* 清除缓存 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /* 获取缓存文件夹路径 */
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            /* 获取缓存文件夹的大小 */
            CGFloat size = [self folderSizeAtPath:cachPath];
            
            /* 获取缓存文件夹路径下 的所有文件 */
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            
            /* 遍历所有文件， 一一删除 */
            for(NSString *str in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:str];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            
            /* 缓存清除成功后的提醒 */
            UIAlertController *success = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"成功清除%.1fM缓存", size] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:success animated:YES completion:^{
                
            }];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
        
    }];
    [alert addAction:sure];
    
    
    /* 取消按钮 */
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:cancel];
    
    /* 推出alert */
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

/* 获取单个文件的大小 */
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/* 通过回调函数，获取路径下的所有文件总大小 */
- (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *child = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [child nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:filePath];
    }
    return folderSize / (1024.0 * 1024.0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
