//
//  OrderDetailVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/20.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//
#define MYFONT [UIFont systemFontOfSize:15]

#import "OrderDetailVC.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "OrderDetail.h"
#import "PayWebVC.h"
#import "AppDelegate.h"
#import "NoNetworkView.h"
@interface OrderDetailVC ()<UIAlertViewDelegate>

@property(nonatomic,strong)OrderDetail *orderDetail;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)int sec;        //剩余秒数
@property(nonatomic)int min;        //剩余分钟
@property(nonatomic,strong)UILabel *promptLabel;    //提示标签
@property(nonatomic,strong)UIButton *payButton;     //支付按钮
@property(nonatomic,strong)UILabel *appointStatusLabel;     //预约状态
@property(nonatomic,strong)UILabel *timeLabel;          //剩余时间
@property(nonatomic,strong)UILabel *timeLabel0;          //提醒文字
@property(nonatomic,strong)NoNetworkView *noNetView;
@end

@implementation OrderDetailVC

-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        
        [self.view addSubview:_noNetView];
        
    }
    return _noNetView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDlg = [[UIApplication sharedApplication] delegate];
    if (appDlg.isReachable)
    {
        self.noNetView.hidden = YES;
        
        [self requestData];
    }
    else
    {
        
        self.noNetView.hidden = NO;
        [self.view bringSubviewToFront:self.noNetView];
    }
}

/**
 *  网络请求
 */
-(void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[XyqsTools getToken] forKey:@"token"];
    [params setObject:@(self.orderList.orderListID) forKey:@"id"];
    //获取预约记录列表中的预约详情
    [HttpTool get:@"http://14.29.84.4:6060/0.1/orderrecord/detail" params:params success:^(id responseObj) {
        self.noNetView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            self.orderDetail = [JsonParser parseOrderDetailByDictionary:responseObj];
            [self initUI];
            if (self.orderDetail.orderState == 1 && self.orderDetail.leftTime > 0)
            {
                //右键取消
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
        }
        else
        {
            [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        if (error)
        {
            self.noNetView.hidden = NO;
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
    
    

-(void)initUI
{
    UIScrollView *baseSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    baseSv.backgroundColor = LCWBackgroundColor;
    [self.view addSubview:baseSv];
    
    //预约号
    UILabel *appointNumLabel = [[UILabel alloc]init];
    appointNumLabel.font = MYFONT;
    appointNumLabel.text = [NSString stringWithFormat:@"预约号: %@",self.orderDetail.orderId];
    appointNumLabel.size = [XyqsTools getSizeByText:appointNumLabel.text andFont:MYFONT andWidth:WIDTH/2-20];
    appointNumLabel.x = 10;
    appointNumLabel.y = 44/2 - appointNumLabel.height/2;
    [baseSv addSubview:appointNumLabel];
    
    UILabel *appointLabel = [[UILabel alloc]init];
    appointLabel.text = @"预约状态:";
    appointLabel.font = MYFONT;
    appointLabel.size = [XyqsTools getSizeWithText:appointLabel.text andFont:appointLabel.font];
    appointLabel.y = appointNumLabel.y;
    appointLabel.x = WIDTH - 10 - appointLabel.width * 2;
    [baseSv addSubview:appointLabel];
    
    //预约状态
    UILabel *appointStatusLabel = [[UILabel alloc]init];
    appointStatusLabel.font = MYFONT;
    appointStatusLabel.textColor = LCWBottomColor;
    self.appointStatusLabel = appointStatusLabel;
    self.appointStatusLabel.size = appointLabel.size;
    self.appointStatusLabel.x = WIDTH - appointLabel.width - 8;
    self.appointStatusLabel.y = appointNumLabel.y;
    [baseSv addSubview:appointStatusLabel];
    
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
            self.appointStatusLabel.text = @"待就诊";
        }
            break;
        case 3:
        {
            self.appointStatusLabel.text = @"已取消";
        }
            break;
        case 4:
        {
            self.appointStatusLabel.text = @"爽约";
        }
            break;
        case 5:
        {
            self.appointStatusLabel.text = @"已就诊";
        }
            break;
        case 7:
        {
            self.appointStatusLabel.text = @"已取消";
        }
            break;
        default:
            break;
    }

    //分割线1
    UIImageView *diviLine1 = [[UIImageView alloc]init];
    diviLine1.backgroundColor = LCWDivisionLineColor;
    diviLine1.height = 1;
    diviLine1.width = WIDTH;
    diviLine1.x = 0;
    diviLine1.y = 43;
    [baseSv addSubview:diviLine1];
    
    //医院名称
    UILabel *hospNameLabel = [[UILabel alloc]init];
    hospNameLabel.font = MYFONT;
    hospNameLabel.text = [NSString stringWithFormat:@"医院名称: %@",self.orderDetail.hospitalName];
    hospNameLabel.size = [XyqsTools getSizeWithText:hospNameLabel.text andFont:hospNameLabel.font];
    hospNameLabel.x = 10;
    hospNameLabel.y = diviLine1.maxY + 15;
    [baseSv addSubview:hospNameLabel];
    
    //科室
    UILabel *deptsNameLabel = [[UILabel alloc]init];
    deptsNameLabel.font = MYFONT;
    deptsNameLabel.text = [NSString stringWithFormat:@"挂号科室: %@",self.orderDetail.deptName];
    deptsNameLabel.size = [XyqsTools getSizeWithText:deptsNameLabel.text andFont:deptsNameLabel.font];
    deptsNameLabel.x = hospNameLabel.x;
    deptsNameLabel.y = hospNameLabel.maxY + 10;
    [baseSv addSubview:deptsNameLabel];
    
    //医生
    UILabel *doctorNameLabel = [[UILabel alloc]init];
    doctorNameLabel.font = MYFONT;
    doctorNameLabel.text = [NSString stringWithFormat:@"医生姓名: %@",self.orderDetail.doctorName];
    doctorNameLabel.size = [XyqsTools getSizeWithText:doctorNameLabel.text andFont:doctorNameLabel.font];
    doctorNameLabel.x = hospNameLabel.x;
    doctorNameLabel.y = deptsNameLabel.maxY + 10;
    [baseSv addSubview:doctorNameLabel];
    
    //等级
    UILabel *levelNameLabel = [[UILabel alloc]init];
    levelNameLabel.font = MYFONT;
    levelNameLabel.text = [NSString stringWithFormat:@"医生职称: %@",self.orderDetail.levelName];
    levelNameLabel.size = [XyqsTools getSizeWithText:levelNameLabel.text andFont:levelNameLabel.font];
    levelNameLabel.x = hospNameLabel.x;
    levelNameLabel.y = doctorNameLabel.maxY + 10;
    [baseSv addSubview:levelNameLabel];
    
    //就诊时间
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = MYFONT;
    dateLabel.text = [NSString stringWithFormat:@"就诊时间: %@  %@-%@",self.orderDetail.orderDate ,[self getTimeByDate:self.orderDetail.orderStartTime],[self getTimeByDate:self.orderDetail.orderEndTime]];
    dateLabel.size = [XyqsTools getSizeWithText:dateLabel.text andFont:dateLabel.font];
    dateLabel.width = WIDTH;
    dateLabel.x = hospNameLabel.x;
    dateLabel.y = levelNameLabel.maxY + 10;
    [baseSv addSubview:dateLabel];
    
    //挂号费用
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = MYFONT;
    NSString *editStr = [XyqsTools stringDisposeWithFloat:self.orderDetail.fee];
    NSString *allStr = [NSString stringWithFormat:@"挂号费用: %@ 元",editStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
    [str addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    priceLabel.attributedText = str;
    priceLabel.size = [XyqsTools getSizeWithText:priceLabel.text andFont:priceLabel.font];
    priceLabel.x = hospNameLabel.x;
    priceLabel.y = dateLabel.maxY + 10;
    [baseSv addSubview:priceLabel];
    
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
    [baseSv addSubview:payWayLabel];
    
    //分割线2
    UIImageView *diviLine2 = [[UIImageView alloc]init];
    diviLine2.backgroundColor = LCWDivisionLineColor;
    diviLine2.height = 1;
    diviLine2.width = WIDTH;
    diviLine2.x = 0;
    diviLine2.y = payWayLabel.maxY + 15;
    [baseSv addSubview:diviLine2];
    
    //就诊人
    UILabel *sickNameLabel = [[UILabel alloc]init];
    sickNameLabel.font = MYFONT;
    sickNameLabel.text = [NSString stringWithFormat:@"就  诊  人: %@",self.orderDetail.patientName];
    sickNameLabel.size = [XyqsTools getSizeWithText:sickNameLabel.text andFont:sickNameLabel.font];
    sickNameLabel.x = payWayLabel.x;
    sickNameLabel.y = diviLine2.maxY + 15;
    [baseSv addSubview:sickNameLabel];
    
    //身份证号码
    UILabel *sickIDLabel = [[UILabel alloc]init];
    sickIDLabel.font = MYFONT;
    NSString *IDStr  = [self.orderDetail.idCard stringByReplacingCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
    sickIDLabel.text = [NSString stringWithFormat:@"身份证号: %@",IDStr];
    sickIDLabel.size = [XyqsTools getSizeWithText:sickIDLabel.text andFont:sickIDLabel.font];
    sickIDLabel.width = WIDTH;
    sickIDLabel.x = sickNameLabel.x;
    sickIDLabel.y = sickNameLabel.maxY + 10;
    [baseSv addSubview:sickIDLabel];
    
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
    [baseSv addSubview:sickTelLabel];
    
    //分割线3
    UIImageView *diviLine3 = [[UIImageView alloc]init];
    diviLine3.backgroundColor = LCWDivisionLineColor;
    diviLine3.height = 1;
    diviLine3.width = WIDTH;
    diviLine3.x = 0;
    diviLine3.y = sickTelLabel.maxY + 15;
    [baseSv addSubview:diviLine3];

    if (self.orderDetail.orderState == 1 && self.orderDetail.leftTime >0)
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
            [button setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(aliPayAction:) forControlEvents:UIControlEventTouchUpInside];
            self.payButton = button;
            [baseSv addSubview:button];
            
            //提示标签
            UILabel *timeLabel0 = [[UILabel alloc]init];
            timeLabel0.text = @"您已经预约成功，支付方式是支付宝支付，请在";
            timeLabel0.font = [UIFont systemFontOfSize:11];
            timeLabel0.textColor = [UIColor grayColor];
            timeLabel0.size = [XyqsTools getSizeByText:timeLabel0.text andFont:timeLabel0.font andWidth:WIDTH - 44.5 * 2];
            timeLabel0.y = button.maxY + 15;
            timeLabel0.centerX = self.view.centerX;
            self.timeLabel0 = timeLabel0;
            [baseSv addSubview:timeLabel0];
            
            
            UILabel *timeLabel = [[UILabel alloc]init];
            timeLabel.textColor = [UIColor grayColor];
            timeLabel.font = timeLabel0.font;
            self.min = self.orderDetail.leftTime/60;
            self.sec = self.orderDetail.leftTime%60;
            NSString *editStr = [NSString stringWithFormat:@"%d分%d秒",self.min,self.sec];
            NSString *allStr = [NSString stringWithFormat:@"%@内完成支付，超时您的预约将被取消。",editStr];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:allStr];
            [text addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
            timeLabel.attributedText = text;
            timeLabel.y = timeLabel0.maxY + 3;
            timeLabel.width = timeLabel0.width + 10 ;
            timeLabel.height = timeLabel0.height;
            timeLabel.textAlignment = NSTextAlignmentLeft;
            timeLabel.x = timeLabel0.x;
            self.timeLabel = timeLabel;
            [baseSv addSubview:timeLabel];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeShow:) userInfo:timeLabel repeats:YES];
        }
    }
    
    if (self.orderDetail.orderState == 7)
    {
        //提示标签
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.text = @"您的预约未按时支付，已经被取消";
        timeLabel.y = diviLine3.maxY + 15;
        timeLabel.width = WIDTH - 40 * 2;
        timeLabel.size = [XyqsTools getSizeByText:timeLabel.text andFont:timeLabel.font andWidth:timeLabel.width];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.numberOfLines = 0;
        timeLabel.centerX = self.view.centerX;
        [baseSv addSubview:timeLabel];
    }
    
    
    baseSv.contentSize = CGSizeMake(WIDTH, HEIGHT * 1.2);
    
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

        self.payButton.enabled = NO;
        [self.payButton setBackgroundImage:[UIImage imageNamed:@"outtimePay.png"] forState:UIControlStateNormal];
        
        label.text = @"您的预约未按时支付，已经被取消";
        label.y = self.timeLabel0.y;
        [self.timeLabel0 removeFromSuperview];
        label.textAlignment = NSTextAlignmentCenter;
        
        self.navigationItem.rightBarButtonItem = nil;
        self.appointStatusLabel.text = @"已取消";
        return;
    }
    NSString *editStr = [NSString stringWithFormat:@"%d分%d秒",self.min,self.sec];
    NSString *allStr = [NSString stringWithFormat:@"%@内完成支付，超时您的预约将被取消。",editStr];
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

/**
 *  支付功能
 */
-(void)aliPayAction:(UIButton *)button
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [params setValue:token forKey:@"token"];
    [params setValue:@(self.orderDetail.orderRecoderID) forKey:@"oid"];
    
    //支付
    [HttpTool get:@"http://14.29.84.4:6060/0.1/pay/unionpay_wap" params:params success:^(id responseObj) {
        self.noNetView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *htmldic = [responseObj objectForKey:@"data"];
            [self saveHtmlfile:[htmldic objectForKey:@"html"]];
            PayWebVC *webVC = [[PayWebVC alloc]init];
            [self.navigationController pushViewController:webVC animated:NO];
        }
        else
        {
            [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        if (error)
        {
            self.noNetView.hidden = NO;
        }
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


-(void)onClick:(UIBarButtonItem *)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"确认取消该预约?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"返回", nil];
    
    [av show];
}


-(void)home
{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
            self.navigationItem.rightBarButtonItem = nil;
            self.appointStatusLabel.text = @"已取消";
            //取消订单操作
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
            [params setObject:@(self.orderDetail.sourceId) forKey:@"tid"];
            [params setObject:@(self.orderDetail.orderRecoderID) forKey:@"oid"];
            [params setObject:@(self.orderDetail.doctorId) forKey:@"doctId"];
            [params setObject:@(self.orderDetail.deptId) forKey:@"deptId"];
            [params setObject:self.orderDetail.orderId forKey:@"orderId"];
            
            //取消订单
            [HttpTool post:@"http://14.29.84.4:6060/0.1/order/cancel" params:params success:^(id responseObj) {
                self.noNetView.hidden = YES;
                if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
                {
                    [MBProgressHUD showSuccess:@"您已取消预约"];
                    [self.timer invalidate];
                    
                    self.payButton.enabled = NO;
                    [self.payButton setBackgroundImage:[UIImage imageNamed:@"selTimer.png"] forState:UIControlStateNormal];
                    self.timeLabel.text = @"";
                    self.timeLabel.textAlignment = NSTextAlignmentCenter;
                    [self.timeLabel0 removeFromSuperview];
                    self.appointStatusLabel.text = @"已取消";
                }
                else
                {
                    [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
                }
            } failure:^(NSError *error) {
                if (error)
                {
                    self.noNetView.hidden = NO;
                }
            }];
            return;
           
        }
            break;
            
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}


@end
