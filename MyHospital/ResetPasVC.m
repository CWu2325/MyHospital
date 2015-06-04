//
//  ResetPasVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "ResetPasVC.h"
#import "ResetPasConfirmVC.h"
#import "HttpTool.h"
#import "AppDelegate.h"

@interface ResetPasVC ()

@property(nonatomic,strong)UITextField *useTelTF;   //用户手机号码
@property(nonatomic,strong)UITextField *rsgisterTF;   //验证码

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic)int seconds;

@property(nonatomic,strong)UIButton *getAuthcodeBtn;
@property(nonatomic,strong)AppDelegate *appDlg;

@end

@implementation ResetPasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDlg = [UIApplication sharedApplication].delegate;
    
    self.title = @"重置密码";
    self.view.backgroundColor = LCWBackgroundColor;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self initUI];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.useTelTF resignFirstResponder];
    [self.rsgisterTF resignFirstResponder];
}

-(void)initUI
{
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    [self.view addSubview:downView];
    downView.backgroundColor = [UIColor whiteColor];
    
    //账号栏
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"手机号:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.x = 10;
    telLabel.centerY = 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:telLabel];
    
    self.useTelTF = [[UITextField alloc]init];
    self.useTelTF.x = telLabel.maxX +5;
    self.useTelTF.y = telLabel.y;
    self.useTelTF.width = WIDTH - self.useTelTF.x - 5;
    self.useTelTF.height = telLabel.height;
    self.useTelTF.font = telLabel.font;
    self.useTelTF.placeholder = @"请输入手机号码";
    self.useTelTF.borderStyle = UITextBorderStyleNone;
    [self.useTelTF becomeFirstResponder];
    self.useTelTF.keyboardType = UIKeyboardTypeNumberPad;
    self.useTelTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [downView addSubview:self.useTelTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = 50;
    view2.width = WIDTH;
    view2.height = 1;
    view2.backgroundColor = LCWBackgroundColor;
    [downView addSubview:view2];
    
    //密码栏
    UILabel *pasLabel = [[UILabel alloc]init];
    pasLabel.text = @"验证码:";
    pasLabel.font = telLabel.font;
    pasLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:pasLabel.font} context:nil].size;
    pasLabel.x = 10;
    pasLabel.centerY = view2.y+25;
    pasLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:pasLabel];
    
    
    //获取验证码按钮
    UIButton *getAuthcodeBtn = [[UIButton alloc]init];
    getAuthcodeBtn.y = 0;
    getAuthcodeBtn.width = 80;
    getAuthcodeBtn.height = 32;
    getAuthcodeBtn.centerY = view2.maxY + 25;
    getAuthcodeBtn.x = WIDTH - getAuthcodeBtn.width-10;
    [getAuthcodeBtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [getAuthcodeBtn setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
    getAuthcodeBtn.layer.cornerRadius = 5;
    getAuthcodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getAuthcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getAuthcodeBtn.tag = 1;
    self.getAuthcodeBtn = getAuthcodeBtn;
    [getAuthcodeBtn addTarget:self action:@selector(getAuthcode:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:getAuthcodeBtn];
    
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
    [downView addSubview:self.rsgisterTF];
    
  
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.width = 260;
    nextBtn.height = 40;
    nextBtn.y = downView.maxY + 30;
    nextBtn.centerX = self.view.centerX;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
    nextBtn.layer.cornerRadius = 5;
    [nextBtn setTitle:@"下    一    步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

//获取验证码
-(void)getAuthcode:(UIButton *)sender
{
    if (self.appDlg.isReachable)
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
        
        //验证电话号码是否可用
        NSDictionary *params0 = @{@"mobile":self.useTelTF.text};
        [HttpTool post:@"http://14.29.84.4:6060/0.1/user/verify_mobile" params:params0 success:^(id responseObj) {
            if ([responseObj objectForKey:@"message"] != (NSString *)[NSNull null] && [[responseObj objectForKey:@"message"] isEqualToString:@"该号码已被注册"])
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
                
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:self.useTelTF.text forKey:@"mobile"];
                [params setObject:@(2) forKey:@"type"];
                [params setObject:@"true" forKey:@"test"];
                
                //发送验证码
                [HttpTool get:@"http://14.29.84.4:6060/0.1/user/send_verifycode" params:params success:^(id responseObj2) {
                    if ([[responseObj2 objectForKey:@"returnCode"] isEqual:@(1001)])
                    {
                        [MBProgressHUD showSuccess:[responseObj2 objectForKey:@"message"]];
                    }
                    else
                    {
                        [MBProgressHUD showError:[responseObj2 objectForKey:@"message"]];
                    }
                } failure:^(NSError *error) {
                    if (error)
                    {
                        [MBProgressHUD showError:@"请检查您的网络连接"];
                    }
                }];
            }
            else
            {
                [MBProgressHUD showError:@"用户不存在"];
                return ;
            }
        } failure:^(NSError *error) {
            if (error)
            {
                [MBProgressHUD showError:@"网络不给力，请重试"];
            }
        }];
    }
    else
    {
        [MBProgressHUD showError:@"无网络连接，请联网后重试"];
    }
    
    
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
        
        [self performSelector:@selector(delayBtnTag) withObject:nil afterDelay:300];
        
        return;
    }
    label.text = [NSString stringWithFormat:@"%d秒",self.seconds];
}

-(void)delayBtnTag
{
    self.getAuthcodeBtn.tag = 1;
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
    if (self.appDlg.isReachable)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.useTelTF.text forKey:@"mobile"];
        [params setObject:self.rsgisterTF.text forKey:@"code"];
        [params setObject:@"1" forKey:@"step"];
        
        
        //验证电话号码是否可用
        NSDictionary *params0 = @{@"mobile":self.useTelTF.text};
        [HttpTool post:@"http://14.29.84.4:6060/0.1/user/verify_mobile" params:params0 success:^(id responseObj) {
            if ([responseObj objectForKey:@"message"] != (NSString *)[NSNull null] && [[responseObj objectForKey:@"message"] isEqualToString:@"该号码已被注册"])
            {
                [HttpTool post:@"http://14.29.84.4:6060/0.1/user/reset_pwd" params:params success:^(id responseObj2) {
                    
                    
                    if ([[responseObj2 objectForKey:@"returnCode"] isEqual:@(1001)])
                    {
                        NSDictionary *dataDic = [responseObj2 objectForKey:@"data"];
                        NSString *resetToken = [dataDic objectForKey:@"token"];
                        //跳转
                        ResetPasConfirmVC *vc = [[ResetPasConfirmVC alloc]init];
                        vc.resetToken = resetToken;
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                    else
                    {
                        [MBProgressHUD showError:[responseObj2 objectForKey:@"message"]];
                    }
                } failure:^(NSError *error2) {
                    if (error2)
                    {
                        [MBProgressHUD showError:@"网络不给力，请重试"];
                    }
                }];
            }
            else
            {
                [MBProgressHUD showError:@"用户不存在"];
                return ;
            }
        } failure:^(NSError *error) {
            if (error)
            {
                [MBProgressHUD showError:@"网络不给力，请重试"];
            }
        }];
    }
    else
    {
        [MBProgressHUD showError:@"无网络连接，请联网后重试"];
    }
    

}



@end
