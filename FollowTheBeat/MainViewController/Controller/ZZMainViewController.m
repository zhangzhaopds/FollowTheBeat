//
//  ZZMainViewController.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/19.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZMainViewController.h"
#import "RESideMenu.h"
#import "ZZMusicCollectionCell.h"
#import "ZZMovieCollectionCell.h"
#import "ZZReadCollectionCell.h"
#import "ZZMVAreaVC.h"
#import "ZZPlayViewController.h"
#import "ZZMusicPlayer.h"
#import "ZZGameImageView.h"

#define KEveryNumber ([UIScreen mainScreen].bounds.size.width - 60) / 3

@interface ZZMainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *FlowLayOut;

@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic, strong) UILabel *tuiJianLabel;
@property (nonatomic, strong) UILabel *findLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *gameView;

@property (nonatomic, strong) UIImageView *tempImage;
@property (nonatomic, strong) ZZGameImageView *imgView;
@property (nonatomic, strong) UIImage *GameBGImage;
@property (nonatomic, strong) UIButton *changeBGImage;


@end

@implementation ZZMainViewController

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"search" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"move" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatcollectionView];
    
    [self creatNavigationBar];
   
    [self readPicturesFromLocal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSearchBar) name:@"search" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movedeciton:) name:@"move" object:nil];
  
}

- (void)removeSearchBar {
    [super viewWillDisappear:YES];
    
}



#pragma mark - 自定义标题栏 NavigationBar
- (void)creatNavigationBar {
    
    /* 自定义 naviBar */
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KNaviBar_Height)];
    [self.view addSubview:self.barView];
    self.barView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.550];
    
    /* 添加返回到 抽屉 的button */
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 30, 26, 26);
    [self.barView addSubview:backButton];
   
    [backButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"iconfont-sigekuang"] forState:UIControlStateNormal];
    
    
    
    [self creatThirdTitleLabel];
    
}
#pragma mark -
- (void)creatThirdTitleLabel {
    
    /* 我的 */
    
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 27, (KScreen_Width - 80) / 4, 33)];
    [self.view addSubview:self.myLabel];
    self.myLabel.text = @"聆听";
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    self.myLabel.userInteractionEnabled = YES;
    self.myLabel.textColor = KButton_Color;
    self.myLabel.font = [UIFont systemFontOfSize:20];
    
    /* 推荐 */
    self.tuiJianLabel = [[UILabel alloc] initWithFrame:CGRectMake(70 + (KScreen_Width - 80) / 4, 27, (KScreen_Width - 80) / 4, 33)];
    [self.view addSubview:self.tuiJianLabel];
    self.tuiJianLabel.text = @"欣赏";
    self.tuiJianLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
    self.tuiJianLabel.textAlignment = NSTextAlignmentCenter;
    self.tuiJianLabel.userInteractionEnabled = YES;
    self.tuiJianLabel.font = [UIFont systemFontOfSize:20];
    
    /* 发现 */
    self.findLabel = [[UILabel alloc] initWithFrame:CGRectMake(70 + (KScreen_Width - 80) / 2, 27, (KScreen_Width - 80) / 4, 33)];
    [self.view addSubview:self.findLabel];
    self.findLabel.textAlignment = NSTextAlignmentCenter;
    self.findLabel.text = @"阅读";
    self.findLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
    self.findLabel.userInteractionEnabled = YES;
    self.findLabel.font = [UIFont systemFontOfSize:20];
    
    /* 下划线 */
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(70, 62, (KScreen_Width - 80) / 4, 2)];
    [self.view addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.lineView];
    
    
    // 游戏笑脸
    UIButton *smile = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:smile];
    [smile setImage:[UIImage imageNamed:@"iconfont-sandian"] forState:UIControlStateNormal];
    [smile addTarget:self action:@selector(playGame:) forControlEvents:UIControlEventTouchUpInside];
    smile.frame = CGRectMake(KScreen_Width - 40, 29, 30, 25);
    
    // 游戏界面
    self.gameView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, KScreen_Width - 60, KScreen_Width - 60)];
    self.gameView.center = self.view.center;
    self.gameView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.gameView];
    self.gameView.hidden = YES;
    self.gameView.layer.borderWidth = 5;
    self.gameView.layer.borderColor = [UIColor colorWithWhite:1.000 alpha:0.360].CGColor;
    
    
    // 获取本地照片，更换游戏背景照片
    self.changeBGImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.changeBGImage];
    self.changeBGImage.frame = CGRectMake(KScreen_Width - 90, self.gameView.frame.origin.y + KScreen_Width - 60, 60, 20);
    self.changeBGImage.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.260];
    [self.changeBGImage setTitle:@"点击换图" forState:UIControlStateNormal];
    self.changeBGImage.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.changeBGImage addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
    self.changeBGImage.hidden = YES;
    
}

//推出游戏界面
- (void)playGame:(UIButton *)but {
    
    but.selected = !but.selected;
    if (but.selected) {
        self.gameView.hidden = NO;
        self.changeBGImage.hidden = NO;
        
    } else {
        self.gameView.hidden = YES;
        self.changeBGImage.hidden = YES;
        
    }
}

#pragma mark - 我的 推荐 发现 三者的切换
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self.myLabel) {
       
        self.myLabel.textColor = KButton_Color;
        self.tuiJianLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.findLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.collectionView.contentOffset = CGPointMake(0, 0);
    }
    if (touch.view == self.tuiJianLabel) {

        self.myLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.tuiJianLabel.textColor = KButton_Color;
        self.findLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.collectionView.contentOffset = CGPointMake(KScreen_Width, 0);
    }
    
    if (touch.view == self.findLabel) {
        self.myLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.tuiJianLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.findLabel.textColor = KButton_Color;
        self.collectionView.contentOffset = CGPointMake(KScreen_Width * 2, 0);
    }
}

#pragma mark - collectionView 创建
- (void)creatcollectionView {
    self.FlowLayOut = [[UICollectionViewFlowLayout alloc] init];
    self.FlowLayOut.itemSize = CGSizeMake(KScreen_Width, KScreen_Height);
    
    self.FlowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.FlowLayOut.minimumLineSpacing = 0;
   
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, KScreen_Height) collectionViewLayout:self.FlowLayOut];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[ZZMusicCollectionCell class] forCellWithReuseIdentifier:@"reuse"];
    [self.collectionView registerClass:[ZZMovieCollectionCell class] forCellWithReuseIdentifier:@"recom"];
    [self.collectionView registerClass:[ZZReadCollectionCell class] forCellWithReuseIdentifier:@"discover"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.item == 0) {
        ZZMusicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
        cell.passVC = self;
        return cell;
    } else if (indexPath.item == 1) {
        ZZMovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recom" forIndexPath:indexPath];
        cell.passVC = self;
        return cell;
    } else {
        ZZReadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"discover" forIndexPath:indexPath];
        cell.passVC = self;
        return cell;
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGPoint point = [[change objectForKey:@"new"] CGPointValue];
    self.lineView.frame = CGRectMake(70 + point.x * (KScreen_Width - 80) / 4 / KScreen_Width, 61, (KScreen_Width - 80) / 4, 2);
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = self.collectionView.contentOffset;
    if (point.x == 0) {
        self.myLabel.textColor = KButton_Color;
        self.tuiJianLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.findLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
       
    }
    if (point.x == KScreen_Width) {
     
        self.myLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.tuiJianLabel.textColor = KButton_Color;
        self.findLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
    }
    
    if (point.x == KScreen_Width * 2) {
        self.myLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.tuiJianLabel.textColor = [UIColor colorWithWhite:0.743 alpha:0.760];
        self.findLabel.textColor = KButton_Color;
       
    }
}

#pragma mark - 游戏界面
- (void)readPicturesFromLocal {
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    dict = [self SeparateImage:self.GameBGImage ByX:3 andY:3 cacheQuality:1];
    
    self.tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(2 * KEveryNumber, 2 * KEveryNumber, KEveryNumber, KEveryNumber)];
    self.tempImage.tag = 100;
//    self.tempImage.backgroundColor = [UIColor redColor];
//    self.tempImage.image = self.GameBGImage;
    [self.gameView addSubview:self.tempImage];
    for(int i = 0;i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *filepath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"win_%d_%d.jpg", i, j]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            
            self.imgView = [[ZZGameImageView alloc] initWithImage:image];
            
            self.imgView.tag = i * 2 + j;
            if(i == 1)
            {
                self.imgView.tag = i * 2 + j + 1;
            }
            if(i == 2)
            {
                self.imgView.tag = i * 2 + j + 2;
            }
            
            self.imgView.frame = CGRectMake(KEveryNumber * i, KEveryNumber * j, KEveryNumber, KEveryNumber);
            [self.gameView addSubview:self.imgView];
        }
    }
    ZZGameImageView *img = (ZZGameImageView *)[self.view viewWithTag:self.imgView.tag];
    img.hidden = YES;
    
    

}

-(void)movedeciton:(NSNotification *)noti
{
    
    UIImageView *imageview = [noti.userInfo objectForKey:@"image"];
    CGFloat wid = imageview.frame.origin.x;
    CGFloat hig = imageview.frame.origin.y;
   
    if(self.tempImage.frame.origin.x == wid + KEveryNumber && self.tempImage.frame.origin.y == hig)
    {
        NSLog(@"right");
        [self rightchange:imageview];
    }
    if(self.tempImage.frame.origin.x == wid-KEveryNumber && self.tempImage.frame.origin.y == hig)
    {
        NSLog(@"left");
        [self leftchange:imageview];
    }
    if(self.tempImage.frame.origin.x == wid&&  self.tempImage.frame.origin.y == hig + KEveryNumber)
    {
        NSLog(@"down");
        [self downchange:imageview];
        
    }
    if(self.tempImage.frame.origin.x == wid && self.tempImage.frame.origin.y == hig - KEveryNumber)
    {
        NSLog(@"up");
        [self upchange:imageview];
    }
}

-(void)upchange:(UIImageView *)image
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    image.frame = CGRectMake(image.frame.origin.x, image.frame.origin.y - KEveryNumber, KEveryNumber, KEveryNumber);
    self.tempImage.frame = CGRectMake(image.frame.origin.x,image.frame.origin.y + KEveryNumber, KEveryNumber, KEveryNumber);
}
-(void)leftchange:(UIImageView *)image
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    image.frame = CGRectMake(image.frame.origin.x -KEveryNumber, image.frame.origin.y, KEveryNumber, KEveryNumber);
    self.tempImage.frame = CGRectMake(image.frame.origin.x + KEveryNumber, image.frame.origin.y, KEveryNumber, KEveryNumber);
}
-(void)rightchange:(UIImageView *)image
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    image.frame = CGRectMake(image.frame.origin.x + KEveryNumber, image.frame.origin.y, KEveryNumber, KEveryNumber);
    self.tempImage.frame = CGRectMake(image.frame.origin.x - KEveryNumber, image.frame.origin.y, KEveryNumber, KEveryNumber);
}
-(void)downchange:(UIImageView *)image
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    image.frame = CGRectMake(image.frame.origin.x, image.frame.origin.y + KEveryNumber, KEveryNumber, KEveryNumber);
    self.tempImage.frame = CGRectMake(image.frame.origin.x,image.frame.origin.y - KEveryNumber , KEveryNumber, KEveryNumber);
}

-(NSDictionary*)SeparateImage:(UIImage*)image ByX:(int)x andY:(int)y cacheQuality:(float)quality
{
    
    if (x < 1) {
        NSLog(@"illegal x!");
        return nil;
    }else if (y < 1) {
        NSLog(@"illegal y!");
        return nil;
    }
    if (![image isKindOfClass:[UIImage class]]) {
        NSLog(@"illegal image format!");
        return nil;
    }
    
    float _xstep = image.size.width * 1.0 / y;
    float _ystep = image.size.height * 1.0/ x;
    NSMutableDictionary *_mutableDictionary=[[NSMutableDictionary alloc]init];
  
    NSString * prefixName = @"win";
    
    for (int i = 0; i < x; i++)
    {
        for (int j = 0; j < y; j++)
        {
            CGRect rect = CGRectMake(_xstep * i, _ystep * j, _xstep, _ystep);
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage],rect);
            UIImage *elementImage = [UIImage imageWithCGImage:imageRef];
            UIImageView *_imageView = [[UIImageView alloc] initWithImage:elementImage];
            _imageView.frame = rect;
            NSString *_imageString = [NSString stringWithFormat:@"%@_%d_%d.jpg", prefixName, i, j];
            [_mutableDictionary setObject:_imageView forKey:_imageString];
            
            if (quality <= 0)
            {
                continue;
            }
            quality = (quality > 1) ? 1 : quality;
            
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *_imagePath = [path stringByAppendingPathComponent:_imageString];
            NSData *_imageData = UIImageJPEGRepresentation(elementImage, quality);
            [_imageData writeToFile:_imagePath atomically:YES];
        }
    }
    NSDictionary *_dictionary=_mutableDictionary;
    return _dictionary;
}


#pragma mark - 切换游戏界面
- (void)addPic:(UIButton *)button {
    
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    
    pick.allowsEditing = YES;
    
    pick.delegate = self;
    
    /* 创建alert 对象 */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pick animated:YES completion:^{
                
            }];
        }];
        [alert addAction:action];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pick animated:YES completion:^{
                
            }];
        }];
        [alert addAction:action];
    }
    
    /* 图库类型 */
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:pick animated:YES completion:^{
                
            }];
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alert addAction:action];
    
    /* 推出alert界面 */
    [self presentViewController:alert animated:YES completion:^{
    }];
}


#pragma mark - 选取图片后的处理  图片写入本地
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.GameBGImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self readPicturesFromLocal];
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
