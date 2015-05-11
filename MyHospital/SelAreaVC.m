//
//  SelAreaVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/28.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SelAreaVC.h"
#import "Area.h"
#import "XyqsApi.h"
#import "TEXTLabel.h"

@interface SelAreaVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;


@property(nonatomic,strong)NSMutableArray *leftArea;
@property(nonatomic,strong)NSMutableArray *rightArea;

@end

@implementation SelAreaVC

-(NSMutableArray *)leftArea
{
    if (!_leftArea)
    {
        _leftArea = [NSMutableArray array];
    }
    return _leftArea;
}

-(NSMutableArray *)rightArea
{
    if (!_rightArea)
    {
        _rightArea = [NSMutableArray array];
    }
    return _rightArea;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"切换城市";
    
    //初始化表格
    [self initTable];
    
    
    //初始化顶部标题
    [self initTopTitle];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(0) forKey:@"parentId"];
    //先请求数据
    [XyqsApi requestCitiesListwithparams:params andCallBack:^(id obj) {
        self.leftArea = obj;
        [self.leftTableView reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"leftIndexPathRow"] != (NSString *)[NSNull null])
        {
            indexPath = [NSIndexPath indexPathForRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"leftIndexPathRow"] integerValue] inSection:0];
        }
        else
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        [self tableView:self.leftTableView didSelectRowAtIndexPath:indexPath];
        [self.leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }];
    
}

/**
 *  初始化表格
 */
-(void)initTable
{
    UITableView *leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44,WIDTH/2, HEIGHT)];
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


/**
 *  初始化自动定位的标题和按钮
 */
-(void)initTopTitle
{
    //初始化title
    UILabel *titleLabel;
    
    if (self.locationCityName)
    {
        NSString *title = [NSString stringWithFormat:@"当前位置 %@ (自动定位)",self.locationCityName];
        titleLabel = [[TEXTLabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) WithAllString:title WithEditString:self.locationCityName WithColor:[UIColor blackColor] WithFont:[UIFont systemFontOfSize:15]];
    }
    else
    {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        titleLabel.text = @"自动定位失败,请手动选择城市";
        titleLabel.font = [UIFont systemFontOfSize:15];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerY = 22;
    titleLabel.centerX = self.view.centerX;
    titleLabel.userInteractionEnabled = YES;
    [self.view addSubview:titleLabel];
    
    
    //分割线
    UIView *view1 = [[UIView alloc]init];
    view1.x = 0;
    view1.y = 43;
    view1.width = WIDTH;
    view1.height = 1;
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    
    //添加按钮覆盖title
    UIButton *titleBtn = [[UIButton alloc]init];
    titleBtn.x = 0;
    titleBtn.y = 0;
    titleBtn.width = WIDTH;
    titleBtn.height = 43;
    [titleBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:0.5]] forState:UIControlStateHighlighted];
    [self.view addSubview:titleBtn];
    
}

/**
 *  反向传值
 */
-(void)onClick
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.locationCityName)
    {
        //保存用户选择的城市信息
        [[NSUserDefaults standardUserDefaults] setObject:self.locationCityName forKey:@"selCityName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [params setObject:self.locationCityName forKey:@"areaName"];
        [XyqsApi getCityIDWithCityNameDic:params andCallback:^(id obj) {
            Area *a = [[Area alloc]init];
            a.areaName = self.locationCityName;
            a.areaID = [obj longValue];
            [self.delegate passValue:a];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [MBProgressHUD showError:@"自动定位失败，请手动选择城市"];
    }
}

#pragma mark -UITableViewDataSource数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView)
    {
        return self.leftArea.count;
    }
    else
    {
        return self.rightArea.count;
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

        Area *a = self.leftArea[indexPath.row];
        cell.textLabel.text = a.areaName;
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
        Area *a = self.rightArea[indexPath.row];
        cell.textLabel.text = a.areaName;
        
        if (a.areaID == [[NSUserDefaults standardUserDefaults] integerForKey:@"right"])
        {
            UIImageView *locationIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei2.png"]];
            locationIV.frame = CGRectMake(0, 0,16, 20);
            cell.accessoryView = locationIV;
        }
        else
        {
            cell.accessoryView = nil;
            //cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (tableView == self.leftTableView)
    {
        NSString *leftIndexPathRow = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [ud setObject: leftIndexPathRow forKey:@"leftIndexPathRow"];
        [ud synchronize];
        
        Area *a = self.leftArea[indexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(a.areaID) forKey:@"parentId"];
        //先请求数据
        [XyqsApi requestCitiesListwithparams:params andCallBack:^(id obj) {
            self.rightArea = obj;
            [self.rightTableView reloadData];
        }];
    }
    else
    {
        Area *a = self.rightArea[indexPath.row];
        
        [self.delegate passValue:a];
        
        [ud setObject: a.areaName forKey:@"selCityName"];
        
        //保存用户选择的城市信息
        [ud setInteger:a.areaID forKey:@"right"];
        [ud synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
