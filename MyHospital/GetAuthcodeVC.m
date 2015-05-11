//
//  GetAuthcodeVC.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "GetAuthcodeVC.h"
#import "XyqsApi.h"
#import "PersonalVC.h"
#import "LoginViewController.h"
#import "ProtocolVC.h"

@interface GetAuthcodeVC ()

@property(nonatomic,strong)UITextField *AuthcodeTF;
@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic)int seconds;
@property(nonatomic,strong)UIButton *getAuthcodeBtn;

@property(nonatomic)BOOL isSelProtocol;     //是否选择同意协议

@end

@implementation GetAuthcodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户注册";
    [self initUI];
    self.isSelProtocol = YES;
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
    
    //验证码
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"验证码:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.x = 10;
    telLabel.centerY = 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:telLabel];
    
    //获取验证码按钮
    UIButton *getAuthcodeBtn = [[UIButton alloc]init];
    getAuthcodeBtn.tag = 1;
    getAuthcodeBtn.y = 0;
    getAuthcodeBtn.width = 80;
    getAuthcodeBtn.height = 32;
    getAuthcodeBtn.centerY = 25;
    getAuthcodeBtn.x = WIDTH - getAuthcodeBtn.width-10;
    getAuthcodeBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    getAuthcodeBtn.layer.cornerRadius = 5;
    getAuthcodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getAuthcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getAuthcodeBtn addTarget:self action:@selector(getAuthcode:) forControlEvents:UIControlEventTouchUpInside];
    self.getAuthcodeBtn = getAuthcodeBtn;
    [self.view addSubview:getAuthcodeBtn];
    
    //验证码输入框
    if (!self.AuthcodeTF)
    {
        self.AuthcodeTF = [[UITextField alloc]init];
    }
    self.AuthcodeTF.x = telLabel.maxX +5;
    self.AuthcodeTF.y = telLabel.y;
    self.AuthcodeTF.font = telLabel.font;
    self.AuthcodeTF.width = WIDTH - getAuthcodeBtn.width - 10 - self.AuthcodeTF.x -5;
    self.AuthcodeTF.height = telLabel.height;
    self.AuthcodeTF.placeholder = @"请输入验证码";
    self.AuthcodeTF.borderStyle = UITextBorderStyleNone;
    [self.AuthcodeTF becomeFirstResponder];
    self.AuthcodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.AuthcodeTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = 50;
    view2.width = WIDTH;
    view2.height = 1;
    view2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view2];
  
    //注册按钮
    UIButton *registerBtn = [[UIButton alloc]init];
    registerBtn.width = 260;
    registerBtn.height = 40;
    registerBtn.y = view2.maxY + 30;
    registerBtn.centerX = self.view.centerX;
    registerBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    registerBtn.layer.cornerRadius = 10;
    [registerBtn setTitle:@"注        册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //掌上医疗条款按钮
    UIButton *proSelBtn = [[UIButton alloc]init];
    proSelBtn.tag = 1;
    proSelBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    proSelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    proSelBtn.layer.borderWidth = 1;
    proSelBtn.layer.masksToBounds = YES;
    proSelBtn.width = 13;
    proSelBtn.height = 13;
    proSelBtn.y = registerBtn.maxY + 20;
    proSelBtn.x = registerBtn.x + 20;
    [proSelBtn addTarget:self action:@selector(proSelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proSelBtn];
    
    //条款明细按钮
    UIButton *protocolBtn = [[UIButton alloc]init];
    protocolBtn.tag = 2;
    [protocolBtn setTitle:@"我同意掌上医疗《用户协议和隐私条款》" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    protocolBtn.size = [XyqsTools getSizeWithText:protocolBtn.titleLabel.text andFont:protocolBtn.titleLabel.font];
    protocolBtn.y = registerBtn.maxY + 20;
    protocolBtn.x = proSelBtn.maxX + 10;
    [protocolBtn addTarget:self action:@selector(proSelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBtn];
    
    
}

/**
 *  掌上医疗的一些条款协议，按钮按下代表同意
 */
-(void)proSelBtnAction:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        //是否同意条款协议的按钮
        if (self.isSelProtocol)
        {
            self.isSelProtocol = NO;
            sender.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }
        else
        {
            self.isSelProtocol = YES;
            sender.layer.backgroundColor = LCWBottomColor.CGColor;
        }
    }
    else
    {
        //跳转协议和隐私的界面
        ProtocolVC *vc = [[ProtocolVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//获取验证码
-(void)getAuthcode:(UIButton *)sender
{
    self.seconds = 60;
    sender.tag = 2;
    UILabel *label = [[UILabel alloc]initWithFrame:sender.frame];
    label.text = [NSString stringWithFormat:@"%d秒",self.seconds];
    label.layer.cornerRadius = self.getAuthcodeBtn.layer.cornerRadius;
    label.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    label.textColor = [UIColor whiteColor];
    label.font = sender.titleLabel.font;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    sender.enabled = NO;
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeShow:) userInfo:label repeats:YES];

    
    //请求服务器给验证码
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.person.mobile forKey:@"mobile"];
    [params setObject:@(1) forKey:@"type"];     //注册的类型
    
    [self performSelector:@selector(sendAuth) withObject:nil afterDelay:1.5];
    
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


-(void)registerAction
{
    if (self.AuthcodeTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    if (self.getAuthcodeBtn.tag == 1)
    {
        [MBProgressHUD showError:@"请先获取验证码"];
        return;
    }
    
    if (!self.isSelProtocol)
    {
        [MBProgressHUD showError:@"亲~你未同意条款哦"];
        return;
    }

    [XyqsApi requestTelLoginWithMobile:self.person.mobile andPassword:self.person.password andCode:self.AuthcodeTF.text andCallBack:^(id obj) {
        [MBProgressHUD showSuccess:@"恭喜您已注册成功"];
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[LoginViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
       
    }];
}



@end
