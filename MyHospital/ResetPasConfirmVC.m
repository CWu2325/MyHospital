//
//  ResetPasConfirmVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/10.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "ResetPasConfirmVC.h"
#import "HttpTool.h"

@interface ResetPasConfirmVC ()

@property(nonatomic,strong)UITextField *usePasTF;   //用户密码
@property(nonatomic,strong)UITextField *usePasConfTF;   //再次输入密码


@end

@implementation ResetPasConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.view.backgroundColor = LCWBackgroundColor;
    
    [self initUI];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usePasTF resignFirstResponder];
    [self.usePasConfTF resignFirstResponder];
}


-(void)initUI
{
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    [self.view addSubview:downView];
    downView.backgroundColor = [UIColor whiteColor];
    
    //账号栏
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"密  码:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.x = 10;
    telLabel.centerY = 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:telLabel];
    
    self.usePasTF = [[UITextField alloc]init];
    self.usePasTF.x = telLabel.maxX +5;
    self.usePasTF.y = telLabel.y;
    self.usePasTF.width = WIDTH - self.usePasTF.x - 5;
    self.usePasTF.height = telLabel.height;
    self.usePasTF.font = telLabel.font;
    self.usePasTF.placeholder = @"请输入您的新密码(6 - 16 位)";
    self.usePasTF.secureTextEntry = YES;
    self.usePasTF.borderStyle = UITextBorderStyleNone;
    self.usePasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.usePasTF becomeFirstResponder];
    [downView addSubview:self.usePasTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = 50;
    view2.width = WIDTH;
    view2.height = 1;
    view2.backgroundColor = [UIColor lightGrayColor];
    [downView addSubview:view2];
    
    //密码栏
    UILabel *pasLabel = [[UILabel alloc]init];
    pasLabel.text = @"确  认:";
    pasLabel.font = telLabel.font;
    pasLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:pasLabel.font} context:nil].size;
    pasLabel.x = 10;
    pasLabel.centerY = view2.y+25;
    pasLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:pasLabel];
    
    self.usePasConfTF = [[UITextField alloc]init];
    self.usePasConfTF.x = pasLabel.maxX +5;
    self.usePasConfTF.y = pasLabel.y;
    self.usePasConfTF.width = WIDTH - self.usePasConfTF.x - 5;
    self.usePasConfTF.height = pasLabel.height;
    self.usePasConfTF.font = pasLabel.font;
    self.usePasConfTF.placeholder = @"请再次输入您的密码(6 - 16 位)";
    self.usePasConfTF.borderStyle = UITextBorderStyleNone;
    self.usePasConfTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.usePasConfTF setSecureTextEntry:YES];
    [downView addSubview:self.usePasConfTF];
    
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
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

-(void)next
{
    if (self.usePasTF.text.length == 0 || self.usePasConfTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    if (self.usePasTF.text.length < 6 ||self.usePasTF.text.length > 16)
    {
        [MBProgressHUD showError:@"亲~设置密码请在6 - 16位之间"];
        return;
    }
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]{6,16}$"] evaluateWithObject:self.usePasTF.text])
    {
        [MBProgressHUD showError:@"亲~密码必须是字母或数字"];
        return ;
    }
    
    if (![self.usePasConfTF.text isEqualToString:self.usePasTF.text])
    {
        [MBProgressHUD showError:@"两次输入密码不一样"];
        return;
    }
    
    //确认修改
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.resetToken forKey:@"resetToken"];
    [params setObject:self.usePasTF.text forKey:@"password"];
    [params setObject:@"2" forKey:@"step"];
    
    //重置密码
    [HttpTool post:@"http://14.29.84.4:6060/0.1/user/reset_pwd" params:params success:^(id responseObj) {
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            [MBProgressHUD showSuccess:[responseObj objectForKey:@"message"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        if (error)
        {
            [MBProgressHUD showError:@"请检查您的网络连接"];
        }
    }];

  
}


@end
