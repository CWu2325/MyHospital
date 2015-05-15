//
//  ChangePasswordVC.m
//  MyHospital
//
//  Created by XYQS on 15/5/13.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "XyqsApi.h"

@interface ChangePasswordVC ()

@property(nonatomic,strong)UITextField *oldPasTF;
@property(nonatomic,strong)UITextField *changePasTF;
@property(nonatomic,strong)UITextField *changeAgnTF;
@end

@implementation ChangePasswordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    
    self.view.backgroundColor = LCWBackgroundColor;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self initUI];
}

-(void)initUI
{
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    [self.view addSubview:downView];
    downView.backgroundColor = [UIColor whiteColor];
    
    //账号栏
    UILabel *oldLabel = [[UILabel alloc]init];
    oldLabel.text = @"旧密码:";
    oldLabel.font = [UIFont systemFontOfSize:15];
    oldLabel.x = 10;
    oldLabel.size = [oldLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oldLabel.font} context:nil].size;
    oldLabel.centerY = 25;
    oldLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:oldLabel];
    
    UITextField *oldPasTF = [[UITextField alloc]init];
    self.oldPasTF = oldPasTF;
    self.oldPasTF.x = oldLabel.maxX +5;
    self.oldPasTF.y = oldLabel.y;
    self.oldPasTF.font = oldLabel.font;
    self.oldPasTF.width = WIDTH - self.oldPasTF.x - 5;
    self.oldPasTF.height = oldLabel.height;
    self.oldPasTF.placeholder = @"请输入您的旧密码";
    self.oldPasTF.borderStyle = UITextBorderStyleNone;
    self.oldPasTF.secureTextEntry = YES;
    [self.oldPasTF becomeFirstResponder];
    self.oldPasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [downView addSubview:self.oldPasTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = 50;
    view2.width = WIDTH;
    view2.height = 1;
    view2.backgroundColor = LCWBackgroundColor;
    [downView addSubview:view2];
    
    //密码栏
    UILabel *newPasLabel = [[UILabel alloc]init];
    newPasLabel.text = @"新密码:";
    newPasLabel.font = oldLabel.font;
    newPasLabel.size = [newPasLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:newPasLabel.font} context:nil].size;
    newPasLabel.x = oldLabel.x;
    newPasLabel.centerY = view2.maxY + 25;
    newPasLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:newPasLabel];
    
    self.changePasTF = [[UITextField alloc]init];
    self.changePasTF.x = newPasLabel.maxX +5;
    self.changePasTF.y = newPasLabel.y;
    self.changePasTF.width = self.oldPasTF.width;
    self.changePasTF.height = newPasLabel.height;
    self.changePasTF.font = newPasLabel.font;
    self.changePasTF.placeholder = @"请输入您的新密码(6 - 16位)";
    self.changePasTF.borderStyle = UITextBorderStyleNone;
    self.changePasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.changePasTF setSecureTextEntry:YES];
    [downView addSubview:self.changePasTF];
    
    //分割线3
    UIView *view3 = [[UIView alloc]init];
    view3.x = 0;
    view3.y = view2.maxY + 50;
    view3.width = WIDTH;
    view3.height = 1;
    view3.backgroundColor = LCWBackgroundColor;
    [downView addSubview:view3];
    
    //再一次输入密码栏
    UILabel *pasAgainLabel = [[UILabel alloc]init];
    pasAgainLabel.text = @"确   认:";
    pasAgainLabel.font = oldLabel.font;
    pasAgainLabel.size = oldLabel.size;
    pasAgainLabel.x = oldLabel.x;
    pasAgainLabel.centerY = view3.maxY + 25;
    pasAgainLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:pasAgainLabel];
    
    self.changeAgnTF = [[UITextField alloc]init];
    self.changeAgnTF.x = pasAgainLabel.maxX +5;
    self.changeAgnTF.y = pasAgainLabel.y;
    self.changeAgnTF.width = self.oldPasTF.width;
    self.changeAgnTF.height = pasAgainLabel.height;
    self.changeAgnTF.font = pasAgainLabel.font;
    self.changeAgnTF.placeholder = @"请再次输入您的新密码(6 - 16位)";
    self.changeAgnTF.borderStyle = UITextBorderStyleNone;
    self.changeAgnTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.changeAgnTF setSecureTextEntry:YES];
    [downView addSubview:self.changeAgnTF];
    
    //下一步按钮
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.width = 260;
    nextBtn.height = 40;
    nextBtn.y = downView.maxY + 30;
    nextBtn.centerX = self.view.centerX;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
    nextBtn.layer.cornerRadius = 10;
    [nextBtn setTitle:@"提        交" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

-(void)changePassword
{
    if (self.oldPasTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入您的旧密码"];
        return;
    }
    

    
    if (self.changePasTF.text.length == 0 || self.changeAgnTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入新密码"];
        return;
    }
    
    if (self.changePasTF.text.length <6 ||self.changePasTF.text.length > 16)
    {
        [MBProgressHUD showError:@"亲~设置密码请在6 - 16位之间"];
        return;
    }
    
    
    if (![self.changePasTF.text isEqualToString:self.changeAgnTF.text])
    {
        [MBProgressHUD showError:@"两次密码不一样，请从新输入"];
        return;
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]{6,16}$"] evaluateWithObject:self.changePasTF.text])
    {
        [MBProgressHUD showError:@"亲~密码必须是字母或数字"];
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [params setObject:self.oldPasTF.text forKey:@"oldPass"];
    [params setObject:self.changePasTF.text forKey:@"newPass"];
    [XyqsApi changePasswordWithparams:params andCallBack:^(id obj) {
        [MBProgressHUD showSuccess:obj];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}



@end
