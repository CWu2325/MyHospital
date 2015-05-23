//
//  PersonalVC.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "PersonalVC.h"
#import "LoginViewController.h"
#import "PersonInfoCell.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "FrequentlyPersonsVC.h"
#import "AppointmentRecordVC.h"
#import "MyAttentionVC.h"
#import "SetUseInfoVC.h"
#import "AppSettingVC.h"
#import "CacheDic.h"


@interface PersonalVC ()<Passvalue>

@property(nonatomic,strong)User *user;
@property(nonatomic,copy)NSString *value;
@end

@implementation PersonalVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = @"个人账户";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleLabel.text = @"个人账户";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    
}

    //让导航栏变的透明
//-(void)setNavBar
//{
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    [navBar setBackgroundImage:[UIImage imageNamed:@"navBackground.png"] forBarMetrics:UIBarMetricsDefault];
//    navBar.shadowImage = [[UIImage alloc]init];
//}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //判断是否是登录的用户，如果不是就跳转到登录界面
    if (![XyqsTools isLogin])
    {
        //如果没有登录，就跳转到登录界面
        LoginViewController *loginVc = [[LoginViewController alloc]init];
        loginVc.formWhere = @"perInfo";
        [self.navigationController pushViewController:loginVc animated:NO];
    }
    else
    {
        if ([CacheDic getDicWithFileName:@"userinfo.txt"])
        {
            NSDictionary *dataDic = [CacheDic getDicWithFileName:@"userinfo.txt"];
            self.user = [JsonParser parseUserByDictionary:dataDic];
            [self.tableView reloadData];
        }
        else
        {
            NSDictionary *params = @{@"token":[XyqsTools getToken]};
            //如果登录了，就获取个人账户资料，刷新本界面
            [HttpTool get:@"http://14.29.84.4:6060/0.1/user/userinfo" params:params success:^(id responseObj) {
                
                
                
                if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
                {
                    //保存数据
                    [CacheDic saveDicDataData:responseObj andFileName:@"userinfo.txt"];
                    
                    NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                    self.user = [JsonParser parseUserByDictionary:dataDic];
                    [self.tableView reloadData];
                }
                else
                {
                    [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
                }
            } failure:^(NSError *error) {
                if (error)
                {
                    [MBProgressHUD showError:@"请检查您的网络"];
                }
            }];
        }
        
       
    }
}


-(void)passvalue:(NSString *)value
{
    self.value = value;
}


- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 5;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        PersonInfoCell *cell = [[PersonInfoCell alloc]init];
        cell.user = self.user;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        if (indexPath.section == 1)
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"预约记录"];
                    cell.textLabel.text = @"预约记录";
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"病历资料"];
                    cell.textLabel.text = @"病历资料";
                    break;
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"检验报告"];
                    cell.textLabel.text = @"检验报告";
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"我的关注"];
                    cell.textLabel.text = @"我的关注";
                    break;
                case 4:
                    cell.imageView.image = [UIImage imageNamed:@"预约人"];
                    cell.textLabel.text = @"常用预约人";
                    break;
            }
        }
        else if(indexPath.section == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"设置"];
            cell.textLabel.text = @"APP设置";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49, WIDTH, 1)];
        view.backgroundColor = LCWDivisionLineColor;
        [cell.contentView addSubview:view];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 130;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return 10;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = nil;
    if (indexPath.section ==0 )
    {
        //个人信息设置
        SetUseInfoVC *setVC = [[SetUseInfoVC alloc]init];
        setVC .user =self.user;
        if (self.user.name != (NSString *)[NSNull null])
        {
            setVC.title = @"个人资料";
            setVC.formWhere = @"find";
        }
        else
        {
            setVC.title = @"个人资料";
            setVC.formWhere = @"set";
        }
        vc = setVC;
        //传值
    }
    else if (indexPath.section == 2)
    {
        vc = [[AppSettingVC alloc]init];  
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                //预约记录
                vc = [[AppointmentRecordVC alloc]init];
            }
                break;
            case 1:
            {
                [MBProgressHUD showError:@"功能待完善"];
            }
                break;
            case 2:
            {
                [MBProgressHUD showError:@"功能待完善"];
            }
                break;
            case 3:
            {
                //我的关注
                vc = [[MyAttentionVC alloc]init];
            }
                break;
            case 4:
            {
                //常用预约人
                FrequentlyPersonsVC *ComVC = [[FrequentlyPersonsVC alloc]init];
                ComVC.title = @"常用预约人";
                ComVC.fromWhere = @"B";
                vc = ComVC;
            }
                break;
                
            default:
                break;
        }
    }

    [self.navigationController pushViewController:vc animated:NO];
    
}



@end
