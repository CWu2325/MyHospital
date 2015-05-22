//
//  CommonAppointmentVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "CommonAppointmentVC.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "comMember.h"
#import "MemberInfoVC.h"
#import "User.h"
#import "NoNetworkView.h"
#import "AppDelegate.h"

@interface CommonAppointmentVC ()

@property(nonatomic,strong)NSMutableArray *members;

@property(nonatomic,strong)NoNetworkView *noNetView;

@end

@implementation CommonAppointmentVC
-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        [self.view addSubview:_noNetView];
    }
    return _noNetView;
}


-(NSMutableArray *)appointDatas
{
    if (!_members)
    {
        _members = [NSMutableArray array];
    }
    return _members;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(AddMember)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDlg = [[UIApplication sharedApplication] delegate];
    if (appDlg.isReachable)
    {
        self.noNetView.hidden = YES;
        
        [self requestData];
    }
    else
    {
        
        self.noNetView.hidden = NO;
        [self.view bringSubviewToFront:self.noNetView];
    }

}


/**
 *  网络请求
 */
-(void)requestData
{
    //如果是从选择预约人界面跳转过来的
    NSDictionary *params = @{@"token":[XyqsTools getToken]};
    
    if ([self.fromWhere isEqualToString:@"A"] )
    {
        //获取常用预约人息接口
        [HttpTool get:@"http://14.29.84.4:6060/0.1/user/memberinfo" params:params success:^(id responseObj) {
            self.noNetView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                self.members = [JsonParser parseCommonMemberByDictionary:dataDic];
                //再获取个人信息加入到预约人列表中
                [HttpTool get:@"http://14.29.84.4:6060/0.1/user/userinfo" params:params success:^(id responseObj2) {
                    self.noNetView.hidden = YES;
                    if ([[responseObj2 objectForKey:@"returnCode"] isEqual:@(1001)])
                    {
                        NSDictionary *dataDic = [responseObj2 objectForKey:@"data"];
                        User *user = [JsonParser parseUserByDictionary:dataDic];
                        comMember *member = [[comMember alloc]init];
                        if (user.name != (NSString *)[NSNull null])
                        {
                            member.name = user.name;
                        }
                        
                        member.comID = @"0";        //就诊人ID，0代表自己
                        
                        if (user.mobile != (NSString *)[NSNull null])
                        {
                            member.mobile = user.mobile;
                        }
                        
                        if (user.idCard != (NSString *)[NSNull null])
                        {
                            member.idCard = user.idCard;
                        }
                        
                        if (user.sscard != (NSString *)[NSNull null])
                        {
                            member.sscard = user.sscard;
                        }
                        
                        [self.members insertObject:member atIndex:0];
                        [self.tableView reloadData];
                    }
                    else
                    {
                        [MBProgressHUD showError:[responseObj2 objectForKey:@"message"]];
                    }
                } failure:^(NSError *error) {
                    if (error)
                    {
                        self.noNetView.hidden = NO;                    }
                }];
            }
            else
            {
                [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
            if (error)
            {
                self.noNetView.hidden = NO;
            }
        }];
    }
    else
    {
        //获取常用预约人息接口
        [HttpTool get:@"http://14.29.84.4:6060/0.1/user/memberinfo" params:params success:^(id responseObj) {
            self.noNetView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                self.members = [JsonParser parseCommonMemberByDictionary:dataDic];
                [self.tableView reloadData];
            }
            else
            {
                [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
            if (error)
            {
                self.noNetView.hidden = NO;
            }
        }];
    }
}


//点击右上角添加按钮添加预约人
-(void)AddMember
{
    if ([self.fromWhere isEqualToString:@"A"])
    {
        if (self.members.count < 6)
        {
            MemberInfoVC *vc =  [[MemberInfoVC alloc]init];
            vc.title = @"添加预约人";
            vc.fromWhere = @"add";
            [self.navigationController pushViewController:vc animated:NO];
        }
        else
        {
            [MBProgressHUD showError:@"最多只能添加5位预约人"];
        }
        
    }
    else
    {
        if (self.members.count < 5)
        {
            MemberInfoVC *vc =  [[MemberInfoVC alloc]init];
            vc.title = @"添加预约人";
            vc.fromWhere = @"add";
            [self.navigationController pushViewController:vc animated:NO];
        }
        else
        {
            [MBProgressHUD showError:@"最多只能添加5位预约人"];
        }
    }
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UIImageView *diviIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, WIDTH, 1)];
    diviIV.backgroundColor = LCWDivisionLineColor;
    [cell.contentView addSubview:diviIV];
    
    comMember *member = self.members[indexPath.row];
    
    cell.textLabel.text = member.name;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"可添加5位预约人";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = [XyqsTools getSizeWithText:label.text andFont:label.font];
    label.center = footerView.center;
    [footerView addSubview:label];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([self.fromWhere isEqualToString:@"A"])
    {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        comMember *m = self.members[indexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:m.comID forKey:@"mberId"];
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
        
        [HttpTool post:@"http://14.29.84.4:6060/0.1/user/remove_member" params:params success:^(id responseObj) {
            self.noNetView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"]isEqual: @(1001)])
            {
                [MBProgressHUD showSuccess:[responseObj objectForKey:@"message"]];
                
            }
            else
            {
                [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
            }
        } failure:^(NSError *error) {
            if (error)
            {
                self.noNetView.hidden = NO;
            }
        }];
        
        
        [self.appointDatas removeObject:self.appointDatas[indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fromWhere isEqualToString:@"A"])
    {
        comMember *member = self.members[indexPath.row];
        [self.delegate passMember:member];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {

        MemberInfoVC *vc = [[MemberInfoVC alloc]init];
        vc.member = self.members[indexPath.row];
        vc.title = @"预约人信息";
        vc.fromWhere = @"find";
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}




@end
