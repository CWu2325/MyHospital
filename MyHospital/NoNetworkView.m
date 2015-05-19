//
//  NoNetworkView.m
//  MyHospital
//
//  Created by XYQS on 15/5/18.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "NoNetworkView.h"
#import "AppDelegate.h"

@interface NoNetworkView()

@property(nonatomic,strong)AppDelegate *appDlg;

@end

@implementation NoNetworkView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = LCWBackgroundColor;
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    UIImageView *noNetWorkIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 127, 50, 50)];
    noNetWorkIv.image = [UIImage imageNamed:@"noNetWork.png"];
    noNetWorkIv.centerX = self.centerX;
    self.noNetWorkImageView = noNetWorkIv;
    [self addSubview:noNetWorkIv];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    label.text = @"无网络连接,请联网后重试!";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.y = noNetWorkIv.maxY + 9;
    label.height = [XyqsTools getSizeWithText:label.text andFont:label.font].height;
    self.remindLabel = label;
    [self addSubview:label];
    
    UIButton *resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    resetBtn.centerX = self.centerX;
    resetBtn.y = label.maxY + 15;
    [resetBtn setTitle:@"重  试" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"noNetNormalBtn.png"] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"noNetHighLightedBtn.png"] forState:UIControlStateHighlighted];
    [resetBtn addTarget:[[self superview] nextResponder] action:@selector(requestNetWork:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetBtn];
}

-(void)requestNetWork:(UIButton *)sender
{
    self.appDlg = [UIApplication sharedApplication].delegate;
    if (self.appDlg.isReachable)
    {
        self.hidden = YES;
        //想调VC的
        UIViewController *vc = (UIViewController *)[[self superview] nextResponder];
        [vc viewWillAppear:YES];
    }
    else
    {
        self.hidden = NO;
        [MBProgressHUD showError:@"亲~请检查您的网络连接"];
    }
}





@end
