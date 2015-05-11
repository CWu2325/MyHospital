//
//  DoctorIntroduceView.m
//  MyHospital
//
//  Created by XYQS on 15/4/11.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "DoctorIntroduceView.h"

@interface DoctorIntroduceView()

@property(nonatomic,strong)UILabel *skillDetailLabel;       //擅长的内容
@property(nonatomic,strong)UILabel *undergoLabel;           //擅长下的职业经历标签
@property(nonatomic,strong)UIView *view3;                   //职业经历下的分隔线
@property(nonatomic,strong)UILabel *undergoDetailLabel;     //职业经历内容

@property(nonatomic,strong)UIScrollView *bottomSV;          //基础

@end

@implementation DoctorIntroduceView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initUI];
    }
    return self;
}



-(void)initUI
{
    //擅长标签
    UILabel *skillLabel = [[UILabel alloc]init];
    skillLabel.x = 10;
    skillLabel.y = 10;
    skillLabel.text = @"擅长";
    skillLabel.font = [UIFont systemFontOfSize:14];
    skillLabel.size = [XyqsTools getSizeByText:skillLabel.text andFont:skillLabel.font andWidth:WIDTH];
    [self addSubview:skillLabel];
    
    //擅长下的黑条
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = skillLabel.maxY + 5;
    view2.width = skillLabel.size.width + 60;
    view2.height = 1;
    view2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view2];
    
    //擅长的说明
    UILabel *skillDetailLabel = [[UILabel alloc]init];
    skillDetailLabel.numberOfLines = 0;
    skillDetailLabel.x = 10;
    skillDetailLabel.y = view2.y + 5;
    self.skillDetailLabel = skillDetailLabel;
    [self addSubview:skillDetailLabel];
    
    //经历标签 和 标签下的分割线
    UILabel *undergoLabel = [[UILabel alloc]init];
    self.undergoLabel = undergoLabel;
    self.undergoLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:undergoLabel];
    
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor lightGrayColor];
    self.view3 = view3;
    [self addSubview:view3];
    
    //职业经历的内容
    UILabel *undergoDetailLabel = [[UILabel alloc]init];
    undergoDetailLabel.font = [UIFont systemFontOfSize:13];
    self.undergoDetailLabel = undergoDetailLabel;
    [self addSubview:undergoDetailLabel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //擅长的内容
    self.skillDetailLabel.text = [NSString stringWithFormat:@"    %@",self.doctor.expert];
    self.skillDetailLabel.font = [UIFont systemFontOfSize:13];
    self.skillDetailLabel.size = [XyqsTools getSizeByText:self.skillDetailLabel.text andFont:self.skillDetailLabel.font andWidth:WIDTH-20];
    
    //
    self.undergoLabel.x = 10;
    self.undergoLabel.y = self.skillDetailLabel.maxY + 30;
    self.undergoLabel.text = @"职业经验";
    self.undergoLabel.size = [XyqsTools getSizeByText:self.undergoLabel.text andFont:self.undergoLabel.font andWidth:WIDTH];
    
    //
    self.view3.x = 0;
    self.view3.y = self.undergoLabel.maxY + 5;
    self.view3.width = self.undergoLabel.width + 40;
    self.view3.height = 1;
    
    //
    self.undergoDetailLabel.numberOfLines = 0;
    self.undergoDetailLabel.x = self.skillDetailLabel.x;
    self.undergoDetailLabel.y = self.view3.y + 5;
    self.undergoDetailLabel.text =[NSString stringWithFormat:@"    %@",self.doctor.introduction];
    self.undergoDetailLabel.size = [XyqsTools getSizeByText:self.undergoDetailLabel.text andFont:self.undergoDetailLabel.font andWidth:WIDTH-20];
    
    self.height = self.undergoDetailLabel.maxY + 20;
}

@end
