//
//  ZZSearchMVVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/11.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZSearchMVVC.h"
#import "ZZMVPlayerVC.h"
#import "ZZMVlistModel.h"
#import "HTTPTOOL.h"
#import "ZZCustomStatusView.h"
#import "ZZMVCustomCell.h"

@interface ZZSearchMVVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating>
@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayOut;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ZZCustomStatusView *customStatus;

@end

@implementation ZZSearchMVVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    
    [self creatSearchController];
    
    [self creatCollectionView];
    
    [self creatStatusView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 数据处理
- (void)handleData{
    
    
    NSString *urlStr = @"http://so.ard.iyyin.com/s/video?s=s200&size=50&hid=3440797830465736&utdid=ViMjdRYRNSwDAMXlRjOtfvY%2F&q=";
    if (!self.searchKey) {
        return;
    }
    NSString *url = [urlStr stringByAppendingString:self.searchKey];
    url = [url stringByAppendingString:@"&net=2&app=ttpod&v=v8.3.0.2015110214&alf=alf228200&tid=194420874&uid=867570027906266&f=f268&page=1&imsi=460012654402963"];
    NSString *encodingString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [HTTPTOOL GETWithURL:encodingString body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            [self.dataArray removeAllObjects];
            
            NSArray *arr = [resu objectForKey:@"data"];
            if (!arr.count) {
                return;
            }
            for (NSDictionary *dic in arr) {
                
                ZZMVlistModel *model = [ZZMVlistModel mvListModelWithDictionary:dic];
                
                
                NSDictionary *dd = [[dic objectForKey:@"mvList"] firstObject];
                [model setValuesForKeysWithDictionary:dd];
                
                [self.dataArray addObject:model];
            }
            [self.collectionView reloadData];
            

        }
    } fail:^(NSError *error) {
        
    }];
   
}


#pragma mark - 自定义标题栏
- (void)creatStatusView {
    
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    self.customStatus.backgroundColor = KButton_Color;
    
    self.customStatus.titleLabel.text = @"MV搜索";
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
    
    self.searchController.searchBar.placeholder = @"请输入要搜索的MV";
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.searchKey = [self.searchController.searchBar text];
    if (!self.searchKey.length) {
        return;
    }
    [self handleData];
    
}



#pragma mark - creatCollectionView
- (void)creatCollectionView {
    self.flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayOut.itemSize = CGSizeMake((KScreen_Width - 30) / 2, 140);
    self.flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayOut.minimumLineSpacing = 5;
    self.flowLayOut.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, KNaviBar_Height + 50, KScreen_Width - 20, KScreen_Height - KNaviBar_Height - 40) collectionViewLayout:self.flowLayOut];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.947 alpha:1.000];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ZZMVCustomCell class] forCellWithReuseIdentifier:@"fenlei"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZMVCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fenlei" forIndexPath:indexPath];
    
    ZZMVlistModel *model = [self.dataArray objectAtIndex:indexPath.item];
    cell.model = model;
   
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
  
    ZZMVlistModel *model = [self.dataArray objectAtIndex:indexPath.item];
    
    
    ZZMVPlayerVC *player = [[ZZMVPlayerVC alloc] init];
    player.mvPlayerDic = [NSMutableDictionary dictionary];
    
    [player.mvPlayerDic setObject:model.singerName forKey:@"singerNamer"];
    [player.mvPlayerDic setObject:model.videoName forKey:@"videoName"];
    [player.mvPlayerDic setObject:model.picUrl forKey:@"picUrl"];
    [player.mvPlayerDic setObject:model.url forKey:@"url"];
    
    [self.navigationController pushViewController:player animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
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
