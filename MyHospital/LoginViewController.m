//
//  LoginViewController.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterVc.h"
#import "XyqsApi.h"
#import "ResetPasVC.h"
#import "PersonalVC.h"
#import "TabBarVC.h"


@interface LoginViewController ()

@property(nonatomic,strong)UIImageView *useImageView;
@property(nonatomic,strong)UITextField *useTelTF;
@property(nonatomic,strong)UITextField *usePasTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"掌上医疗登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onClick)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back-icon@2x.png" highImageName:@"back-icon@2x.png" target:self action:@selector(back)];

    [self initUI];
}

-(void)back
{
    if ([self.formWhere isEqualToString:@"perInfo"])
    {
        TabBarVC *vc = [[TabBarVC alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.useTelTF resignFirstResponder];
    [self.usePasTF resignFirstResponder];
}

-(void)initUI
{
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 130)];
    backgroundImageView.image = [UIImage imageNamed:@"background_login.jpg"];
    [self.view addSubview:backgroundImageView];
    
    //登录前默认的头像
    self.useImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];

    [self.view addSubview:self.useImageView];
    self.useImageView.centerX = self.view.centerX;
    self.useImageView.centerY = 65;
    self.useImageView.layer.cornerRadius = self.useImageView.width/2;
    self.useImageView.layer.borderWidth = 1.5;
    self.useImageView.layer.borderColor = [UIColor greenColor].CGColor;
    self.useImageView.layer.masksToBounds = YES;
    //让当前的图像旋转
    [UIView transitionWithView:self.useImageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.useImageView.image = [UIImage imageNamed:@"user_defaultgift"];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.useImageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                self.useImageView.image = [UIImage imageNamed:@"default_avatar"];
            } completion:nil];
        });
    }];
    
    
    
    
    //分割线1
    UIView *view1 = [[UIView alloc]init];
    view1.x = 0;
    view1.y = self.useImageView.maxY + 25;
    view1.width = WIDTH;
    view1.height = 1;
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    
    //账号栏
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"手机号:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.x = 10;
    telLabel.centerY = view1.maxY + 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:telLabel];
    
    UITextField *useTelTF = [[UITextField alloc]init];
    self.useTelTF = useTelTF;
    self.useTelTF.x = telLabel.maxX +5;
    self.useTelTF.y = telLabel.y;
    self.useTelTF.width = WIDTH - self.useTelTF.x - 5;
    self.useTelTF.height = telLabel.height;
    self.useTelTF.placeholder = @"请输入手机号码";
    self.useTelTF.font = telLabel.font;
    self.useTelTF.borderStyle = UITextBorderStyleNone;
    [self.useTelTF becomeFirstResponder];
    self.useTelTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.useTelTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = view1.maxY + 50;
    view2.width = WIDTH;
    view2.height = view1.height;
    view2.backgroundColor = view1.backgroundColor;
    [self.view addSubview:view2];
    
    //密码栏
    UILabel *pasLabel = [[UILabel alloc]init];
    pasLabel.text = @"密    码:";
    pasLabel.font = telLabel.font;
    pasLabel.size = [pasLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    pasLabel.x = telLabel.x;
    pasLabel.centerY = view2.maxY + 25;
    pasLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pasLabel];
    
    UITextField *usePasTF = [[UITextField alloc]init];
    self.usePasTF = usePasTF;
    self.usePasTF.x = pasLabel.maxX +5;
    self.usePasTF.y = pasLabel.y;
    self.usePasTF.width = self.useTelTF.width;
    self.usePasTF.height = pasLabel.height;
    self.usePasTF.placeholder = @"请输入密码";
    self.usePasTF.font = self.useTelTF.font;
    self.usePasTF.borderStyle = UITextBorderStyleNone;
    self.usePasTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.usePasTF setSecureTextEntry:YES];
    [self.view addSubview:self.usePasTF];
    
    //分割线3
    UIView *view3 = [[UIView alloc]init];
    view3.x = 0;
    view3.y = view2.maxY + 50;
    view3.width = WIDTH;
    view3.height = view1.height;
    view3.backgroundColor = view1.backgroundColor;
    [self.view addSubview:view3];
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.width = 260;
    loginBtn.height = 40;
    loginBtn.y = view3.maxY + 30;
    loginBtn.centerX = self.view.centerX;
    loginBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    loginBtn.layer.cornerRadius = 10;
    [loginBtn setTitle:@"登            录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //忘记密码按钮
    UIButton *resetBtn = [[UIButton alloc]init];
    resetBtn.size = [XyqsTools getSizeWithText:@"忘记密码?" andFont:[UIFont systemFontOfSize:12]];
    resetBtn.y = loginBtn.maxY + 20;
    resetBtn.x = loginBtn.maxX - 10 - resetBtn.width;
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [resetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
}

//登录
-(void)login
{
//    //密码加密程序
//    RSA *rsa = [RSA shareInstance];
//    [rsa generateKeyPairRSACompleteBlock:^{
//        if (self.usePasTF.text)
//        {
//            NSData *encryptData = [rsa RSA_EncryptUsingPublicKeyWithData:[self.usePasTF.text dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            NSData *decryptData = [rsa RSA_EncryptUsingPrivateKeyWithData:encryptData];
//            NSString *originString = [[NSString alloc]initWithData:decryptData encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"%@",originString);
//        }
//    }];
//    
//    NSString *va1 = self.usePasTF.text;
//    NSString *va2 = self.useTelTF.text;
    
    if (self.useTelTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号"];
        self.useTelTF.text = @"";
        return;
    }

    
    
    
    if (self.usePasTF.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
        //登录
        [XyqsApi requestTelLoginWithMobile:self.useTelTF.text andPassword:self.usePasTF.text andCallBack:^(id obj) {
            //登录成功后返回个人信息界面
            NSString *token = obj;
            
            //保存用户登录的手机号码
            [[NSUserDefaults standardUserDefaults] setObject:self.useTelTF.text forKey:@"telNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (token)
            {
                [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self.delegate passvalue:self.useTelTF.text];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];;
    
}

//跳转到注册界面
-(void)onClick
{
    //跳转到注册界面
    RegisterVc *registerVC = [[RegisterVc alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}




//密码重置
-(void)reset
{
    ResetPasVC *vc = [[ResetPasVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


// 提示错误信息
- (void)showError:(NSString *)errorMsg
{
    // 1.弹框提醒
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    // 2.仿QQ窗口抖动
    // 核心动画之 关键帧动画
    CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
    // 哪一个成员属性 需要动画,答:x
    shakeAnim.keyPath = @"transform.translation.x";
    shakeAnim.duration = 0.15;
    CGFloat delta = 10;
    // 数组,指定每一帧时的x值
    shakeAnim.values = @[@0, @(-delta), @(delta), @0];
    shakeAnim.repeatCount = 2;
    // 让view所在的图层执行 关键帧动画
    [self.view.layer addAnimation:shakeAnim forKey:nil];
}





@end
