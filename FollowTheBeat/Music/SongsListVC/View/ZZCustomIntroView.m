//
//  ZZCustomIntroView.m
//  FollowTheBeat
//
//  Created by 张昭 on 15/11/6.
//  Copyright © 2015年 Zzhao. All rights reserved.
//

#import "ZZCustomIntroView.h"
#import "UIImageView+WebCache.h"

@implementation ZZCustomIntroView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
        [self addSubview:self.photoImageView];
        self.photoImageView.layer.cornerRadius = 20;
        self.photoImageView.layer.masksToBounds = YES;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 120, 20)];
        [self addSubview:self.nameLabel];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:13];
        self.nameLabel.textColor = [UIColor whiteColor];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, frame.size.width - 40, 20)];
        [self addSubview:self.titleLabel];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        self.titleLabel.textColor = [UIColor whiteColor];
        
        
        self.ErJiImageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 20, 20)];
        [self addSubview:self.ErJiImageview];
        self.ErJiImageview.image = [UIImage imageNamed:@"iconfont-erjiline"];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 70, 60, 20)];
        [self addSubview:self.countLabel];
        self.countLabel.textColor = [UIColor whiteColor];
        
        self.introLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, KScreen_Width - 130, 20)];
        [self addSubview:self.introLabel];
        self.introLabel.font = [UIFont boldSystemFontOfSize:13];
        self.introLabel.textColor = [UIColor whiteColor];
        
        
        //        self.photoImageView.backgroundColor = [UIColor redColor];
        //        self.nameLabel.backgroundColor = [UIColor yellowColor];
        //        self.titleLabel.backgroundColor = [UIColor greenColor];
        //        self.ErJiImageview.backgroundColor = [UIColor greenColor];
        //        self.countLabel.backgroundColor = [UIColor purpleColor];
        //        self.introLabel.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

- (void)setModel:(ZZSongListModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model) {
        self.titleLabel.text = model.title;
        self.introLabel.text = model.desc;
        self.countLabel.text =[NSString stringWithFormat:@"%d", (int)model.listen_count];
        NSDictionary *dic = model.owner;
        if (dic) {
            
            if ([[dic objectForKey:@"nick_name"] isEqualToString:@"天天动听"] && [[dic objectForKey:@"nick_name"] isEqualToString:@""]) {
                self.nameLabel.text = @"狮笑天pds";
                self.photoImageView.image = [UIImage imageNamed:@"touxiang"];
            } else {
                self.nameLabel.text = [dic objectForKey:@"nick_name"];
                [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[model.owner objectForKey:@"portrait_pic"]] placeholderImage:[UIImage imageNamed:@"nrecommend_singer"]];
            }
            
        }
    }
}

@end
