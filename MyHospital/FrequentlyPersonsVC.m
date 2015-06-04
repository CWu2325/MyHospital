//
//  FrequentlyPersonsVC.m
//  MyHospital
//
//  Created by XYQS on 15/5/23.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "FrequentlyPersonsVC.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "comMember.h"
#import "MemberInfoVC.h"
#import "User.h"
#import "AppDelegate.h"
#import "TimeoutView.h"
#import "CacheDic.h"

@interface FrequentlyPersonsVC ()<TimeOutDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *members;

@property(nonatomic,strong)UIView *noNetworkView;
@property(nonatomic)AppDelegate *appDlg;
@property(nonatomic,strong)TimeoutView *timeOutView;

@end

@implementation FrequentlyPersonsVC

-(void)setupNoNetWorkView
{
    self.noNetworkView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.noNetworkView.backgroundColor = LCWBackgroundColor;
    [self.view addSubview:self.noNetworkView];
    
    
    UIImageView *noNetWorkIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 127, 50, 50)];
    noNetWorkIv.image = [UIImage imageNamed:@"noNetWork.png"];
    noNetWorkIv.centerX = self.noNetworkView.centerX;
    [self.noNetworkView addSubview:noNetWorkIv];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    label.text = @"无网络连接,请联网后重试!";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.y = noNetWorkIv.maxY + 9;
    label.height = [XyqsTools getSizeWithText:label.text andFont:label.font].height;
    [self.noNetworkView addSubview:label];
    
    UIButton *resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    resetBtn.centerX = self.noNetworkView.centerX;
    resetBtn.y = label.maxY + 15;
    [resetBtn setTitle:@"重  试" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"noNetNormalBtn.png"] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"noNetHighLightedBtn.png"] forState:UIControlStateHighlighted];
    [resetBtn addTarget:self  action:@selector(noNetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetworkView addSubview:resetBtn];
    
}

-(void)noNetBtnAction
{
    if (self.appDlg.isReachable)
    {
        self.noNetworkView.hidden = YES;
        [self requestData];
    }
    else
    {
        self.noNetworkView.hidden = NO;
        [MBProgressHUD showError:@"亲~请检查您的网络连接"];
    }
}

-(TimeoutView *)timeOutView
{
    if (!_timeOutView)
    {
        _timeOutView = [[TimeoutView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _timeOutView.delegate = self;
        [self.view addSubview:_timeOutView];
    }
    return _timeOutView;
}

/**
 *  网络超时界面的代理事件
 */
-(void)tapTimeOutBtnAction
{
    if (self.appDlg.isReachable)
    {
        self.timeOutView.hidden = YES;
        [self requestData];
    }
    else
    {
        [MBProgressHUD showError:@"网络不给力，请稍后再试！"];
        self.timeOutView.hidden = NO;
    }
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
    
    self.appDlg = [[UIApplication sharedApplication] delegate];
    
    //创建表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self setupNoNetWorkView];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(AddMember)];
    
    //请求数据
    if (self.appDlg.isReachable)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.noNetworkView.hidden = YES;
        [self requestData];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.noNetworkView.hidden = NO;
    }
    
}


/**
 *  网络请求
 */
-(void)requestData
{
    //如果是从选择预约人界面跳转过来的
    NSDictionary *params = @{@"token":[XyqsTools getToken]};
    
    //获取常用预约人息接口
    [HttpTool get:@"http://14.29.84.4:6060/0.1/user/memberinfo" params:params success:^(id responseObj) {
        self.timeOutView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [responseObj objectForKey:@"data"];
            self.members = [JsonParser parseCommonMemberByDictionary:dataDic];
            if ([self.fromWhere isEqualToString:@"A"])
            {
                
                comMember *member = [[comMember alloc]init];
                if (self.user.name != (NSString *)[NSNull null])
                {
                    member.name = self.user.name;
                }
                
                member.comID = @"0";        //就诊人ID，0代表自己
                
                if (self.user.mobile != (NSString *)[NSNull null])
                {
                    member.mobile = self.user.mobile;
                }
                
                if (self.user.idCard != (NSString *)[NSNull null])
                {
                    member.idCard = self.user.idCard;
                }
                
                if (self.user.sscard != (NSString *)[NSNull null])
                {
                    member.sscard = self.user.sscard;
                }
                
                [self.members insertObject:member atIndex:0];
            }
            
            [self.tableView reloadData];
            
        }
        else
        {
            [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        if (error)
        {
            self.timeOutView.hidden = NO;
        }
    }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"frequent"];
    

    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"frequent"];
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
            self.timeOutView.hidden = YES;
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
                self.timeOutView.hidden = NO;
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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}



@end
