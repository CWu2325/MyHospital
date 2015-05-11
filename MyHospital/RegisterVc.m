//
//  RegisterVc.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "RegisterVc.h"
#import "GetAuthcodeVC.h"
#import "Person.h"
#import "XyqsApi.h"

@interface RegisterVc ()

@property(nonatomic,strong)UITextField *useTelTF;
@property(nonatomic,strong)UITextField *usePasTF;
@property(nonatomic,strong)UITextField *useAgainPasTF;

@end

@implementation RegisterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户注册";
    [self initUI];
}

-(void)initUI
{

    //账号栏
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"手机号:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.x = 10;
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.centerY = 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:telLabel];
    
    UITextField *useTelTF = [[UITextField alloc]init];
    self.useTelTF = useTelTF;
    self.useTelTF.x = telLabel.maxX +5;
    self.useTelTF.y = telLabel.y;
    self.useTelTF.font = telLabel.font;
    self.useTelTF.width = WIDTH - self.useTelTF.x - 5;
    self.useTelTF.height = telLabel.height;
    self.useTelTF.placeholder = @"请输入您的手机号码";
    self.useTelTF.borderStyle = UITextBorderStyleNone;
    [self.useTelTF becomeFirstResponder];
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
    pasLabel.text = @"密    码:";
    pasLabel.font = telLabel.font;
    pasLabel.size = [pasLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:pasLabel.font} context:nil].size;
    pasLabel.x = telLabel.x;
    pasLabel.centerY = view2.maxY + 25;
    pasLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pasLabel];
    
    self.usePasTF = [[UITextField alloc]init];
    self.usePasTF.x = pasLabel.maxX +5;
    self.usePasTF.y = pasLabel.y;
    self.usePasTF.width = WIDTH - self.useTelTF.x - 5;
    self.usePasTF.height = pasLabel.height;
    self.usePasTF.font = pasLabel.font;
    self.usePasTF.placeholder = @"请输入您的密码(6 - 16位)";
    self.usePasTF.borderStyle = UITextBorderStyleNone;
    self.usePasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.usePasTF setSecureTextEntry:YES];
    [self.view addSubview:self.usePasTF];
    
    //分割线3
    UIView *view3 = [[UIView alloc]init];
    view3.x = 0;
    view3.y = view2.maxY + 50;
    view3.width = WIDTH;
    view3.height = 1;
    view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view3];
    
    //再一次输入密码栏
    UILabel *pasAgainLabel = [[UILabel alloc]init];
    pasAgainLabel.text = @"确    认:";
    pasAgainLabel.font = telLabel.font;
    pasAgainLabel.size = [pasLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:pasAgainLabel.font} context:nil].size;
    pasAgainLabel.x = telLabel.x;
    pasAgainLabel.centerY = view3.maxY + 25;
    pasAgainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pasAgainLabel];
    
    self.useAgainPasTF = [[UITextField alloc]init];
    self.useAgainPasTF.x = pasAgainLabel.maxX +5;
    self.useAgainPasTF.y = pasAgainLabel.y;
    self.useAgainPasTF.width = WIDTH - self.useTelTF.x - 5;
    self.useAgainPasTF.height = pasAgainLabel.height;
    self.useAgainPasTF.font = pasAgainLabel.font;
    self.useAgainPasTF.placeholder = @"请再次输入您的密码(6 - 16位)";
    self.useAgainPasTF.borderStyle = UITextBorderStyleNone;
    self.useAgainPasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.useAgainPasTF setSecureTextEntry:YES];
    [self.view addSubview:self.useAgainPasTF];
    
    //分割线3
    UIView *view4 = [[UIView alloc]init];
    view4.x = 0;
    view4.y = view3.maxY + 50;
    view4.width = WIDTH;
    view4.height = 1;
    view4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view4];
    
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.width = 260;
    nextBtn.height = 40;
    nextBtn.y = view4.maxY + 30;
    nextBtn.centerX = self.view.centerX;
    nextBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    nextBtn.layer.cornerRadius = 10;
    [nextBtn setTitle:@"下    一    步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

-(void)next
{
    if (self.useTelTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1][3-8]+\\d{9}"] evaluateWithObject:self.useTelTF.text])
    {
        [MBProgressHUD showError:@"亲~您输入的不是手机号码"];
        return ;
    }
    
    if (self.usePasTF.text.length == 0 || self.useAgainPasTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    if (self.usePasTF.text.length <6 ||self.usePasTF.text.length > 16)
    {
        [MBProgressHUD showError:@"亲~设置密码请在6 - 16位之间"];
        return;
    }

   
    if (![self.useAgainPasTF.text isEqualToString:self.usePasTF.text])
    {
        [MBProgressHUD showError:@"两次密码不一样，请从新输入"];
        return;
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]{6,16}$"] evaluateWithObject:self.usePasTF.text])
    {
        [MBProgressHUD showError:@"亲~密码必须是字母或数字"];
        return ;
    }
    
    [XyqsApi verifyTelWithMobile:self.useTelTF.text andCallBack:^(id obj) {
        if ([[obj objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            GetAuthcodeVC *vc = [[GetAuthcodeVC alloc]init];
            Person *person = [[Person alloc]init];
            person.mobile = self.useTelTF.text;
            person.password = self.usePasTF.text;
            vc.person = person;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [MBProgressHUD showError:[obj objectForKey:@"message"]];
            return ;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end