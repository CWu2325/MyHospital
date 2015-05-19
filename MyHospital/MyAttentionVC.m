//
//  MyAttentionVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyAttentionVC.h"
#import "MyAttentionCell.h"
#import "XyqsApi.h"
#import "SelTimeVC.h"
#import "AppDelegate.h"
#import "NoNetworkView.h"

@interface MyAttentionVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *myAttentionArr;

@property(nonatomic,strong)NoNetworkView *noNetView;
@end

@implementation MyAttentionVC

-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        
        [self.view addSubview:_noNetView];
        
    }
    return _noNetView;
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [params setObject:@(10) forKey:@"limit"];
    [params setObject:@(0) forKey:@"offset"];
    [XyqsApi requestAttentionDoctorListwithparams:params andCallBack:^(id obj) {
        self.myAttentionArr = obj;
        [self.tableView reloadData];
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





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
