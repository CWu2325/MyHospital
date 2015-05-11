//
//  ResetPasVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "ResetPasVC.h"
#import "ResetPasConfirmVC.h"
#import "XyqsApi.h"

@interface ResetPasVC ()

@property(nonatomic,strong)UITextField *useTelTF;   //用户手机号码
@property(nonatomic,strong)UITextField *rsgisterTF;   //验证码

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)int seconds;

@property(nonatomic,strong)UIButton *getAuthcodeBtn;

@end

@implementation ResetPasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重置密码";
    
    [self initUI];

}

-(void)initUI
{
//    //分割线1
//    UIView *view1 = [[UIView alloc]init];
//    view1.x = 0;
//    view1.y = 84;
//    view1.width = WIDTH;
//    view1.height = 1.5;
//    view1.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:view1];
    
    //账号栏
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"手机号:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.x = 10;
    telLabel.centerY = 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:telLabel];
    
    self.useTelTF = [[UITextField alloc]init];
    self.useTelTF.x = telLabel.maxX +5;
    self.useTelTF.y = telLabel.y;
    self.useTelTF.width = WIDTH - self.useTelTF.x - 5;
    self.useTelTF.height = telLabel.height;
    self.useTelTF.font = telLabel.font;
    self.useTelTF.placeholder = @"请输入手机号码";
    self.useTelTF.borderStyle = UITextBorderStyleNone;
    self.useTelTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.useTelTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = 50;
    view2.width = WIDTH;
    view2.height = 1;
    view2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view2];
    
    //密码栏
    UILabel *pasLabel = [[UILabel alloc]init];
    pasLabel.text = @"验证码:";
    pasLabel.font = telLabel.font;
    pasLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:pasLabel.font} context:nil].size;
    pasLabel.x = 10;
    pasLabel.centerY = view2.y+25;
    pasLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pasLabel];
    
    
    //获取验证码按钮
    UIButton *getAuthcodeBtn = [[UIButton alloc]init];
    getAuthcodeBtn.y = 0;
    getAuthcodeBtn.width = 80;
    getAuthcodeBtn.height = 32;
    getAuthcodeBtn.centerY = view2.maxY + 25;
    getAuthcodeBtn.x = WIDTH - getAuthcodeBtn.width-10;
    getAuthcodeBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    getAuthcodeBtn.layer.cornerRadius = 10;
    getAuthcodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getAuthcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getAuthcodeBtn.tag = 1;
    self.getAuthcodeBtn = getAuthcodeBtn;
    [getAuthcodeBtn addTarget:self action:@selector(getAuthcode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getAuthcodeBtn];
    
    self.rsgisterTF = [[UITextField alloc]init];
    self.rsgisterTF.x = pasLabel.maxX +5;
    self.rsgisterTF.y = pasLabel.y;
    self.rsgisterTF.width = WIDTH - getAuthcodeBtn.width - 10 - self.rsgisterTF.x -5;
    self.rsgisterTF.height = pasLabel.height;
    self.rsgisterTF.font = pasLabel.font;
    self.rsgisterTF.placeholder = @"请输入验证码";
    self.rsgisterTF.borderStyle = UITextBorderStyleNone;
    self.rsgisterTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.rsgisterTF setSecureTextEntry:YES];
    [self.view addSubview:self.rsgisterTF];
    
    //分割线3
    UIView *view3 = [[UIView alloc]init];
    view3.x = 0;
    view3.y = view2.y + 50;
    view3.width = WIDTH;
    view3.height = 1;
    view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view3];
    
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.width = 260;
    nextBtn.height = 40;
    nextBtn.y = view3.maxY + 30;
    nextBtn.centerX = self.view.centerX;
    nextBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    nextBtn.layer.cornerRadius = 10;
    [nextBtn setTitle:@"下    一    步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

//获取验证码
-(void)getAuthcode:(UIButton *)sender
{
    if (self.useTelTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入您的手机号码"];
        return;
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1][3-8]+\\d{9}"] evaluateWithObject:self.useTelTF.text])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [XyqsApi verifyTelWithMobile:self.useTelTF.text andCallBack:^(id obj) {
        if ([obj objectForKey:@"message"] != (NSString *)[NSNull null] && [[obj objectForKey:@"message"] isEqualToString:@"该号码已被注册"])
        {
            sender.tag = 2;
            self.seconds = 60;
            UILabel *label = [[UILabel alloc]initWithFrame:sender.frame];
            label.text = [NSString stringWithFormat:@"%d秒",self.seconds];
            label.textColor = [UIColor whiteColor];
            label.font = sender.titleLabel.font;
            label.layer.cornerRadius = self.getAuthcodeBtn.layer.cornerRadius;
            label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
            sender.enabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeShow:) userInfo:label repeats:YES];
            
#pragma mark - 请求服务器给验证码
            [self performSelector:@selector(sendAuth) withObject:nil afterDelay:1.5];
        }
        else
        {
            [MBProgressHUD showError:@"用户不存在"];
            return ;
        }
    }];

}

-(void)sendAuth
{
    [MBProgressHUD showSuccess:@"验证码已发送"];
}

//倒计时
-(void)changeTimeShow:(NSTimer *)timer
{
    self.seconds--;
    UILabel *label = timer.userInfo;
    if (self.seconds <= 0)
    {
        [timer invalidate];
        self.getAuthcodeBtn.enabled = YES;
        [label removeFromSuperview];
        self.getAuthcodeBtn.tag = 1;
        return;
    }
    label.text = [NSString stringWithFormat:@"%d秒",self.seconds];
}

-(void)next
{
    if (self.useTelTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入您的手机号码"];
        return;
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1][3-8]+\\d{9}"] evaluateWithObject:self.useTelTF.text])
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (self.getAuthcodeBtn.tag == 1)
    {
        [MBProgressHUD showError:@"请先获取验证码"];
        return;
    }
    
    if (self.rsgisterTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if (self.rsgisterTF.text.length != 6)
    {
        [MBProgressHUD showError:@"请输入正确长度的6位验证码"];
        return;
    }
    

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.useTelTF.text forKey:@"mobile"];
    [params setObject:self.rsgisterTF.text forKey:@"code"];
    [params setObject:@"1" forKey:@"step"];
    
    [XyqsApi verifyTelWithMobile:self.useTelTF.text andCallBack:^(id obj) {
        if ([obj objectForKey:@"message"] != (NSString *)[NSNull null] && [[obj objectForKey:@"message"] isEqualToString:@"该号码已被注册"]) {
            [XyqsApi resetPwdFirstWithparams:params andCallBack:^(id obj) {
          
                NSDictionary *dataDic = [obj objectForKey:@"data"];
                NSString *resetToken = [dataDic objectForKey:@"token"];
                //跳转
                ResetPasConfirmVC *vc = [[ResetPasConfirmVC alloc]init];
                vc.resetToken = resetToken;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        else
        {
            [MBProgressHUD showError:@"用户不存在"];
            return ;
        }
    }];

}



@end
