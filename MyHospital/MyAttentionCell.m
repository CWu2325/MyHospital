//
//  MyAttentionCell.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyAttentionCell.h"

@interface MyAttentionCell()
@property(nonatomic,strong)UILabel *doctorNameLabel;
@property(nonatomic,strong)UILabel *doctorLevelLabel;
@property(nonatomic,strong)UILabel *doctorHosDeptLabel;
@property(nonatomic,strong)UILabel *commMarkLabel;
@property(nonatomic,strong)UIImageView *doctorIV;
@property(nonatomic,strong)UIImageView *selIV;

@end

@implementation MyAttentionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initUI];
    }
    return self;
}


-(void)initUI
{
    //医生头像
    self.doctorIV = [[UIImageView alloc]init];
    self.doctorIV.width = 60;
    self.doctorIV.height = 60;
    self.doctorIV.x = 10;
    self.doctorIV.y = 10;
    self.doctorIV.layer.cornerRadius = self.doctorIV.width/2;
    self.doctorIV.layer.borderWidth = 1;
    self.doctorIV.layer.borderColor = LCWBottomColor.CGColor;
    self.doctorIV.layer.masksToBounds = YES;
    self.doctorIV.image = [UIImage imageNamed:@"default_avatar@2x.png"];    //默认
    [self.contentView addSubview:self.doctorIV];
    
    //医生姓名
    self.doctorNameLabel = [[UILabel alloc]init];
    self.doctorNameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.doctorNameLabel];
    
    //医生职称
    self.doctorLevelLabel = [[UILabel alloc]init];
    self.doctorLevelLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.doctorLevelLabel];
    
    //医生部门
    self.doctorHosDeptLabel = [[UILabel alloc]init];
    self.doctorHosDeptLabel.font = self.doctorLevelLabel.font;
    [self.contentView addSubview:self.doctorHosDeptLabel];
    
    //医生评分
    self.commMarkLabel = [[UILabel alloc]init];
    self.commMarkLabel.font = self.doctorLevelLabel.font;
    [self.contentView addSubview:self.commMarkLabel];
    
    //选择图像
    self.selIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_up.png"]];
    self.selIV.width = 16;
    self.selIV.height = 16;
    self.selIV.x = self.width - 10 - self.selIV.width;
    self.selIV.y = 40 - self.selIV.height/2;
    [self.contentView addSubview:self.selIV];
    
    //分割线
    UIImageView *diviIV = [[UIImageView alloc]init];
    diviIV.x = 0;
    diviIV.y = 79;
    diviIV.width = WIDTH;
    diviIV.height = 1;
    diviIV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:diviIV];
}


-(void)layoutSubviews
{
    //头像
    [self.doctorIV setImageWithURL:[NSURL URLWithString:self.att.coverUrl]];

    //名字
    self.doctorNameLabel.text = self.att.doctorName;
    self.doctorNameLabel.x = self.doctorIV.maxX + 10;
    self.doctorNameLabel.y = self.doctorIV.y + 3;
    self.doctorNameLabel.size = [XyqsTools getSizeWithText:self.doctorNameLabel.text andFont:self.doctorNameLabel.font];
    
    //等级
    self.doctorLevelLabel.text = self.att.levelName;
    self.doctorLevelLabel.x = self.doctorNameLabel.maxX + 10;
    self.doctorLevelLabel.size = [XyqsTools getSizeWithText:self.doctorLevelLabel.text andFont:self.doctorLevelLabel.font];
    self.doctorLevelLabel.y = self.doctorNameLabel.maxY - self.doctorLevelLabel.height ;
    
    //部门
    self.doctorHosDeptLabel.text = [NSString stringWithFormat:@"%@-%@",self.att.hospitalName,self.att.departmentName];
    self.doctorHosDeptLabel.size = [XyqsTools getSizeWithText:self.doctorHosDeptLabel.text andFont:self.doctorHosDeptLabel.font];
    self.doctorHosDeptLabel.x = self.doctorNameLabel.x;
    self.doctorHosDeptLabel.centerY = self.doctorIV.centerY;
    
    //评分
    self.commMarkLabel.text = [NSString stringWithFormat:@"评分: %.1f",(float)self.att.commMark];
    self.commMarkLabel.size = [XyqsTools getSizeWithText:self.commMarkLabel.text andFont:self.commMarkLabel.font];
    self.commMarkLabel.x = self.doctorNameLabel.x;
    self.commMarkLabel.y = self.doctorIV.maxY -3-self.commMarkLabel.height;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
