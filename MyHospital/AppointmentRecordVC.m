//
//  AppointmentRecordVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppointmentRecordVC.h"
#import "AppRecordCell.h"
#import "XyqsApi.h"
#import "OrderRecord.h"
#import "OrderDetailVC.h"
#import "NoNetworkView.h"
#import "AppDelegate.h"
#import "PayWebVC.h"

@interface AppointmentRecordVC ()<MyTableViewCellDelegate>

@property(nonatomic,strong)NSMutableArray *recordDatas;

@property(nonatomic)int limit;
@property(nonatomic)int offset;

@property(nonatomic,strong)UIRefreshControl *refreshControl;

@property(nonatomic,strong)NoNetworkView *noNetView;
@end

@implementation AppointmentRecordVC
-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        [self.view addSubview:_noNetView];
    }
    return _noNetView;
}


-(NSMutableArray *)recordDatas
{
    if (!_recordDatas)
    {
        _recordDatas = [NSMutableArray array];
    }
    return _recordDatas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约记录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LCWBackgroundColor;
    self.navigationItem.rightBarButtonItem = nil;
    
    self.limit = 0;
    self.offset = 0;

    
}

/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    
    [refreshControl addTarget:self action:@selector(refreshControl:) forControlEvents:UIControlEventValueChanged];
    
    [refreshControl beginRefreshing];
    
    [self refreshControl:refreshControl];
}

/**
 *  下拉刷新事件
 */
-(void)refreshControl:(UIRefreshControl *)refreshControl
{

}




-(void)viewWillAppear:(BOOL)animated
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
    self.limit += 10;
    self.offset = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
    [params setObject:@(self.limit) forKey:@"limit"];
    [params setObject:@(self.offset) forKey:@"offset"];

    
    [XyqsApi requestOrderRecordListWithParams:params andCallBack:^(id obj) {
        self.recordDatas = obj;
        [self.tableView reloadData];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[AppRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    OrderRecord *orderList = self.recordDatas[indexPath.row];
    cell.orderList = orderList;
    cell.delegate = self;

    return cell;
}

/**
 *  实现自定义cell的button的代理事件
 */
-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderRecord *orderList = self.recordDatas[indexPath.row];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [params setValue:token forKey:@"token"];
    [params setValue:@(orderList.orderListID) forKey:@"oid"];
    [XyqsApi payWithparams:params andCallBack:^(id obj) {
        [self saveHtmlfile:obj];
        PayWebVC *webVC = [[PayWebVC alloc]init];
        [self.navigationController pushViewController:webVC animated:NO];
    }];

}

/**
 *  写html文件并保持在沙盒中
 */
-(void)saveHtmlfile:(NSString *)text
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"pay.html"];
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderRecord *orderList = self.recordDatas[indexPath.row];
    OrderDetailVC *vc = [[OrderDetailVC alloc]init];
    vc.orderList = orderList;
    vc.title = @"预约记录详情";
    [self.navigationController pushViewController:vc animated:NO];
}




@end
