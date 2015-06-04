
//  InfoConfirmViewC.m
//  MyHospital
//
//  Created by XYQS on 15/4/10.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#define MYFONT [UIFont systemFontOfSize:15];

#import "InfoConfirmViewC.h"
#import "AlipayConfirmVC.h"
#import "FrequentlyPersonsVC.h"
#import "comMember.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "TimeQuantum.h"
#import "LoginViewController.h"
#import "User.h"
#import "MySelSickBtn.h"
#import "NoNetworkView.h"
#import "AppDelegate.h"
#import "TimeoutView.h"

@interface InfoConfirmViewC ()<PassMember,UIAlertViewDelegate,TimeOutDelegate>
@property(nonatomic,strong)NSMutableDictionary *params;     //用于保存请求预约号的字典
@property(nonatomic,strong)comMember *member;               //反向传值过来的预约人
@property(nonatomic)int radioBtn;//单选按钮

@property(nonatomic,strong)UIImageView *iv1;            //支付宝图片
@property(nonatomic,strong)UIImageView *iv2;            //现场支付图片
@property(nonatomic,copy)NSString *sickName;      //就诊人姓名
@property(nonatomic,strong)UILabel *dateLabel;          //就诊时间

@property(nonatomic,strong)MySelSickBtn *selSickBtn;       //选择就诊人按钮

@property(nonatomic,strong)NoNetworkView *noNetView;
@property(nonatomic)AppDelegate *appDlg;
@property(nonatomic,strong)TimeoutView *timeOutView;

@end

@implementation InfoConfirmViewC
-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        [self.view addSubview:_noNetView];
    }
    return _noNetView;
}

-(TimeoutView *)timeOutView
{
    if (!_timeOutView)
    {
        _timeOutView = [[TimeoutView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _timeOutView.delegate = self;
        [self.view addSubview:_timeOutView];
    }
    return _timeOutView;
}

/**
 *  网络超时界面的代理事件
 */
-(void)tapTimeOutBtnAction
{
    if (self.appDlg.isReachable)
    {
        self.timeOutView.hidden = YES;
        [self requestData];
    }
    else
    {
        [MBProgressHUD showError:@"网络不给力，请稍后再试！"];
        self.timeOutView.hidden = NO;
    }
}


-(NSMutableDictionary *)params
{
    if (!_params)
    {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}

-(void)passMember:(comMember *)member
{
    self.member = member;
    
    if (member.name != (NSString *)[NSNull null])
    {
        [self.selSickBtn setTitle:member.name forState:UIControlStateNormal];
        
    }
    
    if (self.member.comID != (NSString *)[NSNull null])
    {
        [self.params setObject:self.member.comID forKey:@"mberId"];         //就诊人ID
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约信息确认";
    //默认单选为0
    self.radioBtn = 0;
    
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.appDlg = [[UIApplication sharedApplication] delegate];
    if (self.appDlg.isReachable)
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
    //先请求
    NSMutableDictionary *params0 = [NSMutableDictionary dictionary];
    [params0 setObject:@(self.doctor.doctorID) forKey:@"doctId"];
    [params0 setObject:@(self.depts.roomID) forKey:@"deptId"];
    [params0 setObject:@(self.schedules.ampm) forKey:@"ampm"];
    [params0 setObject:self.schedules.date forKey:@"orderDate"];
    
    //获取医生某日上午或下午的坐诊时段列表
    [MBProgressHUD showMessage:@"正在加载..."];
    [HttpTool get:@"http://14.29.84.4:6060/0.1/order/time" params:params0 success:^(id responseObj) {
        [MBProgressHUD hideHUD];
        self.timeOutView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [responseObj objectForKey:@"data"];
            NSArray *arr = [JsonParser parseTimesByDictionary:dataDic];
            for(TimeQuantum *t in arr)
            {
                [self.params setObject:@(t.tid) forKey:@"tid"];
                self.time = t;
                self.dateLabel.text = [NSString stringWithFormat:@"就诊时间: %@  %@-%@",self.schedules.date,self.time.startTime,self.time.endTime];
            }
        }
        else
        {
            [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error)
        {
            self.timeOutView.hidden = NO;
        }
    }];
}




-(void)initUI
{
    UIScrollView *baseSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    baseSv.backgroundColor = LCWBackgroundColor;
    [self.view addSubview:baseSv];
    
    //医院名称
    UILabel *hospNameLabel = [[UILabel alloc]init];
    hospNameLabel.font = MYFONT;
    hospNameLabel.text = [NSString stringWithFormat:@"医院名称: %@",self.doctor.hospitalName];
    hospNameLabel.size = [XyqsTools getSizeWithText:hospNameLabel.text andFont:hospNameLabel.font];
    hospNameLabel.x = 10;
    hospNameLabel.y = 15;
    [baseSv addSubview:hospNameLabel];
    
    //科室
    UILabel *deptsNameLabel = [[UILabel alloc]init];
    deptsNameLabel.font = MYFONT;
    deptsNameLabel.text = [NSString stringWithFormat:@"挂号科室: %@",self.doctor.departmentName];
    deptsNameLabel.size = [XyqsTools getSizeWithText:deptsNameLabel.text andFont:deptsNameLabel.font];
    deptsNameLabel.x = hospNameLabel.x;
    deptsNameLabel.y = hospNameLabel.maxY + 10;
    [baseSv addSubview:deptsNameLabel];
    
    //医生
    UILabel *doctorNameLabel = [[UILabel alloc]init];
    doctorNameLabel.font = MYFONT;
    doctorNameLabel.text = [NSString stringWithFormat:@"医生姓名: %@",self.doctor.doctorName];
    doctorNameLabel.size = [XyqsTools getSizeWithText:doctorNameLabel.text andFont:doctorNameLabel.font];
    doctorNameLabel.x = hospNameLabel.x;
    doctorNameLabel.y = deptsNameLabel.maxY + 10;
    [baseSv addSubview:doctorNameLabel];
    
    //等级
    UILabel *levelNameLabel = [[UILabel alloc]init];
    levelNameLabel.font = MYFONT;
    levelNameLabel.text = [NSString stringWithFormat:@"医生职称: %@",self.doctor.levelName];
    levelNameLabel.size = [XyqsTools getSizeWithText:levelNameLabel.text andFont:levelNameLabel.font];
    levelNameLabel.x = hospNameLabel.x;
    levelNameLabel.y = doctorNameLabel.maxY + 10;
    [baseSv addSubview:levelNameLabel];
    
    //就诊时间
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = MYFONT;
    dateLabel.text = [NSString stringWithFormat:@"就诊时间: %@  %@-%@",self.schedules.date,self.time.startTime,self.time.endTime];
    dateLabel.size = [XyqsTools getSizeWithText:dateLabel.text andFont:dateLabel.font];
    dateLabel.width = WIDTH;
    dateLabel.x = hospNameLabel.x;
    dateLabel.y = levelNameLabel.maxY + 10;
    self.dateLabel = dateLabel;
    [baseSv addSubview:dateLabel];
    
    //挂号费用
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.font = MYFONT;
    
    NSString *editStr = [XyqsTools stringDisposeWithFloat:self.doctor.fee];
    NSString *allStr = [NSString stringWithFormat:@"挂号费用:%@元",editStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
    [str addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    priceLabel.attributedText = str;
    priceLabel.size = [XyqsTools getSizeWithText:priceLabel.text andFont:priceLabel.font];
    priceLabel.x = hospNameLabel.x;
    priceLabel.y = dateLabel.maxY + 10;
    [baseSv addSubview:priceLabel];
    
    //分割线1
    UIView *diviLine = [[UIView alloc]init];
    diviLine.x = 0;
    diviLine.y = priceLabel.maxY + 15;
    diviLine.width = WIDTH;
    diviLine.height = 1;
    diviLine.backgroundColor = [UIColor lightGrayColor];
    [baseSv addSubview:diviLine];
    
    //就诊人标签
    UILabel *Label1 = [[UILabel alloc]init];
    Label1.font = MYFONT;
    Label1.text = @"就诊人";
    Label1.size = [XyqsTools getSizeWithText:Label1.text andFont:Label1.font];
    Label1.x = hospNameLabel.x;
    Label1.centerY = diviLine.y + 22;
    [baseSv addSubview:Label1];
    
    //分割线2
    UIView *diviLine1 = [[UIView alloc]init];
    diviLine1.x = 0;
    diviLine1.y = diviLine.y + 44;
    diviLine1.width = WIDTH;
    diviLine1.height = 1;
    diviLine1.backgroundColor = [UIColor lightGrayColor];
    [baseSv addSubview:diviLine1];
    
    //****************-------------------就诊人选择
    if (self.member.name != (NSString *)[NSNull null])
    {
        self.sickName = self.user.name;
    }
    else
    {
        self.sickName = self.member.name;
    }
    MySelSickBtn *selSickBtn = [[MySelSickBtn alloc]init];
    self.selSickBtn = selSickBtn;
    selSickBtn.tag = 1;
    selSickBtn.width = WIDTH;
    selSickBtn.height = 43;
    selSickBtn.x = 0;
    selSickBtn.y = diviLine1.y + 1;
    [selSickBtn setTitle:self.sickName forState:UIControlStateNormal];
    [selSickBtn setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
    [selSickBtn setBackgroundImage:[UIImage imageWithColor:LCWBackgroundColor] forState:UIControlStateNormal];
    [selSickBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [selSickBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseSv addSubview:selSickBtn];
    
    //分割线3
    UIView *diviLine2 = [[UIView alloc]init];
    diviLine2.x = 0;
    diviLine2.y = diviLine1.y + 44;
    diviLine2.width = WIDTH;
    diviLine2.height = 1;
    diviLine2.backgroundColor = [UIColor lightGrayColor];
    [baseSv addSubview:diviLine2];
    
    //选择支付方式
    UILabel *Label2 = [[UILabel alloc]init];
    Label2.font = MYFONT;
    Label2.text = @"选择支付方式";
    Label2.size = [XyqsTools getSizeWithText:Label2.text andFont:Label2.font];
    Label2.x = hospNameLabel.x;
    Label2.centerY = diviLine2.y + 22;
    [baseSv addSubview:Label2];
    
    //分割线4
    UIView *diviLine3 = [[UIView alloc]init];
    diviLine3.x = 0;
    diviLine3.y = diviLine2.y + 44;
    diviLine3.width = WIDTH;
    diviLine3.height = 1;
    diviLine3.backgroundColor = [UIColor lightGrayColor];
    [baseSv addSubview:diviLine3];
    
    //--------------------选择支付宝
    UIImageView *iv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unselect.png"]];
    iv1.width = 16;
    iv1.height = 16;
    iv1.x = 10;
    iv1.centerY = diviLine3.y + 22;
    self.iv1 = iv1;
    [baseSv addSubview:iv1];
    
    UILabel *Label3 = [[UILabel alloc]init];
    Label3.font = MYFONT;
    Label3.text = @"支付宝付款";
    Label3.size = [XyqsTools getSizeWithText:Label2.text andFont:Label2.font];
    Label3.x = iv1.maxX + 10;
    Label3.centerY = diviLine3.y + 22;
    [baseSv addSubview:Label3];
    
    //支付宝支付按钮
    UIButton *alipayBtn = [[UIButton alloc]init];
    alipayBtn.tag = 2;
    alipayBtn.width = WIDTH;
    alipayBtn.height = 44;
    alipayBtn.x = 0;
    alipayBtn.y = diviLine3.y;
    [alipayBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseSv addSubview:alipayBtn];
    
    
    //分割线5
    UIView *diviLine4 = [[UIView alloc]init];
    diviLine4.x = 0;
    diviLine4.y = diviLine3.y + 44;
    diviLine4.width = WIDTH;
    diviLine4.height = 1;
    diviLine4.backgroundColor = [UIColor lightGrayColor];
    [baseSv addSubview:diviLine4];
    
    //----------------------选择现场支付
    UIImageView *iv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unselect.png"]];
    self.iv2 = iv2;
    iv2.size = iv1.size;
    iv2.x = 10;
    iv2.centerY = diviLine4.y + 22;
    [baseSv addSubview:iv2];
    
    UILabel *Label4 = [[UILabel alloc]init];
    Label4.font = MYFONT;
    Label4.text = @"去医院支付";
    Label4.size = [XyqsTools getSizeWithText:Label2.text andFont:Label2.font];
    Label4.x = Label3.x;
    Label4.centerY = diviLine4.y + 22;
    [baseSv addSubview:Label4];
    
    //现场支付按钮
    UIButton *payToHosBtn = [[UIButton alloc]init];
    payToHosBtn.tag = 3;
    payToHosBtn.width = WIDTH;
    payToHosBtn.height = 44;
    payToHosBtn.x = 0;
    payToHosBtn.y = diviLine4.y;
    [payToHosBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseSv addSubview:payToHosBtn];
    
    //分割线6
    UIView *diviLine5 = [[UIView alloc]init];
    diviLine5.x = 0;
    diviLine5.y = diviLine4.y + 44;
    diviLine5.width = WIDTH;
    diviLine5.height = 1;
    diviLine5.backgroundColor = [UIColor lightGrayColor];
    [baseSv addSubview:diviLine5];
    
    //确认按钮
    UIButton *confirmBtn = [[UIButton alloc]init];
    confirmBtn.tag = 4;
    confirmBtn.width = 150;
    confirmBtn.height = 30;
    confirmBtn.y = diviLine5.y + 20;
    confirmBtn.centerX = self.view.centerX;
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
    confirmBtn.layer.cornerRadius = 8;
    [confirmBtn setTitle:@"确  认  挂  号" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseSv addSubview:confirmBtn];
    
    baseSv.contentSize = CGSizeMake(WIDTH, confirmBtn.maxY + 200);
}

/**
 *  信心确认事件
 */
-(void)confirmAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
        {
            //添加就诊人
            FrequentlyPersonsVC *vc = [[FrequentlyPersonsVC alloc]init];
            vc.fromWhere = @"A";
            vc.delegate = self;
            vc.user = self.user;
            vc.title = @"选择就诊人";
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 2:
        {
            //支付方式的更改图片事件
            self.iv1.image = [UIImage imageNamed:@"select.png"];
            self.iv2.image = [UIImage imageNamed:@"unselect.png"];
            self.radioBtn = 2;
        }
            break;
        case 3:
        {
            //支付方式的更改图片事件
            self.iv2.image = [UIImage imageNamed:@"select.png"];
            self.iv1.image = [UIImage imageNamed:@"unselect.png"];
            self.radioBtn = 1;
        }
            break;
        case 4:
        {
            if (self.sickName.length == 0)
            {
                [MBProgressHUD showError:@"亲~您还没有选择就诊人"];
                return;
            }
            
            if (self.radioBtn == 0)
            {
                [MBProgressHUD showError:@"亲~您还没有选择支付方式"];
                return;
            }
            else if(self.radioBtn == 2)
            {
                [self.params setObject:@(self.radioBtn)forKey:@"payWay"];           //支付方式
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"支付提醒" message:@"社保卡的用户请使用去医院支付选项,后续的就诊费用方能使用社保卡支付!" delegate:self cancelButtonTitle:@"继续挂号" otherButtonTitles:@"返回", nil];
                av.tag = 1;
                [av show];
            }
            
            [self.params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];   //登录token
            [self.params setObject:@(self.hospital.hospitalID) forKey:@"hpId"];
            [self.params setObject:@(self.doctor.doctorID) forKey:@"doctId"];
            [self.params setObject:@(self.depts.roomID) forKey:@"deptId"];
            
            //如果选择的是去医院支付
            if (self.radioBtn == 1)
            {
                [self.params setObject:@(self.radioBtn)forKey:@"payWay"];           //支付方式
                //获取订单预约号
                [HttpTool post:@"http://14.29.84.4:6060/0.1/order/create" params:self.params success:^(id responseObj) {
                    self.timeOutView.hidden = YES;
                    if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
                    {
                        [MBProgressHUD showSuccess:@"预约成功"];
                        NSDictionary *dic = [responseObj objectForKey:@"data"];
                        if (dic)
                        {
                            AlipayConfirmVC *vc = [[AlipayConfirmVC alloc]init];
                            vc.orderNum = [dic objectForKey:@"orderId"];
                            vc.leftTime = [[dic objectForKey:@"leftTime"] longValue];
                            vc.doctor = self.doctor;
                            if (self.member)
                            {
                                vc.member = self.member;        //就诊人
                            }
                            else
                            {
                                comMember *member = [[comMember alloc]init];
                                if (self.user.name != (NSString *)[NSNull null])
                                {
                                    member.name = self.user.name;
                                }
                                
                                member.comID = @"0";        //就诊人ID，0代表自己
                                
                                if (self.user.mobile != (NSString *)[NSNull null])
                                {
                                    member.mobile = self.user.mobile;
                                }
                                
                                if (self.user.idCard != (NSString *)[NSNull null])
                                {
                                    member.idCard = self.user.idCard;
                                }
                                
                                if (self.user.sscard != (NSString *)[NSNull null])
                                {
                                    member.sscard = self.user.sscard;
                                }
                                vc.member = member;
                            }
                            
                            vc.schedules = self.schedules;
                            vc.time = self.time;
                            vc.radioBtn = self.radioBtn;
                            [self.navigationController pushViewController:vc animated:NO];
                        }
                        else
                        {
                            return ;
                        }

                    }
                    else
                    {
                        [MBProgressHUD showError:@"预约失败"];
                    }
                } failure:^(NSError *error) {
                    if (error)
                    {
                        self.timeOutView.hidden = NO;
                    }
                }];
            }
        }
            break;
    }
}

/**
 *  支付宝支付弹出窗口
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [HttpTool post:@"http://14.29.84.4:6060/0.1/order/create" params:self.params success:^(id responseObj) {
                    self.timeOutView.hidden = YES;
                    if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
                    {
                        [MBProgressHUD showSuccess:@"预约成功"];
                        
                        NSDictionary *dic = [responseObj objectForKey:@"data"];
                        if (dic)
                        {
                            AlipayConfirmVC *vc = [[AlipayConfirmVC alloc]init];
                            vc.orderNum = [dic objectForKey:@"orderId"];
                            vc.leftTime = [[dic objectForKey:@"leftTime"] longValue];
                            vc.oid = [[dic objectForKey:@"oid"] longValue];
                            vc.doctor = self.doctor;
                            if (self.member)
                            {
                                vc.member = self.member;        //就诊人
                            }
                            else
                            {
                                comMember *member = [[comMember alloc]init];
                                if (self.user.name != (NSString *)[NSNull null])
                                {
                                    member.name = self.user.name;
                                }
                                
                                member.comID = @"0";        //就诊人ID，0代表自己
                                
                                if (self.user.mobile != (NSString *)[NSNull null])
                                {
                                    member.mobile = self.user.mobile;
                                }
                                
                                if (self.user.idCard != (NSString *)[NSNull null])
                                {
                                    member.idCard = self.user.idCard;
                                }
                                
                                if (self.user.sscard != (NSString *)[NSNull null])
                                {
                                    member.sscard = self.user.sscard;
                                }
                                vc.member = member;
                            }
                            
                            vc.schedules = self.schedules;
                            vc.time = self.time;
                            vc.radioBtn = self.radioBtn;
                            [self.navigationController pushViewController:vc animated:NO];
                        }
                        else
                        {
                            return ;
                        }
                        
                    }
                    else
                    {
                       [MBProgressHUD showError:@"预约失败"];
                    }
                } failure:^(NSError *error) {
                    if (error)
                    {
                        self.timeOutView.hidden = NO;
                    }
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
    else
    {
        switch (buttonIndex)
        {
            case 0:
            {
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
}


@end
