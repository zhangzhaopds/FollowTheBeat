//
//  ZZMVAreaVC.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMVAreaVC.h"
#import "ZZCustomStatusView.h"
#import "ZZEveryDayCell.h"
#import "HTTPTOOL.h"
#import "ZZEveryDayModel.h"
#import "ZZMVFenLeiCell.h"
#import "ZZSearchMVVC.h"

@interface ZZMVAreaVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *everyDayLabel;
@property (nonatomic, strong) UILabel *mvFenLeiLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayOut;

@end

@implementation ZZMVAreaVC

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatCollectionView];
    
    [self setupUI];
    
    
}





#pragma mark - 视图创建
- (void)setupUI {
    
    // 状态栏
    ZZCustomStatusView *customStatus = [[ZZCustomStatusView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:customStatus];
    customStatus.BGImageView.backgroundColor = KButton_Color;
    customStatus.titleLabel.text = @"MV专区";
    customStatus.titleLabel.textColor = [UIColor whiteColor];
    customStatus.titleLabel.font = [UIFont systemFontOfSize:23];
    customStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //返回button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [customStatus addSubview:back];
    [back setImage:[UIImage imageNamed:@"iconfont-xiangzuo"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backTofrontVC) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(10, 20, 40, 40);
    
    //    // 搜索button
    //    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [customStatus addSubview:search];
    //    [search setImage:[UIImage imageNamed:@"iconfont-fangdajing"] forState:UIControlStateNormal];
    //    [search addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    //    search.frame = CGRectMake(KScreen_Width - 50, 25, 30, 30);
    //
    // 每日一发
    self.everyDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KNaviBar_Height, KScreen_Width / 2, 40)];
    [self.view addSubview:self.everyDayLabel];
    self.everyDayLabel.text = @"每日一发";
    self.everyDayLabel.textColor = KButton_Color;
    self.everyDayLabel.textAlignment = NSTextAlignmentCenter;
    self.everyDayLabel.backgroundColor = [UIColor colorWithWhite:0.917 alpha:1.000];
    self.everyDayLabel.userInteractionEnabled = YES;
    
    
    //MVv分类
    self.mvFenLeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width / 2, KNaviBar_Height, KScreen_Width / 2, 40)];
    [self.view addSubview:self.mvFenLeiLabel];
    self.mvFenLeiLabel.text = @"MV分类";
    self.mvFenLeiLabel.textAlignment = NSTextAlignmentCenter;
    self.mvFenLeiLabel.textColor = KButton_Color;
    self.mvFenLeiLabel.backgroundColor = [UIColor colorWithWhite:0.917 alpha:1.000];
    self.mvFenLeiLabel.userInteractionEnabled = YES;
    
    // 绿色的线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height + 39, KScreen_Width / 2, 3)];
    [self.view addSubview:self.lineView];
    self.lineView.backgroundColor = KButton_Color;
   
    
    
    // 搜索按钮
    UIButton *searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [customStatus addSubview:searchBt];
    searchBt.frame = CGRectMake(customStatus.frame.size.width - 60, 20, 40, 40);
    [searchBt setImage:[UIImage imageNamed:@"iconfont-sousuo-2"] forState:UIControlStateNormal];
    [searchBt addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)search:(UIButton *)search {
    
    ZZSearchMVVC *sear = [[ZZSearchMVVC alloc] init];
    [self.navigationController pushViewController:sear animated:YES];
    
}

//返回上一个VC
- (void)backTofrontVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.everyDayLabel) {
        self.collectionView.contentOffset = CGPointMake(0, 0);
        
    } else if (touch.view == self.mvFenLeiLabel) {
        self.collectionView.contentOffset = CGPointMake(KScreen_Width, 0);
    }
}
#pragma mark - collectionView 相关
- (void)creatCollectionView {
    
    self.flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayOut.itemSize = CGSizeMake(KScreen_Width, KScreen_Height - KNaviBar_Height - KTabBar_Height - 42);
    self.flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayOut.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNaviBar_Height + 40, KScreen_Width, KScreen_Height - KNaviBar_Height - KTabBar_Height - 40) collectionViewLayout:self.flowLayOut];
    [self.view addSubview:self.collectionView];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.948 alpha:1.000];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.collectionView registerClass:[ZZEveryDayCell class] forCellWithReuseIdentifier:@"mv"];
    [self.collectionView registerClass:[ZZMVFenLeiCell class] forCellWithReuseIdentifier:@"reuse"];
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGPoint point = [[change objectForKey:@"new"] CGPointValue];
    
    
    self.lineView.frame = CGRectMake(point.x / 2, KNaviBar_Height + 40, KScreen_Width / 2, 2);
    
    if (point.x == 0) {
        self.everyDayLabel.textColor = KButton_Color;
        self.mvFenLeiLabel.textColor = [UIColor grayColor];
    } else if (point.x == KScreen_Width){
        self.everyDayLabel.textColor = [UIColor grayColor];
        self.mvFenLeiLabel.textColor = KButton_Color;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!indexPath.item) {
        ZZEveryDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mv" forIndexPath:indexPath];
        cell.passVC = self;
        return cell;
    } else {
        ZZMVFenLeiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
        cell.passVC = self;
        return cell;
    }
    
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
