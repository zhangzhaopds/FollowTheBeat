//
//  ZZSongsAlbumVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/8.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSongsAlbumVC.h"
#import "MJRefresh.h"
#import "HTTPTOOL.h"
#import "ZZMusicAlbumModel.h"
#import "ZZCustomMusicCell.h"
#import "ZZSongsListVC.h"
#import "ZZCustomStatusView.h"
#import "ZZSearchSongsVC.h"


@interface ZZSongsAlbumVC ()<UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, strong) ZZCustomStatusView *customStatus;


@end


@implementation ZZSongsAlbumVC


- (void)viewDidLoad {
    
    self.dataArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatStatusView];
    [self creatCollectionView];
    self.isUpLoading = NO;
    
    [self addHeader];
    [self addFooter];
}




#pragma mark - 数据处理
- (void)handleDataWithPage:(NSInteger)page {
    
    //  http://so.ard.iyyin.com/s/songlist?s=s200&size=10&hid=3440797830465736&utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F&q=tag%3A%E6%9C%80%E7%83%AD&net=2&app=ttpod&v=v8.2.0.2015091720&alf=alf10002668&tid=194420874&uid=867570027906266&f=ff8000&page=1&imsi=460012654402963
    
    
    NSString *str = [NSString stringWithFormat:@"page=%ld&imsi=460012654402963", self.page];
    NSString *url = [@"http://so.ard.iyyin.com/s/songlist?s=s200&size=10&hid=3440797830465736&utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F&q=tag%3A%E6%9C%80%E7%83%AD&net=2&app=ttpod&v=v8.2.0.2015091720&alf=alf10002668&tid=194420874&uid=867570027906266&f=ff8000&" stringByAppendingString:str];
    
    [HTTPTOOL GETWithURL:url body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        
        if (result) {
            
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = [resu objectForKey:@"data"];
            if (!self.isUpLoading) {
                [self.dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in arr) {
                ZZMusicAlbumModel *model = [ZZMusicAlbumModel musicAlbumModelWithDictionary:dic];
                [self.dataArray addObject:model];
                
            }
            
            [self.collectionView reloadData];
            [self.collectionView.header endRefreshing];
            [self.collectionView.footer endRefreshing];
        }
    } fail:^(NSError *error) {
        
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];

        
    }];
}

#pragma mark - 刷新
- (void)addHeader {
    
    __block ZZSongsAlbumVC *more = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        more.isUpLoading = NO;
        more.page = 1;
        
        [more handleDataWithPage:more.page];
        
    }];
    [self.collectionView.header beginRefreshing];
}

- (void)addFooter {
    __block ZZSongsAlbumVC *more = self;
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        more.isUpLoading = YES;
        more.page ++;
        [more handleDataWithPage:more.page];
        
    }];
}

#pragma mark - 自定义标题栏
- (void)creatStatusView {
    
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    self.customStatus.backgroundColor = KButton_Color;
    
    self.customStatus.titleLabel.text = @"精选专辑";
    self.customStatus.titleLabel.textColor = [UIColor whiteColor];
    self.customStatus.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    self.customStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customStatus addSubview:back];
    [back setImage:[UIImage imageNamed:@"iconfont-xiangzuo"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backTofrontVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(10, 20, 40, 40);
    
    
    // 搜索按钮
    UIButton *searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.customStatus addSubview:searchBt];
    searchBt.frame = CGRectMake(self.customStatus.frame.size.width - 60, 20, 40, 40);
    [searchBt setImage:[UIImage imageNamed:@"iconfont-sousuo-2"] forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)search:(UIButton *)search {
    
    ZZSearchSongsVC *sear = [[ZZSearchSongsVC alloc] init];
    [self.navigationController pushViewController:sear animated:YES];
    
}




- (void)backTofrontVC {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collection
- (void)creatCollectionView {
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake((KScreen_Width - 30) / 2, 150);
    
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10 + KNaviBar_Height, KScreen_Width - 20, KScreen_Height - KNaviBar_Height - KTabBar_Height - 10) collectionViewLayout:flow];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"48413"]];
    //    self.collectionView.backgroundView = bgView;
    //    self.collectionView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource  = self;
    
    [self.collectionView registerClass:[ZZCustomMusicCell class] forCellWithReuseIdentifier:@"reuse"];
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCustomMusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    ZZMusicAlbumModel *model = [[ZZMusicAlbumModel alloc] init];
    
    model = [self.dataArray objectAtIndex:indexPath.item];
    
    cell.model = model;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZMusicAlbumModel *model = nil;
    model = [self.dataArray objectAtIndex:indexPath.item];
    
    ZZSongsListVC *song = [[ZZSongsListVC alloc] init];
    song.quan_id = model.quan_id;
    
    [self.navigationController pushViewController:song animated:YES];
    
    
    
    
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
