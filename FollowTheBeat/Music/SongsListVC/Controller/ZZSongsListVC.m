//
//  ZZSongsListVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/5.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongsListVC.h"
#import "ZZCustomIntroView.h"
#import "ZZCustomFavoriteView.h"
#import "ZZSongListModel.h"
#import "ZZSongsModel.h"
#import "ZZSongsListTVC.h"
#import "ZZCustomStatusView.h"
#import "UIImageView+WebCache.h"
#import "HTTPTOOL.h"
#import "ZZMusicPlayer.h"
#import "ZZSongModel.h"

//#import "LPZ_DescriptionVC.h"


#define ImageHeight 300.f

@interface ZZSongsListVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *BGImageView; //放大缩小的照片
@property (nonatomic, strong) ZZCustomStatusView *customStatus;

@property (nonatomic, strong) ZZCustomIntroView *customIntroView;
@property (nonatomic, strong) ZZCustomFavoriteView *customFavView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *songInfroArray; //自定义view 上所需的数据
@property (nonatomic, strong) NSMutableArray *songsArray;
@property (nonatomic, strong) UIView *BGView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;



@end

@implementation ZZSongsListVC

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"songList" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.songInfroArray = [NSMutableArray array];
    self.songsArray = [NSMutableArray array];
    
    [self handData];
    
    [self creatTableView];
    
    [self creatActivity];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedButton:) name:@"songList" object:nil];
    
}

// 活动指示器
- (void)creatActivity {
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activity];
    self.activity.frame = CGRectMake(0, 0, KScreen_Width, KScreen_Height - 2 * KNaviBar_Height);
    self.activity.center = self.view.center;
    [self.activity startAnimating];
}

// cell 里面 添加按钮的 实现
- (void)clickedButton:(NSNotification *)noti {
    
    NSString *song = [noti.userInfo objectForKey:@"songId"];
    NSString *singer = [noti.userInfo objectForKey:@"singerId"];
    
    NSString *str = [NSString stringWithFormat:@"http://api.dongting.com/song/song/%@", song];
    NSString *songsUrl = [str stringByAppendingString:@"?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F"];
    
    NSMutableDictionary *songsDictionary = [NSMutableDictionary dictionary];
    
    NSString *singerId = [NSString stringWithFormat:@"http://api.dongting.com/song/singer/%@", singer];
    [HTTPTOOL GETWithURL:singerId body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *ddd = [resu objectForKey:@"data"];
            [songsDictionary setObject:[ddd objectForKey:@"picUrl"] forKey:@"singerPic"];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    [HTTPTOOL GETWithURL:songsUrl body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dic = [resu objectForKey:@"data"];
            
            
            [songsDictionary setObject:[dic objectForKey:@"songId"] forKey:@"songId"];
            [songsDictionary setObject:[dic objectForKey:@"name"] forKey:@"songName"];
            [songsDictionary setObject:[dic objectForKey:@"singerName"] forKey:@"singerName"];
            NSArray *arr = [dic objectForKey:@"auditionList"];
            
            if (arr.count) {
                NSDictionary *dd = [arr objectAtIndex:1];
                [songsDictionary setObject:[dd objectForKey:@"url"] forKey:@"songUrl"];
                [[ZZMusicPlayer shareMusicPlayer].playList addObject:songsDictionary];
                NSLog(@"已加入列表");
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:^{
                    NSLog(@"出现");
                }];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"消失");
                }];
                
            } else {
                NSLog(@"未加入列表");
                
            }
        }
    } fail:^(NSError *error) {
        
    }];

}



#pragma mark - 数据处理
- (void)handData {
    
    //  http://api.songlist.ttpod.com/songlists/300003269
    //  304507669   300003269
    //    NSString *songlist_id = @"301642545";
    //  http://api.dongting.com/song/song/1122152?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F
    
    NSString *urlString = [@"http://api.songlist.ttpod.com/songlists/" stringByAppendingString:[NSString stringWithFormat:@"%@", self.quan_id]];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [HTTPTOOL GETWithURL:urlString body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            // 数据1
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:resu];
            ZZSongListModel *listModel = [ZZSongListModel songListModelWithDictionary:dic];
            [self.songInfroArray addObject:listModel];
            
            // 数据2
            NSArray *songs = [dic objectForKey:@"songs"];
            for (NSDictionary *dd in songs) {
                ZZSongsModel *songsModel = [ZZSongsModel songsModelWithDictionary:dd];
                [self.songsArray addObject:songsModel];
            }
            [self.tableView reloadData];
            
            [self.activity stopAnimating];
            
            [self setUpUI];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}



#pragma mark - 创建 tableView
- (void)creatTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(ImageHeight, 0, 0, 0);
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"abc"];
    [self.tableView registerClass:[ZZSongsListTVC class] forCellReuseIdentifier:@"reuse"];
    
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGPoint point = [[change objectForKey:@"new"] CGPointValue];
    
    
    if (point.y < - KNaviBar_Height - 55.f) {
        self.customFavView.frame = CGRectMake(0, - point.y - 55.f, KScreen_Width, 55.f);
    }
    if (point.y > - ImageHeight - 1.f && point.y < -120.f) {
        self.customIntroView.alpha = -(ImageHeight - 30.f + point.y) / 30.f;
    }
    if (point.y < - KNaviBar_Height - 100.f) {
        self.customIntroView.frame = CGRectMake(0, - point.y - 155.f, KScreen_Width, 100.f);
    }
    if (point.y > -118.f) {
        self.customFavView.frame = CGRectMake(0, KNaviBar_Height, KScreen_Width, 55.f);
    }
    
}

#pragma mark - UI 部分
- (void)setUpUI {
    
    ZZSongListModel *model = [self.songInfroArray firstObject];
    
    //标题
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    self.customStatus.titleLabel.text = model.title;
    self.customStatus.titleLabel.textColor = [UIColor whiteColor];
    self.customStatus.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    self.customStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.customStatus.titleLabel.hidden = YES;
    
       
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customStatus addSubview:back];
    [back setImage:[UIImage imageNamed:@"iconfont-xiangzuo"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backTofrontVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(10, 20, 40, 40);
    
    
    //背景可下拉放大的照片
    self.BGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 - ImageHeight, KScreen_Width, ImageHeight)];
    [self.tableView addSubview:self.BGImageView];
    self.BGImageView.contentMode = UIViewContentModeScaleToFill;
    [self.BGImageView sd_setImageWithURL:[NSURL URLWithString:[model.image objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"nrecommend_newsongs"]];
    
    
//    //自定义头像、简介等
//    self.customIntroView = [[ZZCustomIntroView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height + 70, KScreen_Width, 100)];
//    [self.view addSubview:self.customIntroView];
//    self.customIntroView.backgroundColor = [UIColor clearColor];
//    self.customIntroView.model = model;
    
    // 自定义收藏、分享等
    self.customFavView = [[ZZCustomFavoriteView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height + 110 + 70, KScreen_Width, 55)];
    [self.view addSubview:self.customFavView];
    self.customFavView.backgroundColor = [UIColor colorWithWhite:0.058 alpha:0.530];
    self.customFavView.favoriteButton.hidden = YES;
    self.customFavView.discussButton.hidden = YES;
    self.customFavView.shareButton.hidden = YES;
    self.customFavView.detailButton.hidden = YES;
    self.customFavView.hidden = YES;
    
    self.BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customFavView.frame.size.height, self.customFavView.frame.size.height)];
    [self.customFavView addSubview:self.BGView];
    
    UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(100, 3, 40, 15)];
    one.text = @"其实，";
    one.textColor = [UIColor whiteColor];
    [self.BGView addSubview:one];
    one.font = [UIFont systemFontOfSize:13];
    
    UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 200, 20)];
    two.textColor = [UIColor whiteColor];
    two.text = @"一直， 最想听的";
    [self.BGView addSubview:two];
    two.font = [UIFont systemFontOfSize:17];
    
    UILabel *three = [[UILabel alloc] initWithFrame:CGRectMake(160, 39, 200, 15)];
    three.text = @"是，遇见你， 心动的声音 ...";
    three.textColor = [UIColor whiteColor];
    three.font = [UIFont systemFontOfSize:12];
    [self.BGView addSubview:three];
//    self.BGView.hidden = YES;

//    // 简介
//    [self.customFavView.detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)detailButtonClicked:(UIButton *)button {
    
//    LPZ_DescriptionVC *detail = [[LPZ_DescriptionVC alloc] init];
//    ZZSongListModel *model = [self.songInfroArray firstObject];
//    //  singerName  songName detail picUrl
//    detail.descriptionDic = [[NSMutableDictionary alloc] init];
//    [detail.descriptionDic setObject:model.title forKey:@"songName"];
//    
//    [detail.descriptionDic setObject:model.desc forKey:@"detail"];
//    
//    [detail.descriptionDic setObject:[model.image objectForKey:@"pic"] forKey:@"picUrl"];
//    
//    
//    [self.navigationController pushViewController:detail animated:YES];
    
}


//// 收藏button点击事件
//- (void)favButtonClicked:(UIButton *)button {
//    
//    self.customFavView.favoriteButton.selected = !self.customFavView.favoriteButton.selected;
//    
//    if (self.customFavView.favoriteButton.selected) {
//        [self.customFavView.favoriteButton setImage:[UIImage imageNamed:@"iconfont-shoucang"] forState:UIControlStateNormal];
//    } else {
//        [self.customFavView.favoriteButton setImage:[UIImage imageNamed:@"iconfont-shoucangweishoucang"] forState:UIControlStateNormal];
//    }
//    
//}


//返回上一个VC
- (void)backTofrontVC {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - tableView 协议相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.songsArray.count) {
        ZZSongsListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
        cell.indexPathRow = indexPath.row;
        ZZSongsModel *model = [self.songsArray objectAtIndex:indexPath.row];
        cell.model = model;
        cell.passVC = self;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.customFavView.hidden = NO;
    self.customStatus.titleLabel.hidden = NO;
    
    if (scrollView.contentOffset.y < - ImageHeight) {
        CGRect frame = self.BGImageView.frame;
        frame.origin.y = scrollView.contentOffset.y;
        frame.size.height = - scrollView.contentOffset.y;
        self.BGImageView.frame = frame;
    }
    
    CGFloat yOffset = scrollView.contentOffset.y;
    
    
    CGFloat alpha = (yOffset + ImageHeight) / ImageHeight;
    
    
    self.customStatus.backgroundColor = [UIColor colorWithRed:130 / 255.f green:197 / 255.f blue:0.001 alpha:alpha];
    self.customStatus.titleLabel.alpha = alpha;
    self.customFavView.alpha = alpha;
    alpha = fabs(alpha);
    alpha = fabs(1 - alpha);
    
    alpha = alpha < 0.2 ? 0 : alpha - 0.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.songsArray.count) {
        return 80;
    } else  {
        return 50;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZZSongsModel *model = [self.songsArray objectAtIndex:indexPath.row];
    //   http://api.dongting.com/song/song/1122152?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F
    
    // http://api.dongting.com/song/singer/1489527
    
    
    NSString *str = [NSString stringWithFormat:@"http://api.dongting.com/song/song/%@", model.songId];
    NSString *songsUrl = [str stringByAppendingString:@"?utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F"];
    
     NSMutableDictionary *songsDictionary = [NSMutableDictionary dictionary];
    
    NSString *singerId = [NSString stringWithFormat:@"http://api.dongting.com/song/singer/%@", model.singerId];
    [HTTPTOOL GETWithURL:singerId body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *ddd = [resu objectForKey:@"data"];
            [songsDictionary setObject:[ddd objectForKey:@"picUrl"] forKey:@"singerPic"];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    [HTTPTOOL GETWithURL:songsUrl body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dic = [resu objectForKey:@"data"];
            
           

            [songsDictionary setObject:[dic objectForKey:@"songId"] forKey:@"songId"];
            [songsDictionary setObject:[dic objectForKey:@"name"] forKey:@"songName"];
            [songsDictionary setObject:[dic objectForKey:@"singerName"] forKey:@"singerName"];
            NSArray *arr = [dic objectForKey:@"auditionList"];
            
            if (arr.count) {
                NSDictionary *dd = [arr objectAtIndex:1];
                [songsDictionary setObject:[dd objectForKey:@"url"] forKey:@"songUrl"];
                [[ZZMusicPlayer shareMusicPlayer].playList addObject:songsDictionary];
                NSLog(@"已加入列表");
                
                if ([ZZMusicPlayer shareMusicPlayer].isPlaying == YES) {
                    [[ZZMusicPlayer shareMusicPlayer].player pause];
                }
                

                [[ZZMusicPlayer shareMusicPlayer] setMusicURLString:[dic objectForKey:@"songUrl"]];
                
                
                [ZZMusicPlayer shareMusicPlayer].indexOfItemInArr = [[ZZMusicPlayer shareMusicPlayer].playList indexOfObject:songsDictionary];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"songsArray" object:nil];
                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
//                [self presentViewController:alert animated:YES completion:^{
//                    
//                }];
//                [self dismissViewControllerAnimated:YES completion:^{
//                    
//                }];

                
            } else {
                NSLog(@"未加入列表");
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"版权原因，暂无法播放" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }
         }
    } fail:^(NSError *error) {
        
    }];
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
