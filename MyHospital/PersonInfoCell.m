//
//  PersonInfoCell.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "PersonInfoCell.h"
#import "UIImageView+WebCache.h"

@implementation PersonInfoCell

-(instancetype)init
{
    if (self = [super init])
    {
        //背景
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,-64, WIDTH, 130 +64)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_login.jpg"]];
        [self.contentView addSubview:headerView];
        
        //头像
        self.useImageView = [[UIImageView alloc]init];
        self.useImageView.frame = CGRectMake(20, 25, 80, 80);
        self.useImageView.layer.cornerRadius = self.useImageView.width/2;
        self.useImageView.layer.borderWidth = 1.5;
        self.useImageView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5].CGColor;
        self.useImageView.layer.masksToBounds = YES;
        self.useImageView.image = [UIImage imageNamed:@"default_avatar"];
        
        
        self.useNameLabel = [[UILabel alloc]init];
        self.useNameLabel.textColor = [UIColor whiteColor];
        
        self.useTelLabel = [[UILabel alloc]init];
        self.useTelLabel.textColor = [UIColor whiteColor];
        
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, 1)];
//        view.backgroundColor = LCWDivisionLineColor;
//        [self.contentView addSubview:view];
        
        [self.contentView addSubview:self.useImageView];
        [self.contentView addSubview:self.useNameLabel];
        [self.contentView addSubview:self.useTelLabel];
    }
    return self;
}


-(void)layoutSubviews
{
    

    
    if (self.user.coverUrl != (NSString *)[NSNull null])
    {
        [self.useImageView setImageWithURL:[NSURL URLWithString:self.user.coverUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:SDWebImageRetryFailed];
    }
    
    
    self.useNameLabel.width = 150;
    self.useNameLabel.height = 35;
    self.useNameLabel.adjustsFontSizeToFitWidth = YES;
    self.useNameLabel.x = self.useImageView.x + self.useImageView.width+ 8;
    self.useNameLabel.y = self.useImageView.centerY-self.useNameLabel.height;
    if (self.user.name != (NSString *)[NSNull null])
    {
        self.useNameLabel.text = self.user.name;
    }
    else
    {
        self.useNameLabel.text = @"用户";
    }
    self.useTelLabel.frame = self.useNameLabel.frame;
    self.useTelLabel.y = self.useImageView.centerY ;
    if (self.user.mobile != (NSString *)[NSNull null])
    {
        self.useTelLabel.text = self.user.mobile;
    }
    else
    {
        self.useTelLabel.text = self.value;
    }
    self.useNameLabel.adjustsFontSizeToFitWidth = YES;
   
}

@end
