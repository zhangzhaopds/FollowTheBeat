//
//  ZZMVFenLeiCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMVFenLeiCell.h"
#import "HTTPTOOL.h"
#import "MJRefresh.h"
#import "ZZMVlistModel.h"  // mv分类 的model 一样
#import "ZZMVCustomCell.h"
#import "ZZMVPlayerVC.h"

@interface ZZMVFenLeiCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayOut;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZZMVFenLeiCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        self.lineView.backgroundColor = KButton_Color;
        
        self.segment = [[UISegmentedControl alloc] initWithItems:@[@"最热", @"最新"]];
        [self.contentView addSubview:self.segment];
        self.segment.tintColor = [UIColor clearColor];
        NSDictionary *norDic = @{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        NSDictionary *selectedDic = @{NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor colorWithRed:130 / 255.f green:197/255.f blue:0 alpha:1]};
        [self.segment setTitleTextAttributes:norDic forState:UIControlStateNormal];
        [self.segment setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
        [self.segment addTarget:self action:@selector(segment:) forControlEvents:UIControlEventValueChanged];
        self.segment.selectedSegmentIndex = 0;
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 70, 20, 1, 22)];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = KButton_Color;
        
        
        
        self.flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayOut.itemSize = CGSizeMake((KScreen_Width - 30) / 2, 140);
        self.flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.flowLayOut.minimumLineSpacing = 5;
        self.flowLayOut.minimumInteritemSpacing = 10;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, KNaviBar_Height, KScreen_Width - 20, KScreen_Height - KNaviBar_Height - 120 - KTabBar_Height) collectionViewLayout:self.flowLayOut];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.947 alpha:1.000];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.collectionView registerClass:[ZZMVCustomCell class] forCellWithReuseIdentifier:@"fenlei"];
        
        
        self.isUpLoading = NO;
        self.order = 2;
        [self addHeader];
        [self addFooter];
    }
    return self;
}

- (void)segment:(UISegmentedControl *)seg {
    if (!seg.selectedSegmentIndex) {
        
        self.order = 2;
        [self addHeader];
        
    } else {
        
        self.order = 1;
        [self addHeader];
    }
    
}

#pragma mark - 刷新
- (void)addHeader {
    
    __weak ZZMVFenLeiCell *day = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        
        day.isUpLoading = NO;
        day.page = 1;
        
        [day handleDataWithPage:day.page withOrder:day.order];
    }];
    [self.collectionView.header beginRefreshing];
}

- (void)addFooter {
    __weak ZZMVFenLeiCell *day = self;
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        
        day.isUpLoading = YES;
        day.page ++;
        [day handleDataWithPage:day.page withOrder:day.order];
    }];
}

#pragma mark - 数据处理
- (void)handleDataWithPage:(NSInteger)page withOrder:(NSInteger)order {
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dongting.com/song/video/type/0?size=12&page=%ld&order=%ld", self.page, self.order];
    
    [HTTPTOOL GETWithURL:urlString body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            /* 如果是下拉， 数据清空 */
            if (self.isUpLoading == NO) {
                [self.dataArray removeAllObjects];
            }
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *arr = [resu objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                
                ZZMVlistModel *model = [ZZMVlistModel mvListModelWithDictionary:dic];
                
                
                NSDictionary *dd = [[dic objectForKey:@"mvList"] firstObject];
                [model setValuesForKeysWithDictionary:dd];
                
                [self.dataArray addObject:model];
            }
            [self.collectionView reloadData];
            [self.collectionView.footer endRefreshing];
            [self.collectionView.header endRefreshing];
            
            
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    self.segment.frame = CGRectMake(self.contentView.frame.size.width - 130, 10, 120, 40);
    self.lineView.frame = CGRectMake(10, 45, self.contentView.frame.size.width - 20, 0.5);
    
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
    
    [self.passVC.navigationController pushViewController:player animated:YES];
    
}

@end
