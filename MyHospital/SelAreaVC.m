//
//  SelAreaVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/28.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SelAreaVC.h"
#import "Area.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "TEXTLabel.h"
#import "NoNetworkView.h"
#import "AppDelegate.h"

@interface SelAreaVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *leftTableView;
@property(nonatomic,strong)UITableView *rightTableView;


@property(nonatomic,strong)NSMutableArray *leftArea;
@property(nonatomic,strong)NSMutableArray *rightArea;

@property(nonatomic,strong)NoNetworkView *noNetView;



@end

@implementation SelAreaVC
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
    [super viewWillAppear:animated];
    
   
}

/**
 *  网络请求
 */
-(void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(0) forKey:@"parentId"];
    
    //先请求数据
    [HttpTool get:@"http://14.29.84.4:6060/0.1/area/list" params:params success:^(id responseObj) {
        self.noNetView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            self.leftArea = [JsonParser parseAreaByDictionary:responseObj];
            [self.leftTableView reloadData];
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
    
    //判断网络情况
    [self judgeNetWork];
}



/**
 *  判断网络情况
 */
-(void)judgeNetWork
{
    //网络请求
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
        
        [self saveAreaID:self.locationCityName];
        
        //根据城市名称返回城市ID
        [HttpTool get:@"http://14.29.84.4:6060/0.1/area/getId" params:params success:^(id responseObj) {
            self.noNetView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                Area *a = [[Area alloc]init];
                a.areaName = self.locationCityName;
                NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                a.areaID  = [[dataDic objectForKey:@"areaId"] longValue];
           
                [self.delegate passValue:a];
                
                
                
                [self.navigationController popViewControllerAnimated:NO];
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
        [MBProgressHUD showError:@"自动定位失败，请手动选择城市"];
    }
}

/**
 *  点击自动定位需要保存城市的ID，偏于下一次进来的定位图片显示的位置
 */
- ( void ) saveAreaID:(NSString *)name
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:name forKey:@"areaName"];
    //根据城市名称返回城市ID
    [HttpTool get:@"http://14.29.84.4:6060/0.1/area/getId" params:params success:^(id responseObj) {
        self.noNetView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [responseObj objectForKey:@"data"];
            NSInteger areaID  = [[dataDic objectForKey:@"areaId"] longValue];
            NSInteger parentId  = [[dataDic objectForKey:@"parentId"] longValue];
            
            //保存用户选择的城市信息
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:areaID forKey:@"right"];
            [ud setInteger:parentId forKey:@"left"];
            [ud synchronize];
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
        
        UIView *backView = [[UIView alloc]initWithFrame:cell.bounds];
        backView.backgroundColor = [UIColor colorWithRed:232.0/255 green:235.0/255 blue:234.0/255 alpha:1];
        cell.backgroundView = backView;
        
        UIView *selBackView = [[UIView alloc]initWithFrame:cell.bounds];
        selBackView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selBackView;
        if (a.areaID == [[NSUserDefaults standardUserDefaults] integerForKey:@"left"])
        {
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        

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
        
        
        Area *a = self.leftArea[indexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(a.areaID) forKey:@"parentId"];
        

        
        [ud setInteger:a.areaID forKey:@"left"];
        [ud synchronize];
        //先请求数据
        [HttpTool get:@"http://14.29.84.4:6060/0.1/area/list" params:params success:^(id responseObj) {
            self.noNetView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                self.rightArea = [JsonParser parseAreaByDictionary:responseObj];
                [self.rightTableView reloadData];
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
        Area *a = self.rightArea[indexPath.row];
        
        [self.delegate passValue:a];
        
        [ud setObject: a.areaName forKey:@"selCityName"];

        //保存用户选择的城市信息
        [ud setInteger:a.areaID forKey:@"right"];
        [ud synchronize];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
