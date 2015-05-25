//
//  MyAttentionVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyAttentionVC.h"
#import "MyAttentionCell.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "SelTimeVC.h"
#import "AppDelegate.h"
#import "TimeoutView.h"

@interface MyAttentionVC ()<UITableViewDataSource,UITableViewDelegate,TimeOutDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *myAttentionArr;

@property(nonatomic,strong)UIView *noNetworkView;
@property(nonatomic)AppDelegate *appDlg;
@property(nonatomic,strong)TimeoutView *timeOutView;
@end

@implementation MyAttentionVC

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



-(NSMutableArray *)myAttentionArr
{
    if (!_myAttentionArr)
    {
        _myAttentionArr = [NSMutableArray array];
    }
    return _myAttentionArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    self.view.backgroundColor = LCWBackgroundColor;
    self.navigationItem.rightBarButtonItem = nil;
    
    //初始化界面
    [self initUI];
    
    //初始化无网
    [self setupNoNetWorkView];
    
    //判断网络
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
 *  网络请求
 */
-(void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [params setObject:@(10) forKey:@"limit"];
    [params setObject:@(0) forKey:@"offset"];
    //获取关注的医生列表
    [HttpTool get:@"http://14.29.84.4:6060/0.1/myfollow/doctor" params:params success:^(id responseObj) {
        self.timeOutView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            self.myAttentionArr = [JsonParser parseAttentionDoctorByDictionary:responseObj];
            [self.tableView reloadData];
            if (self.myAttentionArr.count == 0)
            {
                [MBProgressHUD showSuccess:@"暂未关注任何医生"];
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


//初始化界面
-(void)initUI
{
    //
    UISegmentedControl *segmentC = [[UISegmentedControl alloc]initWithItems:@[@"关注的医生",@"关注的医院"]];
    segmentC.frame = CGRectMake(0, 15, 240, 30);
    segmentC.centerX = self.view.centerX;
    segmentC.selectedSegmentIndex = 0;
    segmentC.tintColor = LCWBottomColor;
    [segmentC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [segmentC addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentC];
    
    //分割线
    UIView *view = [[UIView alloc]init];
    view.x = 0;
    view.y = segmentC.maxY + 14;
    view.width = WIDTH;
    view.height = 1;
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.x = 0;
    self.tableView.y = segmentC.maxY + 15;
    self.tableView.width = WIDTH;
    self.tableView.height = HEIGHT - self.tableView.y;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = LCWBackgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex)
    {
        case 0:
        {
            self.tableView.hidden = NO;
        }
            break;
        case 1:
        {
            self.tableView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myAttentionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[MyAttentionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.att = self.myAttentionArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionDoctor *att = self.myAttentionArr[indexPath.row];
    SelTimeVC *vc = [[SelTimeVC alloc]init];
    vc.att = att;
    vc.formWhere = @"attention";
    [self.navigationController pushViewController:vc animated:NO];
}

@end
