//
//  AppRecordCell.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppRecordCell.h"
#import "UIImageView+AFNetworking.h"
#import "XyqsApi.h"
#import "PayWebVC.h"

@interface AppRecordCell()

@property(nonatomic,strong)UILabel *orderIDLabel;           //预约号
@property(nonatomic,strong)UILabel *orderStatelabel;        //预约状态
@property(nonatomic,strong)UIImageView *docIV;              //头像
@property(nonatomic,strong)UILabel *docNameLabel;           //医生姓名
@property(nonatomic,strong)UILabel *docLevelLabel;          //职称
@property(nonatomic,strong)UILabel *hospitalDeptsLabel;     //医生科室和医院
@property(nonatomic,strong)UILabel *sickNameLabel;          //就诊人
@property(nonatomic,strong)UILabel *dateLabel;              //就诊日期
@property(nonatomic,strong)UILabel *priceLabel;             //挂号费用
@property(nonatomic,strong)UILabel *payWayLabel;            //支付方式
@property(nonatomic,strong)UIButton *selButton;             //支付或评价按钮



@end


@implementation AppRecordCell

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
    UIImageView *diviIV0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    diviIV0.backgroundColor = LCWBackgroundColor;
    [self.contentView addSubview:diviIV0];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"预约号: ";
    label1.font = [UIFont systemFontOfSize:13];
    label1.x = 10;
    label1.y = diviIV0.maxY + 10;
    label1.size = [XyqsTools getSizeWithText:label1.text andFont:label1.font];
    [self.contentView addSubview:label1];
    
    //预约号
    UILabel *orderIDLabel = [[UILabel alloc]init];
    orderIDLabel.font = label1.font;
    orderIDLabel.textColor = LCWBottomColor;
    self.orderIDLabel = orderIDLabel;
    orderIDLabel.x = label1.maxX + 2;
    orderIDLabel.y = label1.y;
    [self.contentView addSubview:orderIDLabel];
    
    //预约状态
    UILabel *orderStatelabel = [[UILabel alloc]init];
    orderStatelabel.font = label1.font;
    self.orderStatelabel = orderStatelabel;
    [self.contentView addSubview:orderStatelabel];
    
    //医生头像
    UIImageView *docIV = [[UIImageView alloc]init];
    docIV.size = CGSizeMake(50, 50);
    docIV.x = label1.x;
    docIV.y = label1.maxY + (90 - label1.maxY)/2 - docIV.height/2;
    self.docIV = docIV;
    self.docIV.layer.cornerRadius = self.docIV.width/2;
    self.docIV.layer.borderColor = [UIColor greenColor].CGColor;
    self.docIV.layer.borderWidth = 1;
    self.docIV.layer.masksToBounds = YES;
    [self.contentView addSubview:docIV];
    
    //医生姓名
    UILabel *docNameLabel = [[UILabel alloc]init];
    docNameLabel.font = label1.font;
    self.docNameLabel = docNameLabel;
    [self.contentView addSubview:docNameLabel];
    
    //医生职称
    UILabel *docLevelLabel = [[UILabel alloc]init];
    docLevelLabel.font = [UIFont systemFontOfSize:10];
    self.docLevelLabel = docLevelLabel;
    [self.contentView addSubview:docLevelLabel];
    
    //医生医院和科室
    UILabel *hospitalDeptsLabel = [[UILabel alloc]init];
    hospitalDeptsLabel.font = docLevelLabel.font;
    self.hospitalDeptsLabel = hospitalDeptsLabel;
    [self.contentView addSubview:hospitalDeptsLabel];
    
    //分隔线
    UIImageView *diviIV = [[UIImageView alloc]initWithFrame:CGRectMake(2, 100, WIDTH - 2*2, 1)];
    diviIV.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:diviIV];
    
    
    
    
    //就诊人
    UILabel *sickNameLabel = [[UILabel alloc]init];
    sickNameLabel.font = label1.font;
    sickNameLabel.x = label1.x;
    self.sickNameLabel = sickNameLabel;
    [self.contentView addSubview:sickNameLabel];
    
    //就诊日期
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = sickNameLabel.font;
    dateLabel.x = sickNameLabel.x;
    self.dateLabel = dateLabel;
    [self.contentView addSubview:dateLabel];
    
    //挂号费用
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = dateLabel.font;
    priceLabel.x = dateLabel.x;
    self.priceLabel = priceLabel;
    [self.contentView addSubview:priceLabel];
    
    //支付方式
    UILabel *payWayLabel = [[UILabel alloc]init];
    payWayLabel.font = sickNameLabel.font;
    payWayLabel.x = priceLabel.x;
    self.payWayLabel = payWayLabel;
    [self.contentView addSubview:payWayLabel];
    
    //支付按钮或评价按钮
    UIButton *button = [[UIButton alloc]init];
    button.width = 50;
    button.height = 22;
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    button.x = WIDTH - 10- button.width;
    button.y = diviIV.maxY + (95 - button.height)/2;
    self.selButton = button;
    button.layer.cornerRadius = 5;
    button.layer.backgroundColor = LCWBottomColor.CGColor;
    [button addTarget:self action:@selector(selAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
}

-(void)layoutSubviews
{
    //预约号
    self.orderIDLabel.text = self.orderList.orderId;
    self.orderIDLabel.size = [XyqsTools getSizeWithText:self.orderIDLabel.text andFont:self.orderIDLabel.font];
    //预约状态
    switch (self.orderList.orderState)
    {
        case 1:
        {
            self.orderStatelabel.text = @"预约成功";
        }
            break;
        case 2:
        {
            self.orderStatelabel.text = @"待就诊";
        }
            break;
        case 3:
        {
            self.orderStatelabel.text = @"已取消";
        }
            break;
        case 4:
        {
            self.orderStatelabel.text = @"爽约";
        }
            break;
        case 5:
        {
            self.orderStatelabel.text = @"已就诊";
        }
            break;
        case 7:
        {
            self.orderStatelabel.text = @"已取消";
        }
            break;
        default:
            break;
    }
    self.orderStatelabel.size = [XyqsTools getSizeWithText:self.orderStatelabel.text andFont:self.orderStatelabel.font];
    self.orderStatelabel.x = WIDTH - self.orderStatelabel.width - 10;
    self.orderStatelabel.y = self.orderIDLabel.y;
    
    //医生头像
    [self.docIV setImageWithURL:[NSURL URLWithString:self.orderList.iconUrl]];
    
    //医生姓名
    self.docNameLabel.text = self.orderList.doctorName;
    self.docNameLabel.x = self.docIV.maxX + 10;
    self.docNameLabel.y = self.docIV.y;
    self.docNameLabel.size = [XyqsTools getSizeWithText:self.docNameLabel.text andFont:self.docNameLabel.font];
    
    //医生职称
    self.docLevelLabel.text = self.orderList.levelName;
    self.docLevelLabel.x = self.docNameLabel.x;
    self.docLevelLabel.y = self.docNameLabel.maxY + 5;
    self.docLevelLabel.size = [XyqsTools getSizeWithText:self.docLevelLabel.text andFont:self.docLevelLabel.font];
    
    //医生所属医院和科室
    self.hospitalDeptsLabel.text = [NSString stringWithFormat:@"%@-%@",self.orderList.hospitalName,self.orderList.deptName];
    self.hospitalDeptsLabel.x = self.docLevelLabel.x;
    self.hospitalDeptsLabel.y = self.docLevelLabel.maxY + 5;
    self.hospitalDeptsLabel.size = [XyqsTools getSizeByText:self.hospitalDeptsLabel.text andFont:self.hospitalDeptsLabel.font andWidth:200];
    
    CGFloat textHeiht = [XyqsTools getSizeWithText:@"测试" andFont:[UIFont systemFontOfSize:13]].height;
    CGFloat diviHeight = (95 - textHeiht *4)/5;
    
    //就诊人
    self.sickNameLabel.text = [NSString stringWithFormat:@"就诊人: %@",self.orderList.patientName];
    self.sickNameLabel.size = [XyqsTools getSizeWithText:self.sickNameLabel.text andFont:self.sickNameLabel.font];
    self.sickNameLabel.y = 100 + diviHeight;
    
    //就诊日期
    self.dateLabel.text = [NSString stringWithFormat:@"就诊时间: %@  %@-%@",self.orderList.orderDate,[self getTimeByDate:self.orderList.orderStartTime],[self getTimeByDate:self.orderList.orderEndTime]];
    self.dateLabel.size = [XyqsTools getSizeWithText:self.dateLabel.text andFont:self.dateLabel.font];
    self.dateLabel.y = self.sickNameLabel.maxY + diviHeight;
    
    //挂号费
    NSString *editStr = [XyqsTools stringDisposeWithFloat:self.orderList.fee];
    NSString *allStr = [NSString stringWithFormat:@"挂号费: %@ 元",editStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
    [str addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    self.priceLabel.attributedText = str;
    self.priceLabel.size = [XyqsTools getSizeWithText:self.priceLabel.text andFont:self.priceLabel.font];
    self.priceLabel.y = self.dateLabel.maxY + diviHeight;
    
    //支付方式
    if (self.orderList.payWay == 1)
    {
        self.payWayLabel.text = @"支付方式: 去医院支付";
    }
    else
    {
        self.payWayLabel.text = @"支付方式: 支付宝支付";
    }
    self.payWayLabel.size = [XyqsTools getSizeWithText:self.payWayLabel.text andFont:self.payWayLabel.font];
    self.payWayLabel.y = self.priceLabel.maxY + diviHeight;
    
    //支付或评价按钮
    if (self.orderList.payWay == 2 )
    {
        if (self.orderList.orderState == 1)
        {
            self.selButton.hidden = NO;
            [self.selButton setTitle:@"支    付" forState:UIControlStateNormal];
        }
        else if(self.orderList.orderState == 2)
        {
            self.selButton.hidden = NO;
            [self.selButton setTitle:@"评    价" forState:UIControlStateNormal];
            self.selButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
        }
        else
        {
            self.selButton.hidden = YES;
        }
    }
    else if(self.orderList.payWay == 1)
    {
        if(self.orderList.orderState == 2)
        {
            self.selButton.hidden = NO;
            [self.selButton setTitle:@"评    价" forState:UIControlStateNormal];
            self.selButton.layer.backgroundColor = [UIColor orangeColor].CGColor;
        }
        else
        {
            self.selButton.hidden = YES;
        }
    }
    
}

-(NSString *)getTimeByDate:(NSDate *)date
{
    NSString *str = (NSString *)date;
    NSArray *strArr = [str componentsSeparatedByString:@"-"];
    NSString *newStr = [NSString stringWithFormat:@"%@:%@",[strArr firstObject],[strArr lastObject]];
    return newStr;
}

-(void)selAction:(UIButton *)sender
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
//    [params setValue:token forKey:@"token"];
//    [params setValue:@(self.orderList.orderListID) forKey:@"oid"];
//    [XyqsApi payWithparams:params andCallBack:^(id obj) {
//        
//        [self saveHtmlfile:obj];
//        PayWebVC *webVC = [[PayWebVC alloc]init];
//        [self.navigationController pushViewController:webVC animated:NO];
//    }];
    
    [self.delegate myTabVClick:self];
}





@end
