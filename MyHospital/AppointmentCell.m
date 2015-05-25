//
//  AppointmentCell.m
//  掌上医疗（纯代码）
//
//  Created by XYQS on 15/3/25.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppointmentCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface AppointmentCell()

@property(nonatomic,strong)UIImageView *hospitalIV;
@property(nonatomic,strong)UILabel *hospitalNameLabel;
@property(nonatomic,strong)UILabel *hospitalLevelLabel;

@end

@implementation AppointmentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

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
    self.hospitalIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 60)];
//    self.hospitalIV.layer.cornerRadius = 5;
//    self.hospitalIV.layer.borderWidth = 1;
//    self.hospitalIV.layer.borderColor = LCWBottomColor.CGColor;
//    self.hospitalIV.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.hospitalIV];
    
    self.hospitalNameLabel = [[UILabel alloc]init];
    self.hospitalNameLabel.font = [UIFont systemFontOfSize:16];
    self.hospitalNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.hospitalNameLabel];
    
    self.hospitalLevelLabel = [[UILabel alloc]init];
    self.hospitalLevelLabel.font = [UIFont systemFontOfSize:12];
    self.hospitalLevelLabel.backgroundColor = [UIColor clearColor];
    self.hospitalLevelLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.hospitalLevelLabel];
    
    UIView *divisionLine = [[UIView alloc]initWithFrame:CGRectMake(0, 79, WIDTH, 1)];
    divisionLine.backgroundColor = LCWDivisionLineColor;
    [self.contentView addSubview:divisionLine];
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    if (self.hospital.coverUrl != (NSString *)[NSNull null])
    {
        [self.hospitalIV setImageWithURL:[NSURL URLWithString:self.hospital.coverUrl] placeholderImage:[UIImage imageNamed:@"sv01.jpg"] options:SDWebImageRetryFailed];
    }
 
    self.hospitalNameLabel.text = self.hospital.name;
    self.hospitalNameLabel.size = [XyqsTools getSizeWithText:self.hospitalNameLabel.text andFont:self.hospitalNameLabel.font];
    self.hospitalNameLabel.x = self.hospitalIV.maxX + 10;
    self.hospitalNameLabel.y = self.hospitalIV.y + 10;
    
    self.hospitalLevelLabel.text = self.hospital.level;
    self.hospitalLevelLabel.size = [XyqsTools getSizeWithText:self.hospitalLevelLabel.text andFont:self.hospitalLevelLabel.font];
    self.hospitalLevelLabel.x = self.hospitalNameLabel.x;
    self.hospitalLevelLabel.y = self.hospitalNameLabel.maxY + 10;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

