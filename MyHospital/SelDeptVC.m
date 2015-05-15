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
#import "XyqsApi.h"
#import "SelDoctorVC.h"

@interface SelDeptVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;

@property(nonatomic,strong)NSMutableArray *leftDepts;
@property(nonatomic,strong)NSMutableArray *rightDepts;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约挂号";
    
    //初始化顶部视图
    [self initHeaderview];
    
    //初始化表格
    [self initTable];
    
    //请求数据
    NSMutableDictionary *params0 = [NSMutableDictionary dictionary];
    [params0 setObject:@(0) forKey:@"deptId"];      //默认从0
    [params0 setObject:@(self.hospital.hospitalID) forKey:@"hpId"];
    [XyqsApi requestDeptsWithParams:params0 andCallBack:^(id obj) {
        self.leftDepts = obj;
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
            [XyqsApi requestDeptsWithParams:params1 andCallBack:^(id obj) {
                self.rightDepts = obj;
                if (self.rightDepts.count > 0)
                {
                    self.rightTableView.hidden = NO;
                    [self.rightTableView reloadData];
                }
                else
                {
                    self.rightTableView.hidden = YES;
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
