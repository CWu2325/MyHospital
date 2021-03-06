//
//  LoginViewController.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterVc.h"
#import "HttpTool.h"
#import "ResetPasVC.h"
#import "PersonalVC.h"
#import "TabBarVC.h"
#import "AppDelegate.h"


@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView *useImageView;
@property(nonatomic,strong)UITextField *useTelTF;
@property(nonatomic,strong)UITextField *usePasTF;

@property(nonatomic,strong)AppDelegate *appDlg;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDlg = [UIApplication sharedApplication].delegate;
 
    
    self.title = @"就医无忧登录";

    self.view.backgroundColor = LCWBackgroundColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onClick)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back-icon@2x.png" highImageName:@"back-icon@2x.png" target:self action:@selector(back)];

    [self initUI];
}



-(void)back
{
    if ([self.formWhere isEqualToString:@"perInfo"])
    {
        TabBarVC *vc = [[TabBarVC alloc]init];
        [self presentViewController:vc animated:NO completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}


-(void)initUI
{
    UIScrollView *baseSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:baseSV];
    baseSV.delegate = self;
    baseSV.contentSize = CGSizeMake(WIDTH, HEIGHT*1.1);
    
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 230)];
    [baseSV addSubview:downView];
    downView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 130)];
    backgroundImageView.image = [UIImage imageNamed:@"background_login.jpg"];
    [downView addSubview:backgroundImageView];
    
    //登录前默认的头像
    self.useImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];

    [downView addSubview:self.useImageView];
    self.useImageView.centerX = self.view.centerX;
    self.useImageView.centerY = 65;
    self.useImageView.layer.cornerRadius = self.useImageView.width/2;
    self.useImageView.layer.borderWidth = 1.5;
    self.useImageView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5].CGColor;
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
    view1.backgroundColor = LCWBackgroundColor;
    [downView addSubview:view1];
    
    //账号栏
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.text = @"手机号:";
    telLabel.font = [UIFont systemFontOfSize:15];
    telLabel.size = [telLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    telLabel.x = 10;
    telLabel.centerY = view1.maxY + 25;
    telLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:telLabel];
    
    UITextField *useTelTF = [[UITextField alloc]init];
    useTelTF.delegate = self;
    self.useTelTF = useTelTF;
    self.useTelTF.x = telLabel.maxX +5;
    self.useTelTF.y = telLabel.y;
    self.useTelTF.width = WIDTH - self.useTelTF.x - 5;
    self.useTelTF.height = telLabel.height;
    self.useTelTF.placeholder = @"请输入手机号码";
    self.useTelTF.font = telLabel.font;
    self.useTelTF.borderStyle = UITextBorderStyleNone;
    self.useTelTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.useTelTF becomeFirstResponder];
    self.useTelTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [downView addSubview:self.useTelTF];
    
    //分割线2
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = view1.maxY + 50;
    view2.width = WIDTH;
    view2.height = view1.height;
    view2.backgroundColor = view1.backgroundColor;
    [downView addSubview:view2];
    
    //密码栏
    UILabel *pasLabel = [[UILabel alloc]init];
    pasLabel.text = @"密    码:";
    pasLabel.font = telLabel.font;
    pasLabel.size = [pasLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:telLabel.font} context:nil].size;
    pasLabel.x = telLabel.x;
    pasLabel.centerY = view2.maxY + 25;
    pasLabel.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:pasLabel];
    
    UITextField *usePasTF = [[UITextField alloc]init];
    usePasTF.delegate = self;
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
    [downView addSubview:self.usePasTF];
 
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.width = 260;
    loginBtn.height = 40;
    loginBtn.y = downView.maxY + 30;
    loginBtn.centerX = self.view.centerX;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
    
   // loginBtn.layer.backgroundColor = LCWBottomColor.CGColor;
    loginBtn.layer.cornerRadius = 10;
    [loginBtn setTitle:@"登            录" forState:UIControlStateNormal];
    
    
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [baseSV addSubview:loginBtn];
    
    //忘记密码按钮
    UIButton *resetBtn = [[UIButton alloc]init];
    resetBtn.size = [XyqsTools getSizeWithText:@"忘记密码?" andFont:[UIFont systemFontOfSize:12]];
    resetBtn.y = loginBtn.maxY + 20;
    resetBtn.x = loginBtn.maxX - 10 - resetBtn.width;
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [resetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [baseSV addSubview:resetBtn];
    
}

//登录
-(void)login
{
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
    
    if (self.appDlg.isReachable)
    {
        
        //登录
        NSDictionary *params = @{@"mobile":self.useTelTF.text,@"password":self.usePasTF.text};
        [HttpTool post:@"http://14.29.84.4:6060/0.1/user/mobile_login" params:params success:^(id responseObj) {
            if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
            {
                NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                NSDictionary *tokenDic = [dataDic objectForKey:@"token"];
                //保存用户登录的手机号码
                [[NSUserDefaults standardUserDefaults] setObject:self.useTelTF.text forKey:@"telNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSString *token = [tokenDic objectForKey:@"token"];
                if (token)
                {
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self.delegate passvalue:self.useTelTF.text];
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
            else
            {
                [MBProgressHUD showError:@"用户名或密码错误"];
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

//跳转到注册界面
-(void)onClick
{
    //跳转到注册界面
    RegisterVc *registerVC = [[RegisterVc alloc]init];
    [self.navigationController pushViewController:registerVC animated:NO];
}




//密码重置
-(void)reset
{
    ResetPasVC *vc = [[ResetPasVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.usePasTF resignFirstResponder];
    [self.useTelTF resignFirstResponder];
}




@end
