//
//  ZZNewsListVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/8.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZNewsListVC.h"
#import "ZZCustomStatusView.h"
#import "HTTPTOOL.h"
#import "MJRefresh.h"
#import "ZZNewsModel.h"
#import "ZZNewsListCell.h"
#import "ZZNewsDetailVC.h"


@interface ZZNewsListVC ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, strong) ZZCustomStatusView *customStatus;
@property (nonatomic, strong) UITableView *tableView;



@end

@implementation ZZNewsListVC
//  今日精选

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    [self creatStatusView];
    
    self.isUpLoading = NO;
    
    [self creatTableView];
    
    [self addHeader];
    [self addFooter];
  
}

#pragma mark - 数据处理
- (void)handleData {
    
    //  http://c.3g.163.com/recommend/getSubDocNews?from=yuedu&size=20
    
    NSString *urlStr = @"http://c.3g.163.com/recommend/getSubDocPic?from=yuedu&size=20&passport=&devId=93FMifag0zz%2FpjA98uHxUA%3D%3D&lat=&lon=&version=5.4.0&net=wifi&ts=1446966246&sign=aHCc7gwWlATXMN5GpYhk8tHmzrLnBod07B8N5MzNp1J48ErR02zJ6%2FKXOnxX046I&encryption=1";
    [HTTPTOOL GETWithURL:urlStr body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            
            if (!self.isUpLoading) {
                [self.dataArray removeAllObjects];
            }
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = [resu objectForKey:@"推荐"];
            for (NSDictionary *dic in array) {
                ZZNewsModel *model = [ZZNewsModel newsModelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - 刷新
- (void)addHeader {
    
    __block ZZNewsListVC *more = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        more.isUpLoading = NO;
       
        
        [more handleData];
        
    }];
    [self.tableView.header beginRefreshing];
}

- (void)addFooter {
    __block ZZNewsListVC *more = self;
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        more.isUpLoading = YES;
      
        [more handleData];
        
    }];
}

#pragma mark - 自定义标题栏
- (void)creatStatusView {
    
    self.customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.customStatus];
    self.customStatus.backgroundColor = KButton_Color;
    
    self.customStatus.titleLabel.text = @"推荐阅读";
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

#pragma mark - tabelView
- (void)creatTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height, KScreen_Width, KScreen_Height - KNaviBar_Height - KTabBar_Height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = 140;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.935 alpha:1.000];
    [self.tableView registerClass:[ZZNewsListCell class] forCellReuseIdentifier:@"reuse"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    ZZNewsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZNewsDetailVC *detail = [[ZZNewsDetailVC alloc] init];
    ZZNewsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    detail.passId = [NSString stringWithFormat:@"%@", model.docid];
    [self.navigationController pushViewController:detail animated:YES];
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
