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
#import "TimeoutView.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "CacheDic.h"

@interface SelHospitalVC ()<UITableViewDataSource,UITableViewDelegate,MyProtocol,TimeOutDelegate>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *hospitals;

@property(nonatomic,strong)Area *area;
@property(nonatomic,copy)NSString *areaName;            //通过本界面的选择城市获取的城市名称

@property(nonatomic)AppDelegate *appDlg;
@property(nonatomic,strong)TimeoutView *timeOutView;


@property(nonatomic,strong)NSMutableDictionary *params;

@property(nonatomic,strong)UILabel *footerLabel;

@property(nonatomic,strong)UIView *noNetworkView;

@property(nonatomic,strong)MyTitleButton *btn;      //标题导航栏



@end

@implementation SelHospitalVC
-(NSMutableArray *)hospitals
{
    if (!_hospitals)
    {
        _hospitals = [NSMutableArray array];
    }
    return _hospitals;
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
        [self requestDataWithParams:self.params];
    }
    else
    {
        [MBProgressHUD showError:@"网络不给力，请稍后再试！"];
        self.timeOutView.hidden = NO;
    }
}


-(void)passValue:(Area *)area
{
    self.area = area;
    self.areaName = area.areaName;
    
    [self setHeaderTitle];
    
    [self judgeNetWork];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LCWBackgroundColor;
    
    //设置标题
    [self setHeaderTitle];
    
    //设置无网络视图
    [self setupNoNetWorkView];
    
    //判断网络情况
    [self judgeNetWork];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    //设置标题
//    [self setHeaderTitle];
//    
//    //设置无网络视图
//    [self setupNoNetWorkView];
//    
//    //判断网络情况
//    [self judgeNetWork];
   
    
}



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
        [self requestDataWithParams:self.params];
    }
    else
    {
        self.noNetworkView.hidden = NO;
        [MBProgressHUD showError:@"亲~请检查您的网络连接"];
    }
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
        
        self.noNetworkView.hidden = YES;
       [self requestDataWithParams:self.params];
    }
    else
    {
        
        self.noNetworkView.hidden = NO;
        [self.noNetworkView bringSubviewToFront:self.view];
        
    }
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
    self.btn = btn;
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
            if ([[repsonseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                NSDictionary *dataDic = [repsonseObj objectForKey:@"data"];
                NSInteger areaID = [[dataDic objectForKey:@"areaId"] integerValue];
                
                NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
                [params2 setObject:@(areaID) forKey:@"areaId"];
                [HttpTool get:@"http://14.29.84.4:6060/0.1/hospital/list" params:params2 success:^(id responseObj2) {
                        self.timeOutView.hidden = YES;
                        if ([[responseObj2 objectForKey:@"returnCode"] isEqual:@(1001)])
                        {
                            self.hospitals = [JsonParser parseHospitalByDictionary:responseObj2];

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
                } failure:^(NSError *error2) {
                    if (error2)
                    {
                        self.timeOutView.hidden = NO;
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
            self.timeOutView.hidden = NO;
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
