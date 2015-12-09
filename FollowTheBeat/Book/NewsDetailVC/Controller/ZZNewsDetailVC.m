//
//  ZZNewsDetailVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/8.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZNewsDetailVC.h"
#import "ZZCustomStatusView.h"
#import "HTTPTOOL.h"

@interface ZZNewsDetailVC ()

@property (nonatomic, strong) ZZCustomStatusView *customStatus;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, assign) NSInteger h;

@end

@implementation ZZNewsDetailVC


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self creatStatusView];
    NSLog(@"%@", [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.passId]);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self handleData];
}

- (void)handleData {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.passId];
    
    [HTTPTOOL GETWithURL:urlStr body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];

            
            
            self.imgArr = [NSMutableArray array];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[resu objectForKey:self.passId]];
            
            /* 添加图片 */
            NSMutableString *bodyStr = [NSMutableString string];
            bodyStr = [dic objectForKey:@"body"];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            if ([[dic allKeys] containsObject:@"img"]) {
                
                tempArr = [dic objectForKey:@"img"];
                
                for (NSDictionary *refDic in tempArr) {
                    
                    for (NSString *key in refDic) {
                        
                        /* 图片自适应 */
                        if ([[refDic allKeys] containsObject:@"pixel"] &&
                            ![[refDic valueForKey:@"pixel"] isEqualToString:@""]) {
                            
                            NSString *pixelS = [NSString
                                                stringWithFormat:@"%@", [refDic objectForKey:@"pixel"]];
                            
                            NSArray *pixelArr =
                            [pixelS componentsSeparatedByString:@"*"];
                            NSString *widthS = [pixelArr firstObject];
                            NSString *heightS = [pixelArr lastObject];
                            NSInteger width = widthS.integerValue;
                            NSInteger height = heightS.integerValue;
                            
                            self.h = (KScreen_Width - 20) * height / width;
                        }
                        if (![[refDic allKeys] containsObject:@"pixel"]) {
                            
                            self.h = 450;
                        }
                        
                        if ([key isEqualToString:@"src"]) {
                            
                            NSRange range =
                            [bodyStr rangeOfString:[refDic objectForKey:@"ref"]];
                            if (range.length != NSNotFound) {
                                
                                NSString *picStr = [NSString
                                                    stringWithFormat:
                                                    @"<img src=\"%@\" width=\"%f\" height=\"%ld\">",
                                                    [refDic objectForKey:key], (KScreen_Width - 20), self.h];
                                
                                bodyStr =
                                [bodyStr stringByReplacingCharactersInRange:range
                                                                 withString:picStr]
                                .mutableCopy;
                                

                               
                            }
                        }
                    }
                }
            }

            UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height, KScreen_Width, KScreen_Height - KNaviBar_Height - KTabBar_Height)];
            [self.view addSubview:web];
//            NSString *webStr = [[dic objectForKey:@"title"] stringByAppendingString:bodyStr];
            web.backgroundColor = [UIColor whiteColor];
            [web loadHTMLString:bodyStr baseURL:nil];
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - 自定义标题栏
- (void)creatStatusView {
    
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    self.customStatus.backgroundColor = KButton_Color;
    
    self.customStatus.titleLabel.text = @"今日阅读";
    self.customStatus.titleLabel.textColor = [UIColor whiteColor];
    self.customStatus.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    self.customStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customStatus addSubview:back];
    [back setImage:[UIImage imageNamed:@"iconfont-xiangzuo"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backTofrontVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(10, 20, 40, 40);
    
}

- (void)backTofrontVC {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - MemoryWarning
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
