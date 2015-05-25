//
//  SelDocCell.m
//  MyHospital
//
//  Created by XYQS on 15/3/26.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SelDocCell.h"
#import "TEXTLabel.h"
#import "UIImageView+WebCache.h"

@interface SelDocCell()

@property(nonatomic,strong)UILabel *nameLabel;              //
@property(nonatomic,strong)UILabel *levelNameLabel;         //等级
@property(nonatomic,strong)UILabel *hospital_deptsLabel;    //所属医院和科室
@property(nonatomic,strong)UILabel *expertLabel;            //擅长
@property(nonatomic,strong)UILabel *priceLabel;             //挂号费
@property(nonatomic,strong)UILabel *numLabel;               //已预约个数和剩余个数
@property(nonatomic,strong)UIImageView *docHeaderIV;        //头像
@property(nonatomic,strong)UILabel *statusLabel;            //状态


@end

@implementation SelDocCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}



-(void)initUI
{
    //头像
    self.docHeaderIV = [[UIImageView alloc]init];
    self.docHeaderIV.frame = CGRectMake(8, 8, 57, 57);
    self.docHeaderIV.layer.cornerRadius = self.docHeaderIV.width/2;
    self.docHeaderIV.layer.borderWidth = 0.8;
    self.docHeaderIV.layer.borderColor = LCWBottomColor.CGColor;
    self.docHeaderIV.layer.masksToBounds = YES;
    self.docHeaderIV.image = [UIImage imageNamed:@"background_login.jpg"];
    [self.contentView addSubview:self.docHeaderIV];
    
    //医生名称
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLabel];
    
    //等级
    self.levelNameLabel = [[UILabel alloc]init];
    self.levelNameLabel.font = [UIFont systemFontOfSize:12];
    self.levelNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.levelNameLabel];
    
    //所属医院和科室
    self.hospital_deptsLabel = [[UILabel alloc]init];
    self.hospital_deptsLabel.font = self.levelNameLabel.font;
    self.hospital_deptsLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.hospital_deptsLabel];
    
    //擅长
    self.expertLabel = [[UILabel alloc]init];
    self.expertLabel.font = self.levelNameLabel.font;
    self.expertLabel.backgroundColor = [UIColor clearColor];
    self.expertLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.expertLabel];
    
    //挂号费
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = self.expertLabel.textColor;
    self.priceLabel.font = self.levelNameLabel.font;
    self.priceLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.priceLabel];
    
    //num挂号剩余个数
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.font = self.levelNameLabel.font;
    self.numLabel.textColor = [UIColor blackColor];
    self.numLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.numLabel];
    
    //状态
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.statusLabel];
    
    UIView *divisionLine = [[UIView alloc]initWithFrame:CGRectMake(0, 79, WIDTH, 1)];
    divisionLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:divisionLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //设置图像
    if (self.doctor.coverUrl != (NSString *)[NSNull null])
    {
        [self.docHeaderIV setImageWithURL:[NSURL URLWithString:self.doctor.coverUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:SDWebImageRetryFailed];
    }
    //[self.docHeaderIV setImageWithURL:[NSURL URLWithString:self.doctor.coverUrl]];
    
    //姓名
    self.nameLabel.text = self.doctor.doctorName;
    self.nameLabel.size = [XyqsTools getSizeWithText:self.nameLabel.text andFont:self.nameLabel.font];
    self.nameLabel.x = self.docHeaderIV.maxX + 5;
    self.nameLabel.y = self.docHeaderIV.y + 2;
    
    //等级
    self.levelNameLabel.text = self.doctor.levelName;
    self.levelNameLabel.size = [XyqsTools getSizeWithText:self.levelNameLabel.text andFont:self.levelNameLabel.font];
    self.levelNameLabel.x = self.nameLabel.maxX + 5;
    self.levelNameLabel.y = self.nameLabel.maxY  - self.levelNameLabel.height;
    
    //所属科室和医院
    self.hospital_deptsLabel.text = [NSString stringWithFormat:@"%@-%@",self.doctor.hospitalName,self.doctor.departmentName];
    self.hospital_deptsLabel.size = [XyqsTools getSizeWithText:self.hospital_deptsLabel.text andFont:self.hospital_deptsLabel.font];
    self.hospital_deptsLabel.x = self.nameLabel.x;
    self.hospital_deptsLabel.y = self.nameLabel.maxY + 5;
    
    //挂号费用

    NSString *editStr = [XyqsTools stringDisposeWithFloat:self.doctor.fee];
    NSString *allStr = [NSString stringWithFormat:@"挂号费:%@元",editStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
    [str addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    self.priceLabel.attributedText = str;
    self.priceLabel.size = [XyqsTools getSizeWithText:self.priceLabel.text andFont:self.priceLabel.font];
    self.priceLabel.x = WIDTH - 8 - self.priceLabel.width;
    self.priceLabel.y = self.hospital_deptsLabel.maxY + 5;
    
    //擅长
    self.expertLabel.text = [NSString stringWithFormat:@"擅长:%@",self.doctor.expert];
    CGFloat maxWidtd = WIDTH - self.docHeaderIV.maxX - self.priceLabel.width - 20;
    self.expertLabel.size = [XyqsTools getSizeByText:self.expertLabel.text andFont:self.expertLabel.font andWidth:maxWidtd];
    self.expertLabel.height = self.hospital_deptsLabel.height;
    self.expertLabel.x = self.nameLabel.x;
    self.expertLabel.y = self.hospital_deptsLabel.maxY + 5;
    
    
    
    //剩余个数
    self.numLabel.text = [NSString stringWithFormat:@"%d/%d",5,12];
    self.numLabel.size = [XyqsTools getSizeWithText:self.numLabel.text andFont:self.numLabel.font];
    self.numLabel.x = WIDTH - 8 - self.numLabel.width;
    self.numLabel.y = self.hospital_deptsLabel.y;
    
    //状态
    if (self.doctor.remainState == 1)
    {
        self.statusLabel.layer.backgroundColor = LCWBottomColor.CGColor;
        self.statusLabel.text = @"可约";
    }
    else if(self.doctor.remainState == 0)
    {
        self.statusLabel.layer.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
        self.statusLabel.text = @"约满";
    }
    else
    {
        self.statusLabel.layer.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1].CGColor;
        self.statusLabel.text = @"停诊";
    }
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.size = CGSizeMake(40, 22);
    self.statusLabel.adjustsFontSizeToFitWidth = YES;
    self.statusLabel.x = WIDTH - 8 - self.statusLabel.width;
    self.statusLabel.y = self.nameLabel.maxY - self.statusLabel.height;

}



- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
