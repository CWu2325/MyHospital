//
//  MemberInfoVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/14.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MemberInfoVC.h"
#import "HttpTool.h"
#import "JsonParser.h"

@interface MemberInfoVC ()<UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UITextField *useIDTF;
@property(nonatomic,strong)UITextField *useTelTF;
@property(nonatomic,strong)UITextField *useSSCardTF;
@property(nonatomic,strong)UITextField *sexTF;

@property(nonatomic,strong)UIButton *sexBtn;

@end

@implementation MemberInfoVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.nameTF resignFirstResponder];
    [self.useIDTF resignFirstResponder];
    [self.useTelTF resignFirstResponder];
    [self.useSSCardTF resignFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([self.fromWhere isEqualToString:@"add"])
    {
        [self.nameTF becomeFirstResponder];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAdd)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBarModified:)];
        if (self.member.name != (NSString *)[NSNull null])
        {
            self.nameTF.text = self.member.name;
          //  self.nameTF.userInteractionEnabled = NO;
        }
        
        [self.sexBtn setEnabled:NO];
        
        
        if ([self.member.sex intValue] == 2)
        {
            
            self.sexTF.text = @"女";
        }
        else
        {
            self.sexTF.text = @"男";
        }
        
        if (self.member.idCard != (NSString *)[NSNull null])
        {
            self.useIDTF.text = self.member.idCard;
           // self.useIDTF.userInteractionEnabled = NO;
        }
        
        if (self.member.mobile != (NSString *)[NSNull null])
        {
            self.useTelTF.text = self.member.mobile;
           // self.useTelTF.userInteractionEnabled = NO;
        }
        
        if (self.member.sscard != (NSString *)[NSNull null])
        {
            self.useSSCardTF.text = self.member.sscard;
           // self.useSSCardTF.userInteractionEnabled = NO;
        }
    }
}

-(void)initUI
{
    //承载各种控件的基础view
    UIScrollView *backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = LCWBackgroundColor;
    backView.delegate = self;
    [self.view addSubview:backView];
    
    //6条水平分割线 和一条竖直分割线
    for (int i = 0; i < 6; i++)
    {
        UIImageView *horizontalIV = [[UIImageView alloc]init];
        horizontalIV.x = 0;
        horizontalIV.y = i * 50;
        horizontalIV.width = WIDTH;
        horizontalIV.height = 1;
        horizontalIV.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:horizontalIV];     //水平
    }
    
    //姓名
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"姓        名";
    label1.font = [UIFont systemFontOfSize:15];
    label1.size = [XyqsTools getSizeWithText:label1.text andFont:label1.font];
    label1.y = 50.0/2 - label1.height/2;
    label1.x = 10;
    label1.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label1];
    
    //竖直分割线
    UIImageView *verticalIV = [[UIImageView alloc]init];
    verticalIV.x = label1.maxX + 10;
    verticalIV.y = 0;
    verticalIV.width = 1;
    verticalIV.height = 250;
    verticalIV.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:verticalIV];       //竖直
    
    UITextField *nameTF = [[UITextField alloc]init];
    nameTF.x = verticalIV.x + 10;
    nameTF.y = label1.y;
    nameTF.height = label1.height;
    nameTF.width = WIDTH - nameTF.maxX - 5;
    nameTF.placeholder = @"请输入姓名(必填)";
    nameTF.font = label1.font;
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTF.borderStyle = UITextBorderStyleNone;
    self.nameTF = nameTF;
    nameTF.delegate = self;
    [backView addSubview:nameTF];
    
    //性别
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"性        别";
    label2.font = label1.font;
    label2.size = label1.size;
    label2.y = label1.y + 50;
    label2.x = label1.x;
    label2.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label2];
    
    UITextField *sexTF = [[UITextField alloc]init];
    sexTF.x = nameTF.x;
    sexTF.y = label2.y;
    sexTF.height = label2.height;
    sexTF.width = 150;
    sexTF.placeholder = @"请选择性别(必选)";
    sexTF.font = label2.font;
    sexTF.userInteractionEnabled = NO;
    sexTF.borderStyle = UITextBorderStyleNone;
    self.sexTF = sexTF;
    sexTF.delegate = self;
    [backView addSubview:sexTF];
    
    UIButton *sexBtn = [[UIButton alloc]init];
    sexBtn.width = 80;
    sexBtn.height = 40;
    sexBtn.x = WIDTH - 10-sexBtn.width;
    sexBtn.centerY = sexTF.centerY;
    sexBtn.tag = 0;
    [sexBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [sexBtn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sexBtn];
    
    //身份证
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"身份证号";
    label3.font = label1.font;
    label3.size = [XyqsTools getSizeWithText:label3.text andFont:label3.font];
    label3.y = label2.y + 50;
    label3.centerX = label2.centerX;
    label3.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label3];
    
    UITextField *useIDTF = [[UITextField alloc]init];
    useIDTF.x = nameTF.x;
    useIDTF.y = label3.y;
    useIDTF.height = label3.height;
    useIDTF.width = nameTF.width;
    useIDTF.placeholder = @"请输入身份证号码(必填)";
    useIDTF.font = label1.font;
    useIDTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    useIDTF.borderStyle = UITextBorderStyleNone;
    self.useIDTF = useIDTF;
    useIDTF.delegate = self;
    [backView addSubview:useIDTF];
    
    //手机号
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"手 机 号";
    label4.font = label1.font;
    label4.size = [XyqsTools getSizeWithText:label3.text andFont:label3.font];
    label4.y = label3.y + 50;
    label4.centerX = label2.centerX;
    label4.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label4];
    
    UITextField *useTelTF = [[UITextField alloc]init];
    useTelTF.x = nameTF.x;
    useTelTF.y = label4.y;
    useTelTF.height = label4.height;
    useTelTF.width = nameTF.width;
    useTelTF.placeholder = @"请输入手机号(必填)";
    useTelTF.font = label1.font;
    useTelTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    useTelTF.keyboardType = UIKeyboardTypeNumberPad;
    useTelTF.borderStyle = UITextBorderStyleNone;
    self.useTelTF = useTelTF;
    useTelTF.delegate = self;
    [backView addSubview:useTelTF];
    
    //社保卡
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"社保卡号";
    label5.font = label1.font;
    label5.size = [XyqsTools getSizeWithText:label3.text andFont:label3.font];
    label5.y = label4.y + 50;
    label5.centerX = label2.centerX;
    label5.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label5];
    
    UITextField *useSSCardTF = [[UITextField alloc]init];
    useSSCardTF.x = nameTF.x;
    useSSCardTF.y = label5.y;
    useSSCardTF.height = label5.height;
    useSSCardTF.width = nameTF.width;
    useSSCardTF.placeholder = @"请输入社保卡号(选填)";
    useSSCardTF.font = label1.font;
    useSSCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    useSSCardTF.borderStyle = UITextBorderStyleNone;
    self.useSSCardTF = useSSCardTF;
    useSSCardTF.delegate = self;
    [backView addSubview:useSSCardTF];
    
    backView.contentSize = CGSizeMake(WIDTH, HEIGHT * 1.2);
    
}

-(void)changeSex:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        self.sexTF.text = @"女";
        [sender setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
        sender.tag = 1;
    }
    else
    {
        self.sexTF.text = @"男";
        [sender setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
        sender.tag = 0;
    }
}


//添加功能
-(void)rightBarAdd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.nameTF.text.length == 0)
    {
        [MBProgressHUD showError:@"姓名不能为空"];
        return;
    }
    else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([\u4E00-\uFA29]|[\uE7C7-\uE7F3]){2,20}$"] evaluateWithObject:self.nameTF.text])
    {
        [MBProgressHUD showError:@"姓名必须为中文"];
        return ;
    }
    else
    {
        [params setObject:self.nameTF.text  forKey:@"name"];
    }
    
    if (self.useIDTF.text.length == 0)
    {
        [MBProgressHUD showError:@"身份证号码不能为空"];
        return;
    }
    else if (self.useIDTF.text.length != 18)
    {
        [MBProgressHUD showError:@"身份证号码不正确"];
        return;
    }
    else
    {
        [params setObject:self.useIDTF.text  forKey:@"idCard"];
    }
    

    if (self.useTelTF.text.length == 0)
    {
        [MBProgressHUD showError:@"手机号码不能为空"];
        return;
    }
    else if(![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1][3-8]+\\d{9}"] evaluateWithObject:self.useTelTF.text])
    {
        [MBProgressHUD showError:@"亲~您输入的不是手机号码"];
       // self.useTelTF.text = @"";
        return ;
    }
    else
    {
        [params setObject:self.useTelTF.text  forKey:@"mobile"];
    }
    
    if (self.useSSCardTF.text.length != 0)
    {
        [params setObject:self.useSSCardTF.text  forKey:@"sscard"];
    }
    
    NSString *sex = [self.sexTF.text isEqualToString:@"男"]?@"1":@"2";
    [params setObject:sex  forKey:@"sex"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
    
    //添加常用预约人
    [HttpTool post:@"http://14.29.84.4:6060/0.1/user/create_member" params:params success:^(id responseObj) {
        if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            if ([[responseObj objectForKey:@"message"] isEqualToString:@"操作成功"])
            {
                [MBProgressHUD showSuccess:@"添加成员成功"];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
        else
        {
            [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        if (error)
        {
            [MBProgressHUD showError:@"请检查网络连接"];
        }
    }];
}

//修改功能
-(void)rightBarModified:(UIBarButtonItem *)barItem
{
    if ([barItem.title isEqualToString:@"编辑"])
    {
        barItem.title = @"保存";
        self.nameTF.userInteractionEnabled = YES;
        self.sexBtn.enabled = YES;
        self.useIDTF.userInteractionEnabled = YES;
        self.useTelTF.userInteractionEnabled = YES;
        self.useSSCardTF.userInteractionEnabled = YES;
        
        
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //姓名
        if (self.nameTF.text.length == 0)
        {
            [MBProgressHUD showError:@"姓名不能为空"];
            return;
        }
        else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([\u4E00-\uFA29]|[\uE7C7-\uE7F3]){2,20}$"] evaluateWithObject:self.nameTF.text])
        {
            [MBProgressHUD showError:@"姓名必须为中文"];
            return ;
        }
        else
        {
            [params setObject:self.nameTF.text  forKey:@"name"];
        }
        
        //身份证号码
        if (self.useIDTF.text.length == 0)
        {
            [MBProgressHUD showError:@"身份证号码不能为空"];
            return;
        }
        else if (self.useIDTF.text.length != 18)
        {
            [MBProgressHUD showError:@"身份证号码不正确"];
            return;
        }
        else
        {
            [params setObject:self.useIDTF.text  forKey:@"idCard"];
        }
        
        //电话号码
        if (self.useTelTF.text.length == 0)
        {
            [MBProgressHUD showError:@"手机号码不能为空"];
            return;
        }
        else if(![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1][3-8]+\\d{9}"] evaluateWithObject:self.useTelTF.text])
        {
            [MBProgressHUD showError:@"亲~您输入的不是手机号码"];
            self.useTelTF.text = @"";
            return ;
        }
        else
        {
            [params setObject:self.useTelTF.text  forKey:@"mobile"];
        }
        
        //社保卡号
        if (self.useSSCardTF.text.length != 0)
        {
            [params setObject:self.useSSCardTF.text  forKey:@"sscard"];
        }
        
        //性别
        if ([self.sexTF.text isEqualToString:@"男"])
        {
            [params setObject:@(1) forKey:@"sex"];
        }
        else
        {
            [params setObject:@(2) forKey:@"sex"];
        }
        
        //主键ID
        [params setObject:self.member.comID forKey:@"id"];
        
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
        
        //更新常用预约人资料
        [HttpTool post:@"http://14.29.84.4:6060/0.1/user/update_member" params:params success:^(id responseObj) {
            if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
            {
                if ([[responseObj objectForKey:@"message"]isEqualToString:@"操作成功"])
                {
                    [MBProgressHUD showSuccess:@"修改成员成功"];
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
            else
            {
                [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
            if (error)
            {
                //=---------------------------------
            }
        }];

    }
    
   }



#pragma mark - TExtfield的代理事件
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (HEIGHT - 305.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0, -offset,WIDTH, HEIGHT);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 64, WIDTH,HEIGHT);
}


@end
