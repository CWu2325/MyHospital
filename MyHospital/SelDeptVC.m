//
//  SelDeptVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/28.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SelDeptVC.h"
#import "HeaderView.h"
#import "Hospital.h"
#import "Room.h"
#import "HttpTool.h"
#import "SelDoctorVC.h"
#import "NoNetworkView.h"
#import "AppDelegate.h"
#import "JsonParser.h"
#import "TimeoutView.h"

@interface SelDeptVC ()<UITableViewDataSource,UITableViewDelegate,TimeOutDelegate>

@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;

@property(nonatomic,strong)NSMutableArray *leftDepts;
@property(nonatomic,strong)NSMutableArray *rightDepts;

@property(nonatomic)AppDelegate *appDlg;
@property(nonatomic,strong)UIView *noNetworkView;


@property(nonatomic,strong)TimeoutView *timeOutView;
@end

@implementation SelDeptVC


-(NSMutableArray *)leftDepts
{
    if (!_leftDepts)
    {
        _leftDepts = [NSMutableArray array];
    }
    return _leftDepts;
}

-(NSMutableArray *)rightDepts
{
    if (!_rightDepts)
    {
        _rightDepts = [NSMutableArray array];
    }
    return _rightDepts;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约挂号";
    
    //初始化顶部视图
    [self initHeaderview];
    
    //初始化表格
    [self initTable];
    
    //设置无网络视图
    [self setupNoNetWorkView];
    
   
    //判断网络连接
    self.appDlg = [[UIApplication sharedApplication] delegate];
    if (self.appDlg.isReachable)
    {
        self.noNetworkView.hidden = YES;
        [self requestData];
    }
    else
    {
        self.noNetworkView.hidden = NO;
    }
}

/**
 * 设置无网络视图
 */
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


/**
 *  网络请求
 */
-(void)requestData
{
    //请求数据
    NSMutableDictionary *params0 = [NSMutableDictionary dictionary];
    [params0 setObject:@(0) forKey:@"deptId"];      //默认从0
    [params0 setObject:@(self.hospital.hospitalID) forKey:@"hpId"];
    
    [HttpTool get:@"http://14.29.84.4:6060/0.1/hospital/dept" params:params0 success:^(id responseObj) {
            self.timeOutView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                self.leftDepts = [JsonParser parseRoomByDictionary:dataDic];
                [self.leftTableView reloadData];
                if (self.leftDepts.count > 0)
                {
                    //添加预约期限
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, WIDTH, 30)];
                    label.text = [NSString stringWithFormat:@"今天可预约%@(含)以前的号源",self.hospital.orderLimitDate];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = LCWBottomColor;
                    label.font = [UIFont systemFontOfSize:10];
                    [self.view addSubview:label];
                    //分割线
                    UIImageView *diviIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 119, WIDTH, 1)];
                    diviIv.backgroundColor = LCWDivisionLineColor;
                    [self.view addSubview:diviIv];
                    
                    //让表格自动打开
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"leftIndexPathRow"] != (NSString *)[NSNull null])
                    {
                        indexPath = [NSIndexPath indexPathForRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"leftIndexPathRow"] integerValue] inSection:0];
                    }
                    else
                    {
                        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    }
                    
                    if (indexPath.row <= self.leftDepts.count)
                    {
                        [self tableView:self.leftTableView didSelectRowAtIndexPath:indexPath];
                        [self.leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }
                    
                }
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


/**
 *  初始化顶部视图
 */
-(void)initHeaderview
{
    UIView *headerView = [HeaderView getViewWithText:self.hospital.name andImage:@"椭圆1@2x.png" text:@"选择科室" andImage:@"椭圆1@2x.png" text:@"选择医生" andImage:@"椭圆2@2x.png" andTextColor:MYSELCOLOR andTextColor:MYSELCOLOR andTextColor:MYSELCOLOR];
    [self.view addSubview:headerView];
}

/**
 *  初始化表格
 */
-(void)initTable
{
    UITableView *leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120,WIDTH/2, HEIGHT - 120 - 64)];
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    self.leftTableView = leftTableView;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:leftTableView];
    
    UITableView *rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(leftTableView.maxX, leftTableView.y,leftTableView.width, leftTableView.height)];
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    self.rightTableView = rightTableView;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:rightTableView];
}


#pragma mark -UITableViewDataSource数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView)
    {
        return self.leftDepts.count;
    }
    else
    {
        return self.rightDepts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        UIImageView *divisionIV = [[UIImageView alloc]init];
        divisionIV.x = 0;
        divisionIV.y = cell.height - 1;
        divisionIV.width = cell.width;
        divisionIV.height = 1;
        divisionIV.backgroundColor = LCWDivisionLineColor;
        [cell.contentView addSubview:divisionIV];
        
        Room *a = self.leftDepts[indexPath.row];
        cell.textLabel.text = a.name;
        cell.backgroundColor = [UIColor colorWithRed:232.0/255 green:235.0/255 blue:234.0/255 alpha:1];
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier2 = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        Room *a = self.rightDepts[indexPath.row];
        cell.textLabel.text = a.name;
        return cell;
    }
}

#pragma mark - UITableViewDelegate代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView)
    {
        NSString *leftIndexPathRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject: leftIndexPathRow forKey:@"leftIndexPathRow"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (indexPath.row < self.leftDepts.count)
        {
            Room *a = self.leftDepts[indexPath.row];
            //请求数据
            NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
            [params1 setObject:@(a.roomID) forKey:@"deptId"];
            [params1 setObject:@(self.hospital.hospitalID) forKey:@"hpId"];
            
            [HttpTool get:@"http://14.29.84.4:6060/0.1/hospital/dept" params:params1 success:^(id responseObj) {
                    self.noNetworkView.hidden = YES;
                    if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
                    {
                        NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                        self.rightDepts = [JsonParser parseRoomByDictionary:dataDic];
                        [self.rightTableView reloadData];
                        if (self.rightDepts.count > 0)
                        {
                            self.rightTableView.hidden = NO;
                            [self.rightTableView reloadData];
                        }
                        else
                        {
                            self.rightTableView.hidden = YES;
                        }
                    }
                    else
                    {
                        self.rightTableView.hidden = YES;
                        [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
                    }
            } failure:^(NSError *error) {
                if (error)
                {
                    [MBProgressHUD showError:@"超时"];
                }
            }];
        }
        
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //点击后跳转页面
        SelDoctorVC *vc = [[SelDoctorVC alloc]init];
        vc.hospital = self.hospital;
        vc.depts = self.rightDepts[indexPath.row];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


@end
