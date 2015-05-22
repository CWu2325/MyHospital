//
//  SelHospitalVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/28.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "SelHospitalVC.h"
#import "AppointmentCell.h"
#import "Hospital.h"
#import "Area.h"
#import "MyTitleButton.h"
#import "HeaderView.h"
#import "TEXTLabel.h"
#import "SelDeptVC.h"
#import "SelAreaVC.h"
#import "AppDelegate.h"
#import "NoNetworkView.h"
#import "HttpTool.h"
#import "JsonParser.h"

@interface SelHospitalVC ()<UITableViewDataSource,UITableViewDelegate,MyProtocol>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *hospitals;

@property(nonatomic,strong)Area *area;
@property(nonatomic,copy)NSString *areaName;            //通过本界面的选择城市获取的城市名称

@property(nonatomic)AppDelegate *appDlg;

@property(nonatomic,strong)NoNetworkView *noNetView;

@property(nonatomic,strong)NSMutableDictionary *params;

@property(nonatomic,strong)UILabel *footerLabel;

@end

@implementation SelHospitalVC

-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        
        [self.view addSubview:_noNetView];
    }
    return _noNetView;
}

-(void)passValue:(Area *)area
{
    self.area = area;
    self.areaName = area.areaName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 32)];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LCWBackgroundColor;
    
    

    
}

/**
 *  判断网络情况
 */
-(void)judgeNetWork
{
    //判断网络连接
    self.appDlg = [[UIApplication sharedApplication] delegate];
    if (self.appDlg.isReachable)
    {
        
        self.noNetView.hidden = YES;
        [self requestDataWithParams:self.params];
    }
    else
    {
        
        self.noNetView.hidden = NO;
        [self.view bringSubviewToFront:self.noNetView];
        
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置标题
    [self setHeaderTitle];
    
    //判断网络情况
    [self judgeNetWork];

}

/**
 *
 */
-(void)setHeaderTitle
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *title1 = nil;
    if (self.areaName)
    {
        title1 = self.areaName;
        [params setObject:self.areaName forKey:@"areaName"];
    }
    else
    {
        title1 = self.selCityName;
        if (self.selCityName)
        {
            [params setObject:self.selCityName forKey:@"areaName"];
        }
        
    }
    
    self.params = params;
    
    NSString *title = [NSString stringWithFormat:@"预约挂号-%@",title1];
    MyTitleButton *btn = [[MyTitleButton alloc]init];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    CGSize size = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(WIDTH, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size;
    btn.height = size.height;
    btn.width = size.width + btn.height;      //文本的宽度 + 图片的宽度
    
    //设置图标
    [btn setImage:[UIImage imageNamed:@"xiajiantou@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
    
    
    //添加底部标签
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 32 - 64, WIDTH, 32)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 32)];
    label.font = [UIFont systemFontOfSize:12];
    NSString *editStr = [NSString stringWithFormat:@"%d",self.hospitals.count];
    NSString *allStr = [NSString stringWithFormat:@"共 %@ 家医院",editStr];
    NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc]initWithString:allStr];
    [text0 addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
    label.attributedText = text0;
    label.textAlignment = NSTextAlignmentCenter;
    label.size = [XyqsTools getSizeWithText:label.text andFont:label.font];
    label.centerX = bottomView.width/2;
    label.centerY = bottomView.height/2;
    self.footerLabel = label;
    [bottomView addSubview:label];

}



/**
 *  设置网络请求
 */
-(void)requestDataWithParams:(NSMutableDictionary *)params
{
   
    [HttpTool get:@"http://14.29.84.4:6060/0.1/area/getId" params:params success:^(id repsonseObj) {
        if (repsonseObj)
        {
            self.noNetView.hidden = YES;
            if ([[repsonseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                NSDictionary *dataDic = [repsonseObj objectForKey:@"data"];
                NSInteger areaID = [[dataDic objectForKey:@"areaId"] integerValue];
                
                NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
                [params2 setObject:@(areaID) forKey:@"areaId"];
                [HttpTool get:@"http://14.29.84.4:6060/0.1/hospital/list" params:params2 success:^(id responseObj2) {
                    if (responseObj2)
                    {
                        self.noNetView.hidden = YES;
                        if ([[responseObj2 objectForKey:@"returnCode"] isEqual:@(1001)])
                        {
                            NSDictionary *dataDic = [responseObj2 objectForKey:@"data"];
                            self.hospitals = [JsonParser parseHospitalByDictionary:dataDic];

                            NSString *editStr = [NSString stringWithFormat:@"%d",self.hospitals.count];
                            NSString *allStr = [NSString stringWithFormat:@"共 %@ 家医院",editStr];
                            NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc]initWithString:allStr];
                            [text0 addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
                            self.footerLabel.attributedText = text0;
          
                            [self.tableView reloadData];
                           
                        }
                        else
                        {
                            self.hospitals = [NSMutableArray array];
                            NSString *editStr = [NSString stringWithFormat:@"%d",self.hospitals.count];
                            NSString *allStr = [NSString stringWithFormat:@"共 %@ 家医院",editStr];
                            NSMutableAttributedString *text0 = [[NSMutableAttributedString alloc]initWithString:allStr];
                            [text0 addAttribute:NSForegroundColorAttributeName value:LCWBottomColor range:[allStr rangeOfString:editStr]];
                            self.footerLabel.attributedText = text0;
                            [self.tableView reloadData];
                            [MBProgressHUD showError:[responseObj2 objectForKey:@"message"]];
                        }
                    }
                } failure:^(NSError *error2) {
                    if (error2)
                    {
                        self.noNetView.hidden = NO;
                    }
                }];
            }
            else
            {
                [MBProgressHUD showError:[repsonseObj objectForKey:@"message"]];
            }
        }
    } failure:^(NSError *error) {
        if (error)
        {
            self.noNetView.hidden = NO;
        }
    }];

}


/**
 *  点击选择城市按钮
 */
-(void)selCity
{
    SelAreaVC *vc = [[SelAreaVC alloc]init];
    vc.delegate = self;
    vc.locationCityName = self.locationCityName;            //传递自动定位的值
    [self.navigationController pushViewController:vc animated:YES];
    
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hospitals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDENTIFIER = @"Cell";
    AppointmentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    
    if (!cell)
    {
        cell = [[AppointmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    Hospital *h = self.hospitals[indexPath.row];
    cell.hospital = h;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [HeaderView getViewWithText:@"选择医院" andImage:@"椭圆1@2x.png" text:@"选择科室" andImage:@"椭圆2@2x.png" text:@"选择医生" andImage:@"椭圆2@2x.png" andTextColor:MYSELCOLOR andTextColor:MYSELCOLOR andTextColor:MYSELCOLOR];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelDeptVC *vc = [[SelDeptVC alloc]init];
    Hospital *hospital = self.hospitals[indexPath.row];
    vc.hospital = hospital;
    [self.navigationController pushViewController:vc animated:NO];
    
}




@end
