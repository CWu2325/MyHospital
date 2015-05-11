//
//  OrderDetailVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/20.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//
#define MYFONT [UIFont systemFontOfSize:15]

#import "OrderDetailVC.h"
#import "XyqsApi.h"
#import "OrderDetail.h"
#import "PayWebVC.h"

@interface OrderDetailVC ()<UIAlertViewDelegate>

@property(nonatomic,strong)OrderDetail *orderDetail;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)int sec;        //剩余秒数
@property(nonatomic)int min;        //剩余分钟
@property(nonatomic,strong)UILabel *promptLabel;    //提示标签
@property(nonatomic,strong)UIButton *payButton;     //支付按钮
@property(nonatomic,strong)UILabel *appointStatusLabel;     //预约状态
@property(nonatomic,strong)UILabel *timeLabel;          //剩余时间
@end

@implementation OrderDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [params setObject:@(self.orderList.orderListID) forKey:@"id"];
    [XyqsApi requestOrderDetailWithParams:params andCallBack:^(id obj) {
        self.orderDetail = obj;
        [self initUI];
        if (self.orderDetail.orderState == 1)
        {
            //右键取消
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
        }
        [self.view setNeedsDisplay];
    }];
}

-(void)initUI
{
    //预约号
    UILabel *appointNumLabel = [[UILabel alloc]init];
    appointNumLabel.font = MYFONT;
    appointNumLabel.text = [NSString stringWithFormat:@"预约号: %@",self.orderDetail.orderId];
    appointNumLabel.size = [XyqsTools getSizeByText:appointNumLabel.text andFont:MYFONT andWidth:WIDTH/2-20];
    appointNumLabel.x = 10;
    appointNumLabel.y = 44/2 - appointNumLabel.height/2;
    [self.view addSubview:appointNumLabel];
    
    UILabel *appointLabel = [[UILabel alloc]init];
    appointLabel.text = @"预约状态:";
    appointLabel.font = MYFONT;
    appointLabel.size = [XyqsTools getSizeWithText:appointLabel.text andFont:appointLabel.font];
    appointLabel.y = appointNumLabel.y;
    appointLabel.x = WIDTH - 10 - appointLabel.width * 2;
    [self.view addSubview:appointLabel];
    
    //预约状态
    UILabel *appointStatusLabel = [[UILabel alloc]init];
    appointStatusLabel.font = MYFONT;
    appointStatusLabel.textColor = LCWBottomColor;
    self.appointStatusLabel = appointStatusLabel;
    self.appointStatusLabel.size = appointLabel.size;
    self.appointStatusLabel.x = WIDTH - appointLabel.width - 8;
    self.appointStatusLabel.y = appointNumLabel.y;
    [self.view addSubview:appointStatusLabel];
    
    //预约状态
    switch (self.orderDetail.orderState)
    {
        case 1:
        {
            self.appointStatusLabel.text = @"预约成功";
        }
            break;
        case 2:
        {
            self.appointStatusLabel.text = @"已就诊";
        }
            break;
        case 3:
        {
            self.appointStatusLabel.text = @"预约退号";
        }
            break;
        case 4:
        {
            self.appointStatusLabel.text = @"爽约";
        }
            break;
        case 5:
        {
            self.appointStatusLabel.text = @"预约退号";
        }
            break;
        default:
            break;
    }

    //分割线1
    UIImageView *diviLine1 = [[UIImageView alloc]init];
    diviLine1.backgroundColor = [UIColor lightGrayColor];
    diviLine1.height = 1;
    diviLine1.width = WIDTH;
    diviLine1.x = 0;
    diviLine1.y = 43;
    [self.view addSubview:diviLine1];
    
    //医院名称
    UILabel *hospNameLabel = [[UILabel alloc]init];
    hospNameLabel.font = MYFONT;
    hospNameLabel.text = [NSString stringWithFormat:@"医院名称: %@",self.orderDetail.hospitalName];
    hospNameLabel.size = [XyqsTools getSizeWithText:hospNameLabel.text andFont:hospNameLabel.font];
    hospNameLabel.x = 10;
    hospNameLabel.y = diviLine1.maxY + 15;
    [self.view addSubview:hospNameLabel];
    
    //科室
    UILabel *deptsNameLabel = [[UILabel alloc]init];
    deptsNameLabel.font = MYFONT;
    deptsNameLabel.text = [NSString stringWithFormat:@"挂号科室: %@",self.orderDetail.deptName];
    deptsNameLabel.size = [XyqsTools getSizeWithText:deptsNameLabel.text andFont:deptsNameLabel.font];
    deptsNameLabel.x = hospNameLabel.x;
    deptsNameLabel.y = hospNameLabel.maxY + 10;
    [self.view addSubview:deptsNameLabel];
    
    //医生
    UILabel *doctorNameLabel = [[UILabel alloc]init];
    doctorNameLabel.font = MYFONT;
    doctorNameLabel.text = [NSString stringWithFormat:@"医生姓名: %@",self.orderDetail.doctorName];
    doctorNameLabel.size = [XyqsTools getSizeWithText:doctorNameLabel.text andFont:doctorNameLabel.font];
    doctorNameLabel.x = hospNameLabel.x;
    doctorNameLabel.y = deptsNameLabel.maxY + 10;
    [self.view addSubview:doctorNameLabel];
    
    //等级
    UILabel *levelNameLabel = [[UILabel alloc]init];
    levelNameLabel.font = MYFONT;
    levelNameLabel.text = [NSString stringWithFormat:@"医生职称: %@",self.orderDetail.levelName];
    levelNameLabel.size = [XyqsTools getSizeWithText:levelNameLabel.text andFont:levelNameLabel.font];
    levelNameLabel.x = hospNameLabel.x;
    levelNameLabel.y = doctorNameLabel.maxY + 10;
    [self.view addSubview:levelNameLabel];
    
    //就诊时间
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = MYFONT;
    dateLabel.text = [NSString stringWithFormat:@"就诊时间: %@  %@-%@",self.orderDetail.orderDate ,[self getTimeByDate:self.orderDetail.orderStartTime],[self getTimeByDate:self.orderDetail.orderEndTime]];
    dateLabel.size = [XyqsTools getSizeWithText:dateLabel.text andFont:dateLabel.font];
    dateLabel.width = WIDTH;
    dateLabel.x = hospNameLabel.x;
    dateLabel.y = levelNameLabel.maxY + 10;
    [self.view addSubview:dateLabel];
    
    //挂号费用
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = MYFONT;
    NSString *editStr = [XyqsTools stringDisposeWithFloat:self.orderDetail.fee];
    NSString *allStr = [NSString stringWithFormat:@"挂号费: %@ 元",editStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
    [str addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    priceLabel.attributedText = str;
    priceLabel.size = [XyqsTools getSizeWithText:priceLabel.text andFont:priceLabel.font];
    priceLabel.x = hospNameLabel.x;
    priceLabel.y = dateLabel.maxY + 10;
    [self.view addSubview:priceLabel];
    
    //支付方式
    UILabel *payWayLabel = [[UILabel alloc]init];
    payWayLabel.font = MYFONT;
    if (self.orderDetail.payWay == 2)
    {
        payWayLabel.text = [NSString stringWithFormat:@"支付方式: 支付宝支付"];
    }
    else
    {
        payWayLabel.text = [NSString stringWithFormat:@"支付方式: 去医院支付"];
    }
    payWayLabel.size = [XyqsTools getSizeWithText:payWayLabel.text andFont:payWayLabel.font];
    payWayLabel.x = priceLabel.x;
    payWayLabel.y = priceLabel.maxY + 10;
    [self.view addSubview:payWayLabel];
    
    //分割线2
    UIImageView *diviLine2 = [[UIImageView alloc]init];
    diviLine2.backgroundColor = [UIColor lightGrayColor];
    diviLine2.height = 1;
    diviLine2.width = WIDTH;
    diviLine2.x = 0;
    diviLine2.y = payWayLabel.maxY + 15;
    [self.view addSubview:diviLine2];
    
    //就诊人
    UILabel *sickNameLabel = [[UILabel alloc]init];
    sickNameLabel.font = MYFONT;
    sickNameLabel.text = [NSString stringWithFormat:@"就诊人: %@",self.orderDetail.patientName];
    sickNameLabel.size = [XyqsTools getSizeWithText:sickNameLabel.text andFont:sickNameLabel.font];
    sickNameLabel.x = payWayLabel.x;
    sickNameLabel.y = diviLine2.maxY + 15;
    [self.view addSubview:sickNameLabel];
    
    //身份证号码
    UILabel *sickIDLabel = [[UILabel alloc]init];
    sickIDLabel.font = MYFONT;
    NSString *IDStr  = [self.orderDetail.idCard stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
    sickIDLabel.text = [NSString stringWithFormat:@"身份证号: %@",IDStr];
    sickIDLabel.size = [XyqsTools getSizeWithText:sickIDLabel.text andFont:sickIDLabel.font];
    sickIDLabel.width = WIDTH;
    sickIDLabel.x = sickNameLabel.x;
    sickIDLabel.y = sickNameLabel.maxY + 10;
    [self.view addSubview:sickIDLabel];
    
    //电话号码
    UILabel *sickTelLabel = [[UILabel alloc]init];
    sickTelLabel.font = MYFONT;
    if (self.orderDetail.mobile == (NSString *)[NSNull null])
    {
        self.orderDetail.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"telNumber"];
    }
    NSString *telStr = [self.orderDetail.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    sickTelLabel.text = [NSString stringWithFormat:@"电话号码: %@",telStr];
    sickTelLabel.size = [XyqsTools getSizeWithText:sickTelLabel.text andFont:sickTelLabel.font];
    sickTelLabel.x = sickIDLabel.x;
    sickTelLabel.y = sickIDLabel.maxY + 10;
    [self.view addSubview:sickTelLabel];
    
    //分割线3
    UIImageView *diviLine3 = [[UIImageView alloc]init];
    diviLine3.backgroundColor = [UIColor lightGrayColor];
    diviLine3.height = 1;
    diviLine3.width = WIDTH;
    diviLine3.x = 0;
    diviLine3.y = sickTelLabel.maxY + 15;
    [self.view addSubview:diviLine3];

    if (self.orderDetail.orderState == 1)
    {
        if (self.orderDetail.payWay == 2)
        {
            //支付按钮
            UIButton *button = [[UIButton alloc]init];
            button.y = diviLine3.maxY + 15;
            button.width = 150;
            button.height = 30;
            button.centerX = self.view.centerX;
            [button setTitle:@"支        付" forState:UIControlStateNormal];
            button.layer.cornerRadius = 8;
            button.layer.backgroundColor = [UIColor greenColor].CGColor;
            [button addTarget:self action:@selector(aliPayAction:) forControlEvents:UIControlEventTouchUpInside];
            self.payButton = button;
            [self.view addSubview:button];
            
            //提示标签
            UILabel *timeLabel = [[UILabel alloc]init];
            self.min = 14;
            self.sec = 59;
            timeLabel.textColor = [UIColor grayColor];
            timeLabel.font = [UIFont systemFontOfSize:12];
            NSString *editStr = [NSString stringWithFormat:@"%d分%d秒",self.min,self.sec];
            NSString *allStr = [NSString stringWithFormat:@"您已经预约成功,支付方式是支付宝支付,请在%@内完成支付，超时您的预约将被取消。",editStr];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:allStr];
            [text addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
            timeLabel.attributedText = text;
            timeLabel.y = button.maxY + 15;
            timeLabel.width = WIDTH - 45 * 2;
            timeLabel.size = [XyqsTools getSizeByText:timeLabel.text andFont:timeLabel.font andWidth:WIDTH - 45 * 2];
            timeLabel.textAlignment = NSTextAlignmentLeft;
            timeLabel.numberOfLines = 0;
            timeLabel.centerX = self.view.centerX;
            self.timeLabel = timeLabel;
            [self.view addSubview:timeLabel];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeShow:) userInfo:timeLabel repeats:YES];
        }
    }
    
}

//倒计时
-(void)changeTimeShow:(NSTimer *)timer
{
    self.orderDetail.leftTime --;
    self.min = self.orderDetail.leftTime/60;
    self.sec = self.orderDetail.leftTime%60;
    UILabel *label = timer.userInfo;
    if (self.orderDetail.leftTime <= 0)
    {
        [timer invalidate];
        [label removeFromSuperview];
        [self.promptLabel removeFromSuperview];
        [self.payButton removeFromSuperview];
        self.appointStatusLabel.text = @"已取消";
        return;
    }
    NSString *editStr = [NSString stringWithFormat:@"%d分%d秒",self.min,self.sec];
    NSString *allStr = [NSString stringWithFormat:@"您已预约成功,支付方式是支付宝支付,请在%@内完成支付，超时您的预约将被取消",editStr];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:allStr];
    [text addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    label.attributedText = text;
}

-(NSString *)getTimeByDate:(NSDate *)date
{
    NSString *str = (NSString *)date;
    NSArray *strArr = [str componentsSeparatedByString:@"-"];
    NSString *newStr = [NSString stringWithFormat:@"%@:%@",[strArr firstObject],[strArr lastObject]];
    return newStr;
}

-(void)aliPayAction:(UIButton *)button
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [params setValue:token forKey:@"token"];
    [params setValue:@(self.orderDetail.orderRecoderID) forKey:@"oid"];
    
    [XyqsApi payWithparams:params andCallBack:^(id obj) {
        
        [self saveHtmlfile:obj];

        PayWebVC *webVC = [[PayWebVC alloc]init];
        
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
    
}

/**
 *  写html文件并保持在沙盒中
 */
-(void)saveHtmlfile:(NSString *)text
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"pay.html"];
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}


-(void)onClick:(UIBarButtonItem *)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"取消预约" message:@"是否确认取消该订单" delegate:self cancelButtonTitle:@"取消订单" otherButtonTitles:@"返回", nil];
    
    [av show];

}


-(void)home
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/**
 *  取消订单弹出窗口
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"goback_homepage@2x.png" highImageName:@"goback_homepage@2x.png" target:self action:@selector(home)];
            self.appointStatusLabel.text = @"已取消";
            //取消订单操作
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
            [params setObject:@(self.orderDetail.sourceId) forKey:@"tid"];
            [params setObject:@(self.orderDetail.orderRecoderID) forKey:@"oid"];
            [params setObject:@(self.orderDetail.doctorId) forKey:@"doctId"];
            [params setObject:@(self.orderDetail.deptId) forKey:@"deptId"];
            [params setObject:self.orderDetail.orderId forKey:@"orderId"];
            [XyqsApi CancelOrderWithParams:params andCallBack:^(id obj) {
                [self.timer invalidate];
                [self.promptLabel removeFromSuperview];
                [self.payButton removeFromSuperview];
                [self.timeLabel removeFromSuperview];
                self.appointStatusLabel.text = @"已取消";
            }];
        }
            break;
            
        case 1:
        {
            return;
        }
            break;
            
        default:
            break;
    }
}


@end