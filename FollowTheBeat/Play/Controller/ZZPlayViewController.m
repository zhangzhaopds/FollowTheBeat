//
//  ZZPlayViewController.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/10/21.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZPlayViewController.h"
#import "HTTPTOOL.h"
#import "ZZSongModel.h"



#import "ZZCustomPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "LCDownloadManager.h"

#import "CoreDataManager.h"
#import "Song.h"

#import "ZZSongsListCell.h"
#import "ZZMusicPlayer.h"


/**
 *  音乐播放的主页面
 */
@interface ZZPlayViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *urlDataDictionary;
@property (nonatomic, strong) NSMutableArray *picUrlDataArray;


@property (nonatomic, strong) UILabel *songLabel;
@property (nonatomic, strong) UILabel *singerLabel;
@property (nonatomic, strong) UISlider *songSlider;
@property (nonatomic, strong) UIProgressView *songProgress;
@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) ZZCustomPlayView *customMusicView;

@property (nonatomic, strong) NSArray *songsArray;
@property (nonatomic, strong) CoreDataManager *manager;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, assign) CGFloat currentSec;
@property (nonatomic, assign) CGFloat totalSec;

@property (nonatomic, strong) UIView *playingListView;
@property (nonatomic, strong) UITableView *playListTabelView;
@property (nonatomic, strong) NSMutableArray *songsListArray;
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIView *statusLine;
@property (nonatomic, assign) BOOL statusLineHide;


@end

@implementation ZZPlayViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pro" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentIndex" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
   
    if (music.playList.count) {
        NSDictionary *dci = [music.playList objectAtIndex:music.indexOfItemInArr];
        
        self.customMusicView.singerLabel.text = [dci objectForKey:@"singerName"];
        self.customMusicView.songLabel.text = [dci objectForKey:@"songName"];
    }
    
    
    if (![ZZMusicPlayer shareMusicPlayer].player.rate) {
        [self.customMusicView.stopOrstart setImage:[UIImage imageNamed:@"iconfont-bofang-10"] forState:UIControlStateNormal];
   

    } else {
        
        [self.customMusicView.stopOrstart setImage:[UIImage imageNamed:@"iconfont-iconfont67"] forState:UIControlStateNormal];
    }

    //单曲
    if ([ZZMusicPlayer shareMusicPlayer].isSingleModel) {
        [self.customMusicView.refreshButton setImage:[UIImage imageNamed:@"iconfont-danquxunhuan-2"] forState:UIControlStateNormal];
    } else {
        [self.customMusicView.refreshButton setImage:[UIImage imageNamed:@"iconfont-shuaxin"] forState:UIControlStateNormal];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerRate" object:nil];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.songsListArray = [NSMutableArray array];
    
    [self creatBackGroundView];
    
    self.manager = [CoreDataManager manager];
    
    self.title = @"播放主界面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 从本地获取播放列表
    [self getLocalData];
    
    [self creatTitleLine];
    
    [self creatBottomView];
    
    [self creatPlayingListView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress:) name:@"pro" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentIndex) name:@"currentIndex" object:nil];
}

#pragma mark - 观察播放对象下标的变化
- (void)currentIndex {
    [self.playListTabelView reloadData];
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    
    if (music.playList.count) {
        NSDictionary *dci = [music.playList objectAtIndex:music.indexOfItemInArr];
        
        self.customMusicView.singerLabel.text = [dci objectForKey:@"singerName"];
        self.customMusicView.songLabel.text = [dci objectForKey:@"songName"];
    }
}

#pragma mark - 播放界面背景
- (void)creatBackGroundView {
    
    self.backGroundView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.backGroundView];
    

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"播放界面背景图片路径：%@", path);
    NSArray *arrPath = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    BOOL has = NO;
    for (NSString *strr in arrPath) {
        if ([strr isEqualToString:@"image1.da"]) {
            has = YES;
        }
    }
    
    if (has) {
        NSString *str = [path stringByAppendingPathComponent:@"image1.da"];
        self.backGroundView.image = [UIImage imageWithContentsOfFile:str];

    } else {
        self.backGroundView.image = [UIImage imageNamed:@"55317"];
    }
    
    self.backGroundView.userInteractionEnabled = YES;
    
    UIView *frontView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:frontView];
    frontView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.170];
    frontView.tag = 222;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToFrontVC)];
    [frontView addGestureRecognizer:swipe];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
}

- (void)backToFrontVC {
    
    [UIView animateWithDuration:1 animations:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}


#pragma mark - 播放进度
- (void)progress:(NSNotification *)noti {

    self.currentSec = [[noti.userInfo objectForKey:@"progress"] floatValue];
    self.totalSec = [[noti.userInfo objectForKey:@"totalSeconds"] floatValue];
    self.customMusicView.beginTimeLabel.text = [self convertTime:self.currentSec];
    self.customMusicView.endTimeLabel.text = [self convertTime:self.totalSec];
    
    [self.customMusicView.songProgress setProgress:(self.currentSec / self.totalSec) ];
    self.customMusicView.songSlider.minimumValue = 0.0f;
    self.customMusicView.songSlider.maximumValue = self.totalSec;
    self.customMusicView.songSlider.value = self.currentSec;
    
    [self.customMusicView.songSlider addTarget:self action:@selector(videoSliderChangeValueEnd:) forControlEvents:UIControlEventValueChanged];
}

- (NSDateFormatter *)dateFormatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        
    }
    return _formatter;
}

//将 秒数 转换成 时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    
    if (second / 3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showTimeNew = [[self dateFormatter] stringFromDate:date];
    return showTimeNew;
}


- (void)videoSliderChangeValueEnd:(UISlider *)sender {
    
    [[ZZMusicPlayer shareMusicPlayer] seekToTime:sender.value];
}


#pragma mark - 数据处理  音频 视频 歌手照片
- (void)getLocalData {
    
   
}

#pragma mark - 头部view  返回 下载 mv 收藏
- (void)creatTitleLine {
    
    self.statusLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, 64)];
    [self.view addSubview:self.statusLine];
    self.statusLine.tag = 100;
    self.statusLine.backgroundColor = [UIColor colorWithWhite:0.815 alpha:0.840];
    self.statusLine.hidden = YES;
    
    // 切换照片
    UIButton *addPic = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.statusLine addSubview:addPic];
    addPic.frame = CGRectMake(self.statusLine.frame.size.width - 50, self.statusLine.frame.size.height - 40, 30, 30);
    [addPic setImage:[UIImage imageNamed:@"iconfont-zhaopian"] forState:UIControlStateNormal];
    [addPic addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
    
    // 推出播放界面
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.statusLine addSubview:backBtn];
    backBtn.frame = CGRectMake(20, self.statusLine.frame.size.height - 40, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"iconfont-xiangxia"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

// 推出当前界面
- (void)back:(UIButton *)button {
    [UIView animateWithDuration:1 animations:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

#pragma mark - 切换背景照片  添加本地照片
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

    self.backGroundView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 图片写入本地
   
    NSString *picUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    picUrl = [NSString stringWithFormat:@"%@", [info objectForKey:UIImagePickerControllerReferenceURL]];

    if ([picUrl hasSuffix:@"JPG"] || [picUrl hasSuffix:@"jpg"]) {
       
        
        NSString *str = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"da"];
        if (str.length) {
            [[NSFileManager defaultManager] removeItemAtPath:str error:nil];
            
        }
       
        NSData *imageData = UIImageJPEGRepresentation(self.backGroundView.image, 1);
        
       
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"image1.da"];
        [imageData writeToFile:imagePath atomically:YES];
        
        NSLog(@"%@", imagePath);
    }
    if ([picUrl hasSuffix:@"PNG"] || [picUrl hasSuffix:@"png"]) {
       
        NSString *str = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"da"];
        if (str.length) {
            [[NSFileManager defaultManager] removeItemAtPath:str error:nil];
            
        }
        
        NSData *pngImageData = UIImagePNGRepresentation(self.backGroundView.image);
        NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"image1.da"];
        [pngImageData writeToFile:imagePath atomically:YES];
        

        
    }

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




#pragma mark - 播放界面
- (void)creatBottomView {
    
    // 自定义一个播放界面
    self.customMusicView = [[ZZCustomPlayView alloc] initWithFrame:CGRectMake(0, KScreen_Height * 2 / 3 + 30, KScreen_Width, KScreen_Height / 3 - 30)];
    
    [self.view addSubview:self.customMusicView];
    
    
    [self.customMusicView.stopOrstart addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customMusicView.nextSong addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customMusicView.lastSong addTarget:self action:@selector(lastSong) forControlEvents:UIControlEventTouchUpInside];

    [self.customMusicView.refreshButton addTarget:self action:@selector(singleSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customMusicView.listSongView addTarget:self action:@selector(listSongView:) forControlEvents:UIControlEventTouchUpInside];
    
}



// 单曲
- (void)singleSong:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self.customMusicView.refreshButton setImage:[UIImage imageNamed:@"iconfont-danquxunhuan-2"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"singleSong" object:nil userInfo:@{@"key": @"1"}];
    } else {
        [self.customMusicView.refreshButton setImage:[UIImage imageNamed:@"iconfont-shuaxin"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"singleSong" object:nil userInfo:@{@"key": @"0"}];
    }
}


//上一首
- (void)lastSong {

    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    
    if (!music.playList.count) {
        return;
    }
    music.indexOfItemInArr --;
    if (music.indexOfItemInArr == -1) {
        music.indexOfItemInArr = music.playList.count - 1;
    }
    if (music.playList.count) {
        NSDictionary *dci = [music.playList objectAtIndex:[ZZMusicPlayer shareMusicPlayer].indexOfItemInArr];
        
        NSString *url = [dci objectForKey:@"songUrl"];
        
        
        [music setMusicURLString:url];
        
        self.customMusicView.singerLabel.text = [dci objectForKey:@"singerName"];
        self.customMusicView.songLabel.text = [dci objectForKey:@"songName"];
        
        [music.player play];
    }

   
}

//下一首
- (void)nextSong {
    
    ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
    
    if (!music.playList.count) {
        return;
    }
    music.indexOfItemInArr ++;
    if (music.indexOfItemInArr == music.playList.count) {
        music.indexOfItemInArr = 0;
    }
    if (music.playList.count) {
        NSDictionary *dci = [music.playList objectAtIndex:[ZZMusicPlayer shareMusicPlayer].indexOfItemInArr];
        
        NSString *url = [dci objectForKey:@"songUrl"];

        
        [music setMusicURLString:url];
        
        self.customMusicView.singerLabel.text = [dci objectForKey:@"singerName"];
        self.customMusicView.songLabel.text = [dci objectForKey:@"songName"];
        
        [music.player play];
    }


    
}

//播放 与 暂停
- (void)pause:(UIButton *)button {
    
    if ([ZZMusicPlayer shareMusicPlayer].player.rate) {
        [self.customMusicView.stopOrstart setImage:[UIImage imageNamed:@"iconfont-bofang-10"] forState:UIControlStateNormal];
        [[ZZMusicPlayer shareMusicPlayer].player pause];
    } else {
    
        [self.customMusicView.stopOrstart setImage:[UIImage imageNamed:@"iconfont-iconfont67"] forState:UIControlStateNormal];
        [[ZZMusicPlayer shareMusicPlayer].player play];
    }
}

- (void)listSongView:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        
        self.songsListArray = [ZZMusicPlayer shareMusicPlayer].playList;
        [self.playListTabelView reloadData];
        self.playingListView.hidden = NO;
        
    } else {
        self.playingListView.hidden = YES;
        ZZMusicPlayer *music = [ZZMusicPlayer shareMusicPlayer];
        
        if (music.playList.count) {
            NSDictionary *dci = [music.playList objectAtIndex:music.indexOfItemInArr];
            
            self.customMusicView.singerLabel.text = [dci objectForKey:@"singerName"];
            self.customMusicView.songLabel.text = [dci objectForKey:@"songName"];
        }
    }
    
}

#pragma mark - 正在播放列表 - 小窗
- (void)creatPlayingListView {
    
    self.playingListView = [[UIView alloc] initWithFrame:CGRectMake(60, 140, KScreen_Width - 120, KScreen_Height * 2 / 3 - 40)];
//    self.playingListView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, KScreen_Width, KScreen_Height * 2 / 3 - 40)];
    [self.view addSubview:self.playingListView];
    self.playingListView.backgroundColor = [UIColor colorWithWhite:0.141 alpha:0.570];
//    self.playingListView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.480];
    self.playingListView.hidden = YES;
    self.playingListView.layer.cornerRadius = 8;
    self.playingListView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.playingListView.frame.size.width - 20, 20)];
    [self.playingListView addSubview:label];
    label.text = @"正在播放";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    

    //40
    self.playListTabelView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, self.playingListView.frame.size.width - 20, self.playingListView.frame.size.height - 75) style:UITableViewStylePlain];
    [self.playingListView addSubview:self.playListTabelView];
    self.playListTabelView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.140];
    self.playListTabelView.layer.cornerRadius = 8;
    self.playListTabelView.layer.masksToBounds = YES;
    
    self.playListTabelView.rowHeight = 60.f;
    self.playListTabelView.delegate = self;
    self.playListTabelView.dataSource = self;
    [self.playListTabelView registerClass:[ZZSongsListCell class] forCellReuseIdentifier:@"reuse"];
}

#pragma mark - tabelView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZSongsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];


    NSDictionary *dic = [self.songsListArray objectAtIndex:indexPath.row];
    cell.songsListDic = dic;
    cell.index = indexPath.row;
    if (!indexPath.row) {
        cell.jiaBtn.hidden = YES;
    }
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.playListTabelView setEditing:editing animated:animated];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.songsListArray.count == 1) {
        return NO;
    } else {
        return YES;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[ZZMusicPlayer shareMusicPlayer].player pause];
        [ZZMusicPlayer shareMusicPlayer].indexOfItemInArr = 0;

        [[ZZMusicPlayer shareMusicPlayer].playList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        self.songsListArray = [ZZMusicPlayer shareMusicPlayer].playList;
        [self.playListTabelView reloadData];
        [[ZZMusicPlayer shareMusicPlayer].player play];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"songsArray" object:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.songsListArray objectAtIndex:indexPath.row];
    NSLog(@"%@", [dic objectForKey:@"songName"]);
    
    if ([ZZMusicPlayer shareMusicPlayer].isPlaying == YES) {
        [[ZZMusicPlayer shareMusicPlayer].player pause];
    }
    
    
    [[ZZMusicPlayer shareMusicPlayer] setMusicURLString:[dic objectForKey:@"songUrl"]];
    
    
    [ZZMusicPlayer shareMusicPlayer].indexOfItemInArr = [[ZZMusicPlayer shareMusicPlayer].playList indexOfObject:dic];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"songsArray" object:nil];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == [self.view viewWithTag:222]) {
        self.statusLineHide = !self.statusLineHide;
        if (self.statusLineHide) {
            self.statusLine.hidden = NO;
        } else {
            self.statusLine.hidden = YES;
        }
        
        
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
