//
//  SelDoctorVC.m
//  MyHospital
//
//  Created by XYQS on 15/5/5.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SelDoctorVC.h"
#import "XyqsApi.h"
#import "Doctor.h"
#import "TEXTLabel.h"
#import "HeaderView.h"
#import "SelDocCell.h"
#import "SelTimeVC.h"
#import "AppDelegate.h"
#import "NoNetworkView.h"

@interface SelDoctorVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *doctors;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NoNetworkView *noNetView;
@end

@implementation SelDoctorVC

-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        
        [self.view addSubview:_noNetView];
        
    }
    return _noNetView;
}

-(void)viewWillAppear:(BOOL)animated
{
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
    //请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.depts.roomID) forKey:@"deptId"];
    [params setObject:@(self.hospital.hospitalID) forKey:@"hpId"];
    [XyqsApi requestDoctorWithParams:params andCallBack:^(id obj){
        self.doctors = obj;
        [self.tableView reloadData];
        
        //添加标签
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 32 - 64, WIDTH, 32)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        NSString *text = [NSString stringWithFormat:@"共 %d 位医生",self.doctors.count];
        TEXTLabel *footerLabel = [[TEXTLabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 32) WithAllString:text WithEditString:[NSString stringWithFormat:@"%d",self.doctors.count] WithColor:LCWBottomColor WithFont:[UIFont systemFontOfSize:12]];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.size = [XyqsTools getSizeWithText:footerLabel.text andFont:footerLabel.font];
        footerLabel.centerY = bottomView.height/2;
        footerLabel.centerX = bottomView.width/2;
        [bottomView addSubview:footerLabel];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"预约挂号";
    
    //初始化表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 32)];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LCWBackgroundColor;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *headerView = [HeaderView getViewWithText:self.hospital.name andImage:@"椭圆1@2x.png" text:self.depts.name andImage:@"椭圆1@2x.png" text:@"选择医生" andImage:@"椭圆1@2x.png" andTextColor:MYSELCOLOR andTextColor:MYSELCOLOR andTextColor:MYSELCOLOR];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.doctors.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDENTIFIER = @"Cell";
    SelDocCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (!cell)
    {
        cell =  [[SelDocCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    Doctor *d = self.doctors[indexPath.row];
    cell.doctor = d;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Doctor *doctor = self.doctors[indexPath.row];
    SelTimeVC *vc= [[SelTimeVC alloc]init];
    vc.doctor = doctor;                         //传递医生
    vc.depts = self.depts;                      //传递科室
    vc.hospital = self.hospital;                //传递医院
    [self.navigationController pushViewController:vc animated:NO];
}



@end
