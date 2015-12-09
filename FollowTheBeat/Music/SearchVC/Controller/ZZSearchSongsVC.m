//
//  ZZSearchSongsVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/11.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSearchSongsVC.h"
#import "ZZCustomStatusView.h"
#import "HTTPTOOL.h"
#import "ZZSongsModel.h"
#import "ZZSongsListTVC.h"
#import "ZZMusicPlayer.h"

@interface ZZSearchSongsVC ()<UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZZCustomStatusView *customStatus;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation ZZSearchSongsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"songList" object:nil];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchArray = [NSMutableArray array];
    
    [self creatStatusView];
    
    [self creatSearchController];
    
    [self creatTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedButton:) name:@"songList" object:nil];
    
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
                
                [alert dismissViewControllerAnimated:YES completion:^{
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
- (void)handleData {
    
    NSString *urlStr = @"http://api.dongting.com/misc/search/song?s=s200&cpu_model=MT6753&client_id=8ec0a0acb519890408dc6996811a10d3&mid=m2%2Bnote&size=50&utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F&q=";
    if (!self.searchKey) {
        return;
    }
    NSString *url = [urlStr stringByAppendingString:self.searchKey];
  
    NSString *encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [HTTPTOOL GETWithURL:encodingString body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            
            [self.searchArray removeAllObjects];
            
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:resu];
            
            NSArray *songs = [dic objectForKey:@"data"];
            
            for (NSDictionary *dd in songs) {
                
                ZZSongsModel *songsModel = [ZZSongsModel songsModelWithDictionary:dd];
                [self.searchArray addObject:songsModel];
                
                
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    
}


#pragma mark - 自定义标题栏
- (void)creatStatusView {
    
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    self.customStatus.backgroundColor = KButton_Color;
    
    self.customStatus.titleLabel.text = @"单曲搜索";
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

#pragma mark - 搜索
- (void)creatSearchController {
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height, KScreen_Width, 38)];
    [self.view addSubview:self.searchView];
    self.searchView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:0.590];
    self.searchView.layer.cornerRadius = 5;
    self.searchView.layer.masksToBounds = YES;
    [self.view sendSubviewToBack:self.searchView];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.searchView.frame.size.width, self.searchView.frame.size.height);
    [self.searchController.searchBar sizeToFit];
    [self.searchView addSubview:self.searchController.searchBar];
    
    for (UIView *subView in self.searchController.searchBar.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UIView")] && subView.subviews.count > 0) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
        
    }
    
    self.searchController.searchBar.barStyle = UIBarStyleDefault;
    
    self.searchController.searchBar.keyboardType = UIKeyboardAppearanceDefault;

    self.searchController.searchBar.placeholder = @"请输入要搜索的歌名";
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.searchKey = [self.searchController.searchBar text];
    if (!self.searchKey.length) {
        return;
    }
    [self handleData];
    
}

#pragma mark - tableView
- (void)creatTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height + 50, KScreen_Width, KScreen_Height - KNaviBar_Height - 50) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.947 alpha:1.000];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[ZZSongsListTVC class] forCellReuseIdentifier:@"reuse"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZSongsListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    cell.indexPathRow = indexPath.row;
    
    ZZSongsModel *model = [self.searchArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    cell.passVC = self.searchController;
    
    return cell;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZZSongsModel *model = [self.searchArray objectAtIndex:indexPath.row];
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
                
            } else {
                NSLog(@"未加入列表");
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
