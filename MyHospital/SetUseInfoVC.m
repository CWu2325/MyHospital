//
//  SetUseInfoVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/15.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SetUseInfoVC.h"
#import "XyqsApi.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

#define HMEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@interface SetUseInfoVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UITextField *useIDTF;
@property(nonatomic,strong)UITextField *useTelTF;
@property(nonatomic,strong)UITextField *useSSCardTF;
@property(nonatomic,strong)UITextField *addressTF;
@property(nonatomic,strong)UIButton *sexBtn;        //选择性别的btn
@property(nonatomic,strong)UIView *backView;        //承载的基础view

@end

@implementation SetUseInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //先初始化控件
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    if ([self.formWhere isEqualToString:@"find"])
    {
        if (self.user.name  != (NSString *)[NSNull null])
        {
            self.nameTF.text = self.user.name;
            self.nameTF.userInteractionEnabled = NO;
        }
        
        if (self.user.idCard != (NSString *)[NSNull null])
        {
            self.useIDTF.text = self.user.idCard;
            self.useIDTF.userInteractionEnabled = NO;
        }
        
        self.useTelTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"telNumber"];
        self.useTelTF.userInteractionEnabled = NO;
        
        if (self.user.sscard != (NSString *)[NSNull null])
        {
            self.useSSCardTF.text = self.user.sscard;
            self.useSSCardTF.userInteractionEnabled = NO;
        }
        
        if (self.user.address != (NSString *)[NSNull null])
        {
            self.addressTF.text = self.user.address;
        }

        if (self.user.Sex == 2)
        {
            self.sexLabel.text = @"女";
            [self.sexBtn setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
        }
        else
        {
            self.sexLabel.text = @"男";
            [self.sexBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
        }
        
//        if (self.user.coverUrl != (NSString *)[NSNull null])
//        {
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.coverUrl]];
//                UIImage *image = [UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.userImageView.image = image;
//                });
//            });
//        }
//        else
//        {
//            self.userImageView.image = [UIImage imageNamed:@"default_avatar"];
//        }
        if (self.user.coverUrl != (NSString *)[NSNull null])
        {
            [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.coverUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:SDWebImageRetryFailed];
        }
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBarModified)];
    }
    else
    {
        if (self.user.coverUrl != (NSString *)[NSNull null])
        {
            [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.coverUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"] options:SDWebImageRetryFailed];
        }
        [self.nameTF becomeFirstResponder];
        self.useTelTF.userInteractionEnabled = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBarSave)];
    }
}

-(void)initUI
{
    UIScrollView *baseSV = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:baseSV];
    
    
    //头像
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_login.jpg"]];
    [baseSV addSubview:headerView];
    
    //头像
    UIImageView *headerIV = [[UIImageView alloc]init];
    headerIV.image = [UIImage imageNamed:@"default_avatar"];
    headerIV.width = 80;
    headerIV.height = 80;
    headerIV.center = headerView.center;
    headerIV.layer.cornerRadius = headerIV.width/2;
    headerIV.layer.borderWidth = 1.5;
    headerIV.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5].CGColor;
    headerIV.layer.masksToBounds = YES;
    [headerView addSubview:headerIV];
    self.userImageView = headerIV;
    headerIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR:)];
    tapGR.numberOfTapsRequired = 1;
    [headerIV addGestureRecognizer:tapGR];
    
    
    UILabel *myLabel = [[UILabel alloc]init];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.text = @"我的头像";
    myLabel.textColor = [UIColor whiteColor];
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.size = [XyqsTools getSizeWithText:myLabel.text andFont:myLabel.font];
    myLabel.centerX = headerIV.centerX;
    myLabel.y = headerIV.maxY + 5;
    [headerView addSubview:myLabel];
    
    
    //6条水平分割线 和一条竖直分割线
    for (int i = 0; i < 7; i++)
    {
        UIImageView *horizontalIV = [[UIImageView alloc]init];
        horizontalIV.x = 0;
        horizontalIV.y = i * 50 + headerView.maxY;
        horizontalIV.width = WIDTH;
        horizontalIV.height = 1;
        horizontalIV.backgroundColor = [UIColor lightGrayColor];
        [baseSV addSubview:horizontalIV];     //水平
    }
    
    //姓名
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"姓        名";
    label1.font = [UIFont systemFontOfSize:15];
    label1.size = [XyqsTools getSizeWithText:label1.text andFont:label1.font];
    label1.y = headerView.maxY + 50.0/2 - label1.height/2;
    label1.x = 10;
    label1.textAlignment = NSTextAlignmentCenter;
    [baseSV addSubview:label1];
    
    //竖直分割线
    UIImageView *verticalIV = [[UIImageView alloc]init];
    verticalIV.x = label1.maxX + 10;
    verticalIV.y = headerView.maxY;
    verticalIV.width = 1;
    verticalIV.height = 300;
    verticalIV.backgroundColor = [UIColor lightGrayColor];
    [baseSV addSubview:verticalIV];       //竖直
    
    UITextField *nameTF = [[UITextField alloc]init];
    nameTF.x = verticalIV.x + 10;
    nameTF.y = label1.y;
    nameTF.height = label1.height;
    nameTF.width = WIDTH - 10 - nameTF.x;
    nameTF.placeholder = @"请输入姓名(必填)";
    nameTF.font = label1.font;
    nameTF.borderStyle = UITextBorderStyleNone;
    nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTF = nameTF;
    nameTF.delegate = self;
    [baseSV addSubview:nameTF];
    
    //性别
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"性        别";
    label2.font = label1.font;
    label2.size = label1.size;
    label2.y = label1.y + 50;
    label2.x = label1.x;
    label2.textAlignment = NSTextAlignmentCenter;
    [baseSV addSubview:label2];
    
    UILabel *sexLabel = [[UILabel alloc]init];
    sexLabel.text = @"男";
    sexLabel.x = nameTF.x ;
    sexLabel.y = label2.y;
    sexLabel.width = 50;
    sexLabel.height = label2.height;
    sexLabel.font = label2.font;
    self.sexLabel = sexLabel;
    [baseSV addSubview:sexLabel];
    
    UIButton *sexBtn = [[UIButton alloc]init];
    sexBtn.width = 80;
    sexBtn.height = 40;
    sexBtn.x = WIDTH - 10-sexBtn.width;
    sexBtn.centerY = sexLabel.centerY;
    sexBtn.tag = 0;
    [sexBtn setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [sexBtn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
    [baseSV addSubview:sexBtn];
    
    //身份证
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"身份证号";
    label3.font = label1.font;
    label3.size = [XyqsTools getSizeWithText:label3.text andFont:label3.font];
    label3.y = label2.y + 50;
    label3.centerX = label2.centerX;
    label3.textAlignment = NSTextAlignmentCenter;
    [baseSV addSubview:label3];
    
    UITextField *useIDTF = [[UITextField alloc]init];
    useIDTF.x = nameTF.x;
    useIDTF.y = label3.y;
    useIDTF.height = label3.height;
    useIDTF.width = nameTF.width;
    useIDTF.placeholder = @"请输入身份证(必填)";
    useIDTF.font = label1.font;
    useIDTF.borderStyle = UITextBorderStyleNone;
    self.useIDTF = useIDTF;
    useIDTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    useIDTF.delegate = self;
    [baseSV addSubview:useIDTF];
    
    //手机号
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"手 机 号";
    label4.font = label1.font;
    label4.size = [XyqsTools getSizeWithText:label4.text andFont:label4.font];
    label4.y = label3.y + 50;
    label4.centerX = label2.centerX;
    label4.textAlignment = NSTextAlignmentCenter;
    [baseSV addSubview:label4];
    
    UITextField *useTelTF = [[UITextField alloc]init];
    useTelTF.x = nameTF.x;
    useTelTF.y = label4.y;
    useTelTF.height = label4.height;
    useTelTF.width = 200;
    useTelTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"telNumber"];
    useTelTF.font = label1.font;
    useTelTF.borderStyle = UITextBorderStyleNone;
    self.useTelTF = useTelTF;
    useIDTF.delegate = self;
    [baseSV addSubview:useTelTF];
    
    //居住地址
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"居住地址";
    label5.font = label1.font;
    label5.size = [XyqsTools getSizeWithText:label3.text andFont:label3.font];
    label5.y = label4.y + 50;
    label5.centerX = label2.centerX;
    label5.textAlignment = NSTextAlignmentCenter;
    [baseSV addSubview:label5];
    
    UITextField *addressTF = [[UITextField alloc]init];
    addressTF.x = nameTF.x;
    addressTF.y = label5.y;
    addressTF.height = label5.height;
    addressTF.width = 200;
    addressTF.placeholder = @"请输入居住地址(选填)";
    addressTF.font = label1.font;
    addressTF.borderStyle = UITextBorderStyleNone;
    addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressTF = addressTF;
    addressTF.delegate = self;
    [baseSV addSubview:addressTF];
    
    //社保卡
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"社保卡号";
    label6.font = label1.font;
    label6.size = [XyqsTools getSizeWithText:label6.text andFont:label6.font];
    label6.y = label5.y + 50;
    label6.centerX = label2.centerX;
    label6.textAlignment = NSTextAlignmentCenter;
    [baseSV addSubview:label6];
    
    UITextField *useSSCardTF = [[UITextField alloc]init];
    useSSCardTF.x = nameTF.x;
    useSSCardTF.y = label6.y;
    useSSCardTF.height = label5.height;
    useSSCardTF.width = 200;
    useSSCardTF.placeholder = @"请输入社保卡号(选填)";
    useSSCardTF.font = label1.font;
    useSSCardTF.borderStyle = UITextBorderStyleNone;
    useSSCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.useSSCardTF = useSSCardTF;
    useSSCardTF.delegate = self;
    [baseSV addSubview:useSSCardTF];
    
    baseSV.contentSize = CGSizeMake(WIDTH, HEIGHT * 1.2);
    
    
}

-(void)changeSex:(UIButton *)sender
{
    if ([self.formWhere isEqualToString:@"set"])
    {
        if (sender.tag == 0)
        {
            self.sexLabel.text = @"女";
            [sender setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
            sender.tag = 1;
        }
        else
        {
            self.sexLabel.text = @"男";
            [sender setImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
            sender.tag = 0;
        }
    }
    
}

//第一次进来设置个人信息并保存
-(void)rightBarSave
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
    
    //身份证
    if (self.useIDTF.text.length == 0)
    {
        [MBProgressHUD showError:@"身份证不能为空"];
        return;
    }
    else if(self.useIDTF.text.length != 18)
    {
        [MBProgressHUD showError:@"身份证不正确"];
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
        return ;
    }
    else
    {
        [params setObject:self.useTelTF.text  forKey:@"mobile"];
    }
    
    //社保卡
    if (self.useSSCardTF.text.length != 0)
    {
        [params setObject:self.useSSCardTF.text  forKey:@"sscard"];
    }
    
    if(self.addressTF.text.length != 0)
    {
        [params setObject:self.addressTF.text  forKey:@"address"];
    }
    
    //登录token
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    
    //性别
    if ([self.sexLabel.text isEqualToString:@"男"])
    {
        [params setObject:@(1)  forKey:@"sex"];
    }
    else
    {
        [params setObject:@(2)  forKey:@"sex"];
    }
    
    [XyqsApi updateUserInfoWithParams:params andCallBack:^(id obj) {
        [MBProgressHUD showSuccess:obj];
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
    
}

//查看或修改个人资料
-(void)rightBarModified
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
    
    //身份证
    if (self.useIDTF.text.length == 0)
    {
        [MBProgressHUD showError:@"身份证不能为空"];
        return;
    }
    else if(self.useIDTF.text.length != 18)
    {
        [MBProgressHUD showError:@"身份证不正确"];
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
        return ;
    }
    else
    {
        [params setObject:self.useTelTF.text  forKey:@"mobile"];
    }
    
    //社保卡
    if (self.useSSCardTF.text.length != 0)
    {
        [params setObject:self.useSSCardTF.text  forKey:@"sscard"];
    }
    
    if(self.addressTF.text.length != 0)
    {
        [params setObject:self.addressTF.text  forKey:@"address"];
    }
    
    //登录token
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    
    //性别
    if ([self.sexLabel.text isEqualToString:@"男"])
    {
        [params setObject:@(1)  forKey:@"sex"];
    }
    else
    {
        [params setObject:@(2)  forKey:@"sex"];
    }
    
    [XyqsApi updateUserInfoWithParams:params andCallBack:^(id obj) {
        [MBProgressHUD showSuccess:obj];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }];
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

#pragma mark - Tap事件--头像的选择
-(void)tapGR:(UITapGestureRecognizer *)tap
{
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"亲~请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"手机相册",nil];
    
   // [as showInView:self.view];
    
    [as showInView:[UIApplication sharedApplication].keyWindow];
    
    
}

//-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subViwe in actionSheet.subviews)
//    {
//        if ([subViwe isKindOfClass:[UIButton class]])
//        {
//            UIButton *button = (UIButton*)subViwe;
//            [button setTitleColor:LCWBottomColor forState:UIControlStateNormal];
//        }
//    }
//}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            //照相
            UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            ipc.allowsEditing = YES;
            ipc.delegate = self;
            [self presentViewController:ipc animated:NO completion:nil];
        }
            break;
        case 1:
        {
            //相册中存取
            UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
            [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            ipc.allowsEditing = YES;
            ipc.delegate = self;
            [self presentViewController:ipc animated:NO completion:nil];
        }
            break;

            
        default:
            break;
    }
}






#pragma mark - 选择图片的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize imageSize = image.size;
    imageSize.height = 626;
    imageSize.width = 413;
    //压缩图像
    image = [self imageWithImage:image scaledToSize:imageSize];
    
    
    NSString *url = [[info objectForKey:UIImagePickerControllerReferenceURL]description];
    
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([url hasSuffix:@"JPG"])
    {
        imageData = UIImageJPEGRepresentation(image, 0.00001);
        mimeType = @"image/jpg";
    }
    else
    {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    }

    [self upLoadImageWithData:imageData andMimeType:mimeType];
    
    // NSData *filedata = UIImagePNGRepresentation(image);
    //    [self upload:@"file" filename:@"upload.png" mimeType:mimeType data:filedata parmas:@{@"token" : [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]}];

    
}


/**
 *  对图片尺寸进行压缩--
 */
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size
{
    CGSize newSize;
    if (image.size.height / image.size.width > 1)
    {
        newSize.height = size.height;
        newSize.width = size.height / image.size.height * image.size.width;
    }
    else if (image.size.height / image.size.width < 1)
    {
        newSize.height = size.width / image.size.width * image.size.height;
        newSize.width = size.width;
    }
    else
    {
        newSize = size;
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



/**
 *  AFN上传图片
 */
-(void)upLoadImageWithData:(NSData *)data andMimeType:(NSString *)mimeType
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/head_upload";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
 
    [MBProgressHUD showMessage:@"正在上传头像"];
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        if ([[responseObject objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            [MBProgressHUD showSuccess:@"头像上传成功"];
            self.userImageView.image = [UIImage imageWithData:data];
        }
        else
        {
            [responseObject objectForKey:@"message"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [XyqsApi requestUserInfoWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] andCallBack:^(id obj) {
//            User *newUser = obj;
//            if (self.user.coverUrl != (NSString *)[NSNull null])
//            {
//                NSData *headerImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newUser.coverUrl]];
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                [ud setObject:headerImageData forKey:@"headerImageData"];
//                [ud synchronize];
//            }
//        }];
//    });
}


/**
 *  http  post上传图片
 */
- (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params
{
    // 文件上传
    NSURL *url = [NSURL URLWithString:@"http://14.29.84.4:6060/0.1/user/head_upload"];
   // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置超时
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:HMEncode(@"--heima\r\n")];
    // name : 指定参数名(必须跟服务器端保持一致)
    // filename : 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:HMEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:HMEncode(type)];
    
    [body appendData:HMEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:HMEncode(@"\r\n")];
    
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 参数开始的标志
        [body appendData:HMEncode(@"--heima\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:HMEncode(disposition)];
        
        [body appendData:HMEncode(@"\r\n")];
        [body appendData:HMEncode(obj)];
        [body appendData:HMEncode(@"\r\n")];
    }];
    
    /***************参数结束***************/
    // heima--\r\n
    [body appendData:HMEncode(@"--heima--\r\n")];
    request.HTTPBody = body;
    
    // 设置请求头
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    // 声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=heima" forHTTPHeaderField:@"Content-Type"];
    
    [request willChangeValueForKey:@"timeoutInterval"];
    request.timeoutInterval = 10;
    [request didChangeValueForKey:@"timeoutInterval"];
    

    
    [MBProgressHUD showMessage:@"正在更新图像"];
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [MBProgressHUD hideHUD];
        if (data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            [self dismissViewControllerAnimated:NO completion:nil];
            if ([[dict objectForKey:@"returnCode"] isEqual: @(1001)])
            {
                
                [MBProgressHUD showSuccess:@"头像更新成功"];
            }
            else
            {
                [MBProgressHUD showError:@"图像上传失败"];
            }
        }
        else
        {
            [MBProgressHUD showError:@"图像上传失败"];
        }
    }];
}

-(void)dealloc
{
    
}

@end
