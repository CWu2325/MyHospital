//
//  TimeoutView.m
//  MyHospital
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "TimeoutView.h"
#import "AppDelegate.h"
@interface TimeoutView()

@property(nonatomic,strong)AppDelegate *appDlg;
@property(nonatomic,strong)UIImageView *noNetWorkImageView;
@property(nonatomic,strong)UILabel *remindLabel;
@property(nonatomic,strong)UIButton *resetBtn;

@end

@implementation TimeoutView




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
    label.text = @"网络不给力，请重试！";
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
    [self.delegate tapTimeOutBtnAction];
}

@end
