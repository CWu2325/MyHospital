//
//  FirstPageVC.m
//  MyHospital
//
//  Created by XYQS on 15/5/14.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "FirstPageVC.h"
#import <CoreLocation/CoreLocation.h>
#import "SelAreaVC.h"
#import "SelHospitalVC.h"
#import "Area.h"
#import "MyLeftBtn.h"
#import "MyFirstPageBtn.h"
#import "MyFBtn2.h"
#import "AppDelegate.h"


@interface FirstPageVC ()<CLLocationManagerDelegate,MyProtocol,UIScrollViewDelegate>

@property(nonatomic,strong)CLLocationManager *locMgr;       //自动定位管理器

@property(nonatomic,copy)NSString *selCityName;         //用户选择的城市名称
@property(nonatomic,copy)NSString *locationCityName;                //自动定位的城市名称

@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,strong)NSArray *svImages;

@end
                                    ///Users/apple1/Desktop/5.html



@implementation FirstPageVC

-(void)passValue:(Area *)area
{
    self.selCityName = area.areaName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //开始定位
    AppDelegate *appDlg = [UIApplication sharedApplication].delegate;
    if (appDlg.isReachable)
    {
        [self.locMgr startUpdatingLocation];
    }
    
    
    self.svImages = @[@"sv01.jpg",@"sv02.jpg",@"sv03.jpg",@"sv04.jpg",@"sv05.jpg"];
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleLabel.text = @"就医无忧";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = LCWBackgroundColor;
    
    //滑动窗口
    [self addSV];
    
    //添加按钮
    [self addBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightBtn setImage:[UIImage imageNamed:@"xiaoxi.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    NSString *cityName = nil;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"selCityName"])
    {
        //先读取系统中是否有存储上次登录的城市信息
        cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"selCityName"];
    }
    else
    {
        if (self.locationCityName)
        {
            cityName = self.locationCityName;
        }
        else
        {
            cityName = @"深圳";
        }
    }
    self.selCityName = cityName;
    cityName = [[cityName componentsSeparatedByString:@"市"] firstObject];
    MyLeftBtn *leftBtn = [[MyLeftBtn alloc]init];
    leftBtn.x = 0;
    leftBtn.y = 0;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.height = 22;
    leftBtn.width = 22 + [XyqsTools getSizeWithText:cityName andFont:[UIFont systemFontOfSize:14]].width + 5;
    [leftBtn setImage:[UIImage imageNamed:@"dingwei.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(selCity) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:cityName forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
}

/*
 * 点击城市的事件
 */
-(void)selCity
{
    SelAreaVC *vc = [[SelAreaVC alloc]init];
    vc.delegate = self;
    vc.locationCityName = self.locationCityName;
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)rightBtnAction
{
    [MBProgressHUD showError:@"功能待完善"];
}


-(void)addBtn
{
    CGFloat width2 = WIDTH/2;
    CGFloat width3 = WIDTH/3;
    
    NSArray *titles = @[@"挂号",@"导诊",@"候诊叫号",@"付款缴费",@"检验报告"];
    NSArray *lable2Text = @[@"提前预约省时省心",@"找对科室医生"];
    for (int i = 0; i < 2; i++)
    {
        MyFirstPageBtn *btn1 = [[MyFirstPageBtn alloc]initWithFrame:CGRectMake(i * width2, 136, width2, 120)];
        btn1.tag = i;
        [btn1 setTitle:titles[i] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"firstPageBtn0%d.png",i+1]] forState:UIControlStateNormal];
        btn1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:btn1];
        
        UIImageView *diviIv3 = [[UIImageView alloc]initWithFrame:CGRectMake(btn1.x, btn1.y, 1, btn1.height)];
        diviIv3.backgroundColor = LCWBackgroundColor;
        [self.view addSubview:diviIv3];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = lable2Text[i];
        label1.textColor = [UIColor lightGrayColor];
        label1.font = [UIFont systemFontOfSize:11];
        label1.size = [XyqsTools getSizeWithText:label1.text andFont:label1.font];
        label1.x = (width2 - label1.width)/2;
        label1.y = btn1.height - 21 - label1.height;
        [btn1 addSubview:label1];
        
        
    }
    
    
    for (int i = 0 ; i < 3; i++)
    {
        MyFBtn2 *btn2 = [[MyFBtn2 alloc]initWithFrame:CGRectMake(i * width3, 136 + 120+1, width3, 106)];
        btn2.tag = i;
        [btn2 setTitle:titles[i + 2] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"firstPageBtn0%d.png",i+3]] forState:UIControlStateNormal];
        btn2.backgroundColor = [UIColor whiteColor];
        [btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn2];
        
        UIImageView *diviIv4 = [[UIImageView alloc]initWithFrame:CGRectMake(btn2.x, btn2.y, 1, btn2.height)];
        diviIv4.backgroundColor = LCWBackgroundColor;
        [self.view addSubview:diviIv4];
    }
}

/**
 *  后面的按钮事件
 */
-(void)btn2Action:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [MBProgressHUD showError:@"功能待完善"];
        }
            break;
        case 1:
        {
            [MBProgressHUD showError:@"功能待完善"];
        }
            break;
        case 2:
        {
            [MBProgressHUD showError:@"功能待完善"];
        }
            break;
        default:
            break;
    }
}

/**
 *  首页前两个but事件
 */
-(void)btn1Action:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            SelHospitalVC *vc = [[SelHospitalVC alloc]init];
            vc.selCityName = self.selCityName;
            vc.locationCityName = self.locationCityName;
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
        case 1:
        {
            [MBProgressHUD showError:@"功能待完善"];
        }
            break;
        default:
            break;
    }
}

/**
 *  添加滑动窗口
 */
-(void)addSV
{
    UIScrollView *baseSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,136)];
    for (int i = 0; i < self.svImages.count; i++)
    {
        UIImage *image = [UIImage imageNamed:self.svImages[i]];
        
        UIImageView *svImageV = [[UIImageView alloc]initWithImage:image];
        svImageV.x = i * baseSv.width;
        svImageV.y = 0;
        svImageV.width = baseSv.width;
        svImageV.height = baseSv.height;
        [baseSv addSubview:svImageV];
    }
    baseSv.contentSize = CGSizeMake(baseSv.width * self.svImages.count, 0);
    baseSv.pagingEnabled = 5.14;
    baseSv.delegate = self;
    baseSv.showsHorizontalScrollIndicator = NO;
    baseSv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:baseSv];
    
    //创建pangecontroller的大小
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH - 70, baseSv.maxY - 25 , 50, 25)];
    pageControl.numberOfPages = self.svImages.count;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

/**
 *  添加一个事件方法 划动图片
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //得到视图划动时的偏移量
    CGPoint offset = scrollView.contentOffset;
    //NSLog(@"scrollView offset x:%f y:%f",offset.x,offset.y);
    //偏移量不足0时 当它为0
    if (offset.x <= 0)
    {
        offset.x = 0;
        scrollView.contentOffset = offset;
    }
    //得到当前界面的序号 四舍五入
    NSInteger index = round(offset.x/scrollView.frame.size.width);
    //根据偏移量得到当前界面的序号 并赋值 改变颜色
    self.pageControl.currentPage = index;
}


#pragma mark - 定位
-(CLLocationManager *)locMgr        //定位管理区
{
    if (!_locMgr)
    {
        _locMgr = [[CLLocationManager alloc]init];
        _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        _locMgr.distanceFilter = 10;
        [_locMgr requestAlwaysAuthorization];
        _locMgr.delegate = self;
    }
    return _locMgr;
}

/*
 * 自动定位
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    // NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    
    CLGeocoder *revGeo = [[CLGeocoder alloc]init];
    [revGeo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && [placemarks count]>0)
        {
            NSDictionary *dic = [[placemarks objectAtIndex:0] addressDictionary];
            NSString *city = [dic objectForKey:@"City"];
            self.locationCityName =  [[city componentsSeparatedByString:@"市"] firstObject];
        }
        else
        {
            [MBProgressHUD showError:(NSString *)error];
        }
    }];
}


/*
 * 定位失败
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        [MBProgressHUD showError:@"访问被拒绝"];
        
    }
    if ([error code] == kCLErrorLocationUnknown)
    {
        //无法获取位置信息
        [MBProgressHUD showError:@"无法获取位置信息"];
    }
}

/*
 * 页面消失时关闭自动定位
 */
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //在本页面关闭后,关闭自动定位
    [self.locMgr stopUpdatingLocation];
}

@end
