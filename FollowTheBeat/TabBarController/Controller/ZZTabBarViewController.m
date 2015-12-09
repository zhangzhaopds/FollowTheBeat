//
//  ZZTabBarViewController.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZTabBarViewController.h"
#import "ZZMainViewController.h"
#import "RESideMenu.h"
#import "ZZTabBarCollectionViewCell.h"
#import "ZZPlayViewController.h"
#import "UMSocial.h"

#import "CoreDataManager.h"
#import "Song.h"

#import "ZZMusicPlayer.h"

#import "ZZMusicModel.h"

@interface ZZTabBarViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UIView *tabBarView;
@property (nonatomic, strong) UICollectionView *collectionOnTabBar;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayOutOnTabBar;

@property (nonatomic, strong) CoreDataManager *manager;
@property (nonatomic, strong) NSArray *songsArray;

@property (nonatomic, strong) ZZMusicPlayer *player;
@property (nonatomic, strong) UIButton *nextBt;
@property (nonatomic, strong) UIButton *pauseBt;
@property (nonatomic, strong) UIButton *favBt;

@end

@implementation ZZTabBarViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"songsArray" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentIndexIn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playerRate" object:nil];
    
}


//- (void)viewWillAppear:(BOOL)animated {
//    
//
//    if (![ZZMusicPlayer shareMusicPlayer].player.rate) {
//        [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-bofang-11"] forState:UIControlStateNormal];
//        
//        
//    } else {
//        
//        [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-zanting-4"] forState:UIControlStateNormal];
//    }
//
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.manager = [CoreDataManager manager];
    self.songsArray = [NSArray array];
    
    self.player = [ZZMusicPlayer shareMusicPlayer];
    
    ZZMainViewController *main = [[ZZMainViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:main];
    
    self.viewControllers = @[navi];


    [self creatTabBarView];
    
    
    [self handleData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songsArrayChange) name:@"songsArray" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentIndexIn) name:@"currentIndexIn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerRate) name:@"playerRate" object:nil];
}

- (void)playerRate {
    
//    NSLog(@"000:");
    if (![ZZMusicPlayer shareMusicPlayer].player.rate) {
        [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-bofang-11"] forState:UIControlStateNormal];
    
    
    } else {
    
        [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-zanting-4"] forState:UIControlStateNormal];
    }
}


- (void)songsArrayChange {
    
    [self handleData];
    [self.collectionOnTabBar reloadData];


}

- (void)currentIndexIn {
    self.collectionOnTabBar.contentOffset = CGPointMake([ZZMusicPlayer shareMusicPlayer].indexOfItemInArr * self.flowLayOutOnTabBar.itemSize.width, 0);
    [self.collectionOnTabBar reloadData];
}

#pragma mark - 数据处理
- (void)handleData {
    
    self.songsArray = [NSArray arrayWithArray:self.player.playList];
    
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    
    if (!music.playList.count) {
        return;
    }
    NSDictionary *dci = [music.playList objectAtIndex:music.indexOfItemInArr];
    NSString *url = [dci objectForKey:@"songUrl"];
    
    [music setMusicURLString:url];
    [music.player play];
}


/* 自定义 tabBar */
- (void)creatTabBarView {
    
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreen_Height - 50, KScreen_Width, 50)];
    [self.view addSubview:self.tabBarView];
    self.tabBarView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.290];
    
    // 暂停
    self.pauseBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabBarView addSubview:self.pauseBt];
    
    self.pauseBt.frame = CGRectMake(KScreen_Width - 100, 10, 30, 30);
    [self.pauseBt addTarget:self action:@selector(currentSongBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-bofang-11"] forState:UIControlStateNormal];
    [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-zanting-4"] forState:UIControlStateNormal];
    
    
    // 下一曲
    self.nextBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabBarView addSubview:self.nextBt];
    self.nextBt.frame = CGRectMake(KScreen_Width - 50, 10, 30, 30);
    [self.nextBt addTarget:self action:@selector(nextBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBt setImage:[UIImage imageNamed:@"iconfont-ttpodicon-5"] forState:UIControlStateNormal];
    
    // 收藏
    self.favBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabBarView addSubview:self.favBt];
    self.favBt.frame = CGRectMake(KScreen_Width - 150, 13, 25, 25);
    [self.favBt addTarget:self action:@selector(favBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.favBt setImage:[UIImage imageNamed:@"iconfont-shoucangweishoucang-3"] forState:UIControlStateNormal];
        
    [self creatCollectionView];
}

// 收藏
- (void)favBt:(UIButton *)favBt {
    
    if (![ZZMusicPlayer shareMusicPlayer].playList.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请添加歌曲" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        return;
    }
//    favBt.selected = !favBt.selected;
//    
//    if (favBt.selected) {
//        [self.favBt setImage:[UIImage imageNamed:@"iconfont-shoucangyishoucang"] forState:UIControlStateNormal];
//    } else {
//        [self.favBt setImage:[UIImage imageNamed:@"iconfont-shoucangweishoucang-3"] forState:UIControlStateNormal];
//    }
    
    NSDictionary *dic = [[ZZMusicPlayer shareMusicPlayer].playList objectAtIndex:[ZZMusicPlayer shareMusicPlayer].indexOfItemInArr];
    NSString *str = [NSString stringWithFormat:@"%@\n%@", [dic objectForKey:@"songName"], [dic objectForKey:@"songUrl"]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5613563067e58e3e17001756" shareText:str shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToTencent, nil] delegate:self];
    
}

// 下一曲
- (void)nextBt:(UIButton *)button {
    
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    
    music.indexOfItemInArr ++;
    
    if (!music.playList.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请添加歌曲" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

        return;
    }
    
    if (music.indexOfItemInArr == music.playList.count) {
        music.indexOfItemInArr = 0;
    }
    
    NSDictionary *dci = [music.playList objectAtIndex:music.indexOfItemInArr];
    NSString *url = [dci objectForKey:@"songUrl"];
    
    [music setMusicURLString:url];
    
    [music.player play];
    
    self.collectionOnTabBar.contentOffset = CGPointMake(music.indexOfItemInArr * self.flowLayOutOnTabBar.itemSize.width, 0);
    
}

// 暂停
- (void)currentSongBtn:(UIButton *)button {
    
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    
    if (!music.playList.count) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请添加歌曲" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

        return;
    }

    if (![ZZMusicPlayer shareMusicPlayer].player.rate) {
        [music.player play];
        [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-zanting-4"] forState:UIControlStateNormal];
    } else {
        [music.player pause];
        [self.pauseBt setImage:[UIImage imageNamed:@"iconfont-bofang-11"] forState:UIControlStateNormal];
    }
}


#pragma mark - 创建collectionView

- (void)creatCollectionView {

    
    self.flowLayOutOnTabBar = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayOutOnTabBar.itemSize = CGSizeMake(KScreen_Width * 2 / 3 - 50, 50);
    self.flowLayOutOnTabBar.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayOutOnTabBar.minimumLineSpacing = 0;
    
    self.collectionOnTabBar = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width * 2 / 3 - 50, 50) collectionViewLayout:self.flowLayOutOnTabBar];
    [self.tabBarView addSubview:self.collectionOnTabBar];
    
    self.collectionOnTabBar.showsHorizontalScrollIndicator = NO;
    self.collectionOnTabBar.showsVerticalScrollIndicator = NO;
    
    self.collectionOnTabBar.pagingEnabled = YES;
    self.collectionOnTabBar.backgroundColor = [UIColor clearColor];
    
    self.collectionOnTabBar.delegate = self;
    self.collectionOnTabBar.dataSource = self;
    
    [self.collectionOnTabBar registerClass:[ZZTabBarCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    
    
}

#pragma mark - 滑动切歌
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    
    NSInteger currentIndex = point.x / self.flowLayOutOnTabBar.itemSize.width;
    
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    music.indexOfItemInArr = currentIndex;
    
    if (!music.playList.count) {
        return;
    }
    
    NSDictionary *dci = [music.playList objectAtIndex:music.indexOfItemInArr];
    NSString *url = [dci objectForKey:@"songUrl"];
    
    [music setMusicURLString:url];
    
    [music.player play];
   
}


#pragma mark - collectionView协议相关方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.songsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTabBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    ZZMusicModel *model = [ZZMusicModel songsModelWithDictionary:[self.songsArray objectAtIndex:indexPath.row]];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
    ZZPlayViewController *play = [[ZZPlayViewController alloc] init];
    [self presentViewController:play animated:YES completion:^{

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
