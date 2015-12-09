//
//  ZZEveryDayCell.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZEveryDayCell.h"
#import "ZZEveryDayTableViewCell.h"
#import "ZZEveryDayModel.h"
#import "HTTPTOOL.h"
#import "MJRefresh.h"

@interface ZZEveryDayCell ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger page;




@end

@implementation ZZEveryDayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [self.contentView addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[ZZEveryDayTableViewCell class] forCellReuseIdentifier:@"reuse"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        
        self.isUpLoading = NO;
        
        [self addHeader];
        [self addFooter];
        
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - 刷新
- (void)addHeader {
    
    __block ZZEveryDayCell *day = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        day.isUpLoading = NO;
        day.page = 1;
        [day handleDataWithPage:day.page];
    }];
    [self.tableView.header beginRefreshing];
}

- (void)addFooter {
    __unsafe_unretained ZZEveryDayCell *day = self;
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        day.isUpLoading = YES;
        day.page ++;
        [day handleDataWithPage:day.page];
    }];
}

#pragma mark - 数据处理
- (void)handleDataWithPage:(NSInteger)page {
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.dongting.com/channel/channel/mvs?size=6&page=%ld", self.page];
    
    [HTTPTOOL GETWithURL:urlStr body:nil httpHead:nil resoponseStyle:DATA success:^(id result) {
        if (result) {
            /* 如果是下拉， 数据清空 */
            if (self.isUpLoading == NO) {
                [self.dataArray removeAllObjects];
            }
            id resu = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *arr = [resu objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                
                ZZEveryDayModel *model = [ZZEveryDayModel videoModelWithDictionary:dic];
                [self.dataArray addObject:model];
                
            }
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZEveryDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    ZZEveryDayModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    cell.passVC = self.passVC;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KScreen_Width * 4 / 5 + 50;
}


@end
