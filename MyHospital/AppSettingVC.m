//
//  AppSettingVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/16.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppSettingVC.h"
#import "ChangePasswordVC.h"

@interface AppSettingVC ()

@end

@implementation AppSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"App设置";
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.backgroundColor = LCWBackgroundColor;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = @"意见反馈";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"接收系统消息";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"消息声音提醒";
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"消息震动提醒";
            }
                break;
            default:
                break;
        }
        
        UISegmentedControl *segmentC = [[UISegmentedControl alloc]initWithItems:@[@"ON",@"OFF"]];
        segmentC.frame = CGRectMake(0, 0, 60, 25);
        segmentC.tintColor = LCWBottomColor;
        segmentC.selectedSegmentIndex = 0;
       // [segmentC addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = segmentC;

    }
    else if (indexPath.section == 3)
    {
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        return 100;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 30, WIDTH - 40 * 2, 40)];
        logoutBtn.layer.cornerRadius = 8;
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageNamed:@"heighted.png"] forState:UIControlStateHighlighted];
        [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logoutBtn];
        return footerView;
    }
    return nil;
}

-(void)logout
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"token"];
    [ud removeObjectForKey:@"telNumber"];
    [ud synchronize];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ChangePasswordVC *vc = [[ChangePasswordVC alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else
    {
        [MBProgressHUD showError:@"功能待完善"];
    }
}

@end
