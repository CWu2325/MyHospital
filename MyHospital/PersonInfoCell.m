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
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, 90 +64)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_login.jpg"]];
        [self.contentView addSubview:headerView];
        
        //头像
        self.useImageView = [[UIImageView alloc]init];
        self.useImageView.frame = CGRectMake(20, 8, 75, 75);
        self.useImageView.layer.cornerRadius = self.useImageView.width/2;
        self.useImageView.layer.borderWidth = 1.5;
        self.useImageView.layer.borderColor = LCWBottomColor.CGColor;
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
    
//    if (self.user.coverUrl != (NSString *)[NSNull null])
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.coverUrl]];
//            UIImage *image = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.useImageView.image = image;
//            });
//        });
//    }
//    else
//    {
//        self.useImageView.image = [UIImage imageNamed:@"default_avatar"];
//    }
    
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
        self.useNameLabel.text = @"新用户";
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