//
//  SelTimeVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/9.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//


#define LCWAppointFullColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
#define LCWBtnHightColor [UIColor colorWithRed:20/255.0 green:102/255.0 blue:33/255.0 alpha:1]
#define LCWAttentionColor [UIColor colorWithRed:233/255.0 green:214/255.0 blue:49/255.0 alpha:1]

#import "SelTimeVC.h"
#import "HttpTool.h"
#import "JsonParser.h"
#import "Schedules.h"
#import "LoginViewController.h"
#import "InfoConfirmViewC.h"
#import "DoctorIntroduceView.h"
#import "SetUseInfoVC.h"
#import "NoNetworkView.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "TimeoutView.h"


@interface SelTimeVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TimeOutDelegate>

@property(nonatomic,strong)UIView *scView;      //SV里面的view
@property(nonatomic,strong)NSMutableArray *amSchedule;
@property(nonatomic,strong)NSMutableArray *pmSchedule;
@property(nonatomic,strong)Doctor *doctorDetail;        //医生排版详情带是否关注
@property(nonatomic)BOOL attentionStatus;          //关注的状态
@property(nonatomic,strong)UITableView *tableView;      //显示评论的表格
@property(nonatomic,strong)UIImageView *slideIV;        //滑块
@property(nonatomic,strong)User *user;
@property(nonatomic,strong)DoctorIntroduceView *docIntroView;       //医生简介视图
@property(nonatomic,strong)UIScrollView *baseSv;                        //滚动视图
@property(nonatomic,strong)UIButton *attentionBtn;  //关注按钮

@property(nonatomic,strong)UIPageControl *pageControl;


@property(nonatomic,strong)NoNetworkView *noNetView;
@property(nonatomic,strong)TimeoutView *timeOutView;
@property(nonatomic)AppDelegate *appDlg;

@end

@implementation SelTimeVC

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

-(NoNetworkView *)noNetView
{
    if (!_noNetView)
    {
        _noNetView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, HEIGHT)];
        [self.view addSubview:_noNetView];
    }
    return _noNetView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"医生详情";
    
    self.amSchedule = [NSMutableArray array];
    self.pmSchedule = [NSMutableArray array];
    
    //关注按钮
    if (!self.attentionBtn)
    {
        UIButton *attentionBtn = [[UIButton alloc]init];
        attentionBtn.width = 46;
        attentionBtn.height = 25;
        attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        attentionBtn.x = WIDTH - attentionBtn.width - 10;
        attentionBtn.y = 20;
        attentionBtn.layer.cornerRadius = 4;
        self.attentionBtn = attentionBtn;
        [self.attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.appDlg = [[UIApplication sharedApplication] delegate];
    if (self.appDlg.isReachable)
    {
        self.noNetView.hidden = YES;
        
        [self requestData];
    }
    else
    {
        
        self.noNetView.hidden = NO;
        [self.view bringSubviewToFront:self.noNetView];
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([XyqsTools isLogin])
    {
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
        [HttpTool get:@"http://14.29.84.4:6060/0.1/user/userinfo" params:params success:^(id responseObj) {
            self.timeOutView.hidden = YES;
            if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
            {
                NSDictionary *dataDic = [responseObj objectForKey:@"data"];
                self.user = [JsonParser parseUserByDictionary:dataDic];
                
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
}

/**
 *  网络请求
 */
-(void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([self.formWhere isEqualToString:@"attention"])
    {
        [params setObject:@(self.att.deptId) forKey:@"deptId"];
        [params setObject:@(self.att.doctId) forKey:@"doctId"];
    }
    else
    {
        [params setObject:@(self.depts.roomID) forKey:@"deptId"];
        [params setObject:@(self.doctor.doctorID) forKey:@"doctId"];
    }
    if ([XyqsTools isLogin])
    {
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    }
    
    //获取医生详情的方法
    [HttpTool post:@"http://14.29.84.4:6060/0.1/doctor/detail" params:params success:^(id responseObj) {
        self.timeOutView.hidden = YES;
        if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [responseObj objectForKey:@"data"];
            self.doctorDetail = [JsonParser parseDoctorDetailByDictionary:dataDic];
            for (Schedules *s in self.doctorDetail.schedules)
            {
                if (s.ampm == 0)
                {
                    [self.amSchedule addObject:s];
                }
                else
                {
                    [self.pmSchedule addObject:s];
                }
            }
            //布局
            [self initUI];
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


-(void)initUI
{
    UIScrollView *baseSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    baseSv.backgroundColor = LCWBackgroundColor;
    self.baseSv = baseSv;
    [self.view addSubview:baseSv];
    
    //****************************************顶部视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    topView.backgroundColor = [UIColor whiteColor];
    [baseSv addSubview:topView];
    
    //初始化头部头像
    UIImageView *docImageView = [[UIImageView alloc]init];
    docImageView.x = 10;
    docImageView.y = 15;
    docImageView.width = 60;
    docImageView.height = 60;
    [topView addSubview:docImageView];
    docImageView.layer.cornerRadius = docImageView.width/2;
    docImageView.layer.borderWidth = 0.8;
    docImageView.layer.borderColor = LCWBottomColor.CGColor;
    docImageView.layer.masksToBounds = YES;
    if (self.doctorDetail.coverUrl)
    {
        [docImageView setImageWithURL:[NSURL URLWithString:self.doctorDetail.coverUrl]];
    }
    
    //关注按钮
    if (self.doctorDetail.followed == 0)
    {
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.attentionBtn setBackgroundColor:LCWBottomColor];
        self.attentionStatus  = NO;
    }
    else
    {
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.attentionBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.attentionBtn setBackgroundColor:LCWAttentionColor];
        self.attentionStatus = YES;
    }
    
    [topView addSubview:self.attentionBtn];
    
    
    //头部医生名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = self.doctorDetail.doctorName;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.size = [XyqsTools getSizeWithText:nameLabel.text andFont:nameLabel.font];
    nameLabel.x = docImageView.maxX+ 10;
    nameLabel.y = docImageView.y + 2;
    [topView addSubview:nameLabel];
    
    //头部医生等级
    UILabel *docLevelLabel = [[UILabel alloc]init];
    docLevelLabel.text = self.doctorDetail.levelName;
    docLevelLabel.font = [UIFont systemFontOfSize:12];
    docLevelLabel.size = [XyqsTools getSizeWithText:docLevelLabel.text andFont:docLevelLabel.font];
    docLevelLabel.x = nameLabel.x;
    docLevelLabel.y = nameLabel.maxY+ 5;
    [topView addSubview:docLevelLabel];
    
    //详情描述
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = [NSString stringWithFormat:@"%@-%@",self.doctorDetail.hospitalName,self.doctorDetail.departmentName];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.size = [XyqsTools getSizeWithText:detailLabel.text andFont:detailLabel.font];
    detailLabel.x = nameLabel.x;
    detailLabel.y = docLevelLabel.maxY + 5;
    [topView addSubview:detailLabel];
    
  
    //**********************************初始化中部视图
    CGFloat diviWidth = WIDTH/8;
    UIScrollView *centerSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topView.maxY + 10, WIDTH, diviWidth *3 + 1)];
    centerSV.backgroundColor = [UIColor whiteColor];
    centerSV.delegate = self;
    centerSV.pagingEnabled = YES;
    [baseSv addSubview:centerSV];
    
    //创建承载中部滚动的view
    for (int i = 0 ; i < 2; i++)
    {
        UIView *centerView = [self getCenterViewWithTag:i];
        centerView.tag = i;
        centerView.x = i * WIDTH;
        centerView.y = 0;
        centerView.width = WIDTH;
        centerView.height = diviWidth *3;
        [centerSV addSubview:centerView];
    }
    centerSV.contentSize = CGSizeMake(WIDTH * 2, diviWidth *3);
    
    //创建pangecontroller的大小
    UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(0, centerSV.maxY, WIDTH, 25)];
    pageView.backgroundColor = [UIColor whiteColor];
    [baseSv addSubview:pageView];
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0 , WIDTH, 25)];
    pageControl.numberOfPages = 2;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    [pageView addSubview:pageControl];
    self.pageControl = pageControl;

    //**********************************底部控件
    UISegmentedControl *segmentC = [[UISegmentedControl alloc]initWithItems:@[@"医生简介",@"用户评价"]];
    segmentC.frame = CGRectMake(0, pageView.maxY+ 10, 240, 32);
    segmentC.centerX = self.view.centerX;
    segmentC.selectedSegmentIndex = 0;
    segmentC.tintColor = LCWBottomColor;
    [segmentC setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [segmentC addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [baseSv addSubview:segmentC];
    
    if (!self.docIntroView)
    {
        DoctorIntroduceView *docIntroView = [[DoctorIntroduceView alloc]initWithFrame:CGRectMake(0, segmentC.maxY +10, WIDTH, HEIGHT)];
        self.docIntroView = docIntroView;
        docIntroView.backgroundColor = [UIColor whiteColor]; 
    }
    self.docIntroView.doctor = self.doctorDetail;
    [baseSv addSubview:self.docIntroView];
    
    //***********************************创建评价表
    if (!self.tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.docIntroView.frame];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.hidden = YES;
        self.tableView = tableView;
        [baseSv addSubview:tableView];
    }
    baseSv.contentSize = CGSizeMake(WIDTH,segmentC.maxY +10 + 64 + [self getIntroHeight]);
}

/**
 *  得到初始化中部视图
 */
-(UIView *)getCenterViewWithTag:(int)tag
{
    CGFloat diviWidth = WIDTH/8;
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, diviWidth *3)];
    
    
    for (int i = 0 ; i < 8; i++)
    {
        
        
        if (i == 0)
        {
            UILabel *amLabel = [[UILabel alloc]init];
            amLabel.text = @"上午";
            amLabel.font = [UIFont systemFontOfSize:15];
            amLabel.x = 0;
            amLabel.y = diviWidth;
            amLabel.width = diviWidth;
            amLabel.height = diviWidth;
            [centerView addSubview:amLabel];
            
            UILabel *pmLabel = [[UILabel alloc]init];
            pmLabel.text = @"下午";
            pmLabel.font = [UIFont systemFontOfSize:15];
            pmLabel.x = 0;
            pmLabel.y = 2 *diviWidth;
            pmLabel.size = amLabel.size;
            [centerView addSubview:pmLabel];
        }
        else
        {
            
            //星期标签
            UILabel *weakLabel = [[UILabel alloc]init];
            weakLabel.x = i * diviWidth;
            weakLabel.y = 0;
            weakLabel.width = diviWidth;
            weakLabel.height = diviWidth/2;
            weakLabel.textAlignment = NSTextAlignmentCenter;
            weakLabel.font = [UIFont systemFontOfSize:11];
            [centerView addSubview:weakLabel];
            
            //日期标签
            UILabel *dateLabel = [[UILabel alloc]init];
            dateLabel.x = i * diviWidth;
            dateLabel.y = weakLabel.maxY;
            dateLabel.width = diviWidth;
            dateLabel.height = diviWidth/2;
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.font = [UIFont systemFontOfSize:9];
            [centerView addSubview:dateLabel];
            
            
            //上午的btn
            UIButton *amBtn = [[UIButton alloc]init];
            amBtn.size = CGSizeMake(diviWidth, diviWidth);
            amBtn.tag = i;
            amBtn.x = weakLabel.x;
            amBtn.y = diviWidth;
            amBtn.enabled = NO;
            amBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            
            [amBtn addTarget:self action:@selector(amBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [centerView addSubview:amBtn];
            
            //下午的btn
            UIButton *pmBtn = [[UIButton alloc]init];
            pmBtn.tag = i;
            pmBtn.enabled = NO;
            pmBtn.titleLabel.font = amBtn.titleLabel.font;
            pmBtn.x = amBtn.x;
            pmBtn.y = diviWidth *2;
            pmBtn.size = amBtn.size;
            [pmBtn addTarget:self action:@selector(pmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [centerView addSubview:pmBtn];
            
            if (tag == 0)
            {
                Schedules *s1 = self.amSchedule[i-1];
                Schedules *s2 = self.pmSchedule[i-1];
                weakLabel.text = [s1.week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
                
                NSArray *dateArr = [s1.date componentsSeparatedByString:@"-"];
                NSString *date = [NSString stringWithFormat:@"%@月%@日",dateArr[1],dateArr[2]];
                dateLabel.text = date;
                if (s1.remain > 0)
                {
                    amBtn.enabled = YES;
                    [amBtn setTitle:@"预约" forState:UIControlStateNormal];
                    [amBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [amBtn setBackgroundImage:[UIImage imageWithColor:LCWBottomColor] forState:UIControlStateNormal];
                    [amBtn setBackgroundImage:[UIImage imageWithColor:LCWBtnHightColor] forState:UIControlStateHighlighted];
                    
                }
                else if(s1.remain == 0)
                {
                    amBtn.enabled = NO;
                    [amBtn setTitle:@"约满" forState:UIControlStateNormal];
                    [amBtn setBackgroundImage:[UIImage imageWithColor:LCWAppointFullColor] forState:UIControlStateNormal];
                }
                
                if (s2.remain > 0)
                {
                    pmBtn.enabled = YES;
                    [pmBtn setTitle:@"预约" forState:UIControlStateNormal];
                    [pmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [pmBtn setBackgroundImage:[UIImage imageWithColor:LCWBottomColor] forState:UIControlStateNormal];
                    [pmBtn setBackgroundImage:[UIImage imageWithColor:LCWBtnHightColor] forState:UIControlStateHighlighted];
                    
                }
                else if(s2.remain == 0)
                {
                    pmBtn.enabled = NO;
                    [pmBtn setTitle:@"约满" forState:UIControlStateNormal];
                    [pmBtn setBackgroundImage:[UIImage imageWithColor:LCWAppointFullColor] forState:UIControlStateNormal];
                }
            }
            else
            {
                Schedules *s1 = self.amSchedule[i+6];
                Schedules *s2 = self.pmSchedule[i+6];
                
                weakLabel.text = s1.week;
                NSArray *dateArr = [s1.date componentsSeparatedByString:@"-"];
                NSString *date = [NSString stringWithFormat:@"%@-%@",dateArr[1],dateArr[2]];
                dateLabel.text = date;
                if (s1.remain > 0)
                {
                    [amBtn setTitle:@"预约" forState:UIControlStateNormal];
                    [amBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
                    [amBtn setBackgroundImage:[UIImage imageWithColor:LCWBottomColor] forState:UIControlStateNormal];
                    [amBtn setBackgroundImage:[UIImage imageWithColor:LCWBtnHightColor] forState:UIControlStateHighlighted];
                    
                    amBtn.enabled = YES;
                }
                else if(s1.remain == 0)
                {
                    amBtn.enabled = NO;
                    [amBtn setTitle:@"约满" forState:UIControlStateNormal];
                    [amBtn setBackgroundImage:[UIImage imageWithColor:LCWAppointFullColor] forState:UIControlStateNormal];
                }
                
                if (s2.remain > 0)
                {
                    pmBtn.enabled = YES;
                    [pmBtn setTitle:@"预约" forState:UIControlStateNormal];
                    [pmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [pmBtn setBackgroundImage:[UIImage imageWithColor:LCWBottomColor] forState:UIControlStateNormal];
                    [pmBtn setBackgroundImage:[UIImage imageWithColor:LCWBtnHightColor] forState:UIControlStateHighlighted];
                    
                }
                else if(s2.remain == 0)
                {
                    pmBtn.enabled = NO;
                    [pmBtn setTitle:@"约满" forState:UIControlStateNormal];
                    [pmBtn setBackgroundImage:[UIImage imageWithColor:LCWAppointFullColor] forState:UIControlStateNormal];
                }
            }
            
        }
        
        
        //竖直分割线
        UIImageView *divisionIv= [[UIImageView alloc]init];
        divisionIv.backgroundColor = [UIColor lightGrayColor];
        divisionIv.x = i * diviWidth;
        divisionIv.y = 0;
        divisionIv.width = 1;
        divisionIv.height = diviWidth * 3;
        [centerView addSubview:divisionIv];
    }
    
    for (int i = 0 ; i < 4; i++)
    {
        UIImageView *horizontalIV = [[UIImageView alloc]init];
        horizontalIV.backgroundColor = [UIColor lightGrayColor];
        horizontalIV.x = 0;
        horizontalIV.y = i * diviWidth;
        horizontalIV.width = (WIDTH-diviWidth) *2;
        horizontalIV.height = 1;
        [centerView addSubview:horizontalIV];
    }
    
    return centerView;
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

/**
 *  获得docIntroduceview的高度
 */
-(CGFloat)getIntroHeight
{
    CGFloat introHeight = 0;
    
    CGFloat testHeight = [XyqsTools getSizeWithText:@"测试" andFont:[UIFont systemFontOfSize:14]].height;
    
    introHeight = 10 + testHeight + 5 + 5;
    if (self.doctorDetail.expert)
    {
        introHeight +=[XyqsTools getSizeByText:self.doctorDetail.expert andFont:[UIFont systemFontOfSize:13] andWidth:WIDTH-20].height;
    }
    
    introHeight += 30;
    introHeight += testHeight + 5 + 5;
    if (self.doctorDetail.introduction)
    {
        introHeight += [XyqsTools getSizeByText:self.doctorDetail.introduction andFont:[UIFont systemFontOfSize:13] andWidth:WIDTH-20].height + 20;
    }
    return introHeight;
}

#pragma mark - tableView -datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"测试数据";
    return cell;
}

//切换底部视图的事件
-(void)segmentAction:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 1)
    {
        //切换到评论
        self.tableView.hidden = NO;
        self.docIntroView.hidden = YES;
        self.baseSv.contentSize = CGSizeMake(WIDTH, HEIGHT + segment.maxY + 10 + 64);
    }
    else
    {
        //切换到医生简介
        self.tableView.hidden = YES;
        self.docIntroView.hidden = NO;
        self.baseSv.contentSize = CGSizeMake(WIDTH,segment.maxY +10 + 64 + [self getIntroHeight]);
    }
}


//按钮的点击事件(上午)
-(void)amBtnAction:(UIButton *)sender
{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
    {
        [MBProgressHUD showError:@"您还没登录!"];
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else if (self.user.name == (NSString *)[NSNull null])
    {
        [MBProgressHUD showError:@"请先完善您的个人资料!"];
        SetUseInfoVC *setVC = [[SetUseInfoVC alloc]init];
        setVC.title = @"完善个人资料";
        setVC.formWhere = @"set";
        [self.navigationController pushViewController:setVC animated:NO];
    }
    else
    {
        Schedules *schedules = nil;
        if (sender.superview.tag == 0)
        {
            schedules = self.amSchedule[sender.tag -1];
        }
        else
        {
            schedules = self.amSchedule[sender.tag +6];
        }
        
        InfoConfirmViewC *infoVC = [[InfoConfirmViewC alloc]init];
        infoVC.doctor = self.doctor;
        infoVC.depts = self.depts;
        infoVC.schedules = schedules;
        infoVC.hospital = self.hospital;
        infoVC.user = self.user;
        [self.navigationController pushViewController:infoVC animated:NO];
    }
}

//按钮点击事件（下午）
-(void)pmBtnAction:(UIButton *)sender
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
    {
        [MBProgressHUD showError:@"亲~您还没登录!"];
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else if (self.user.name == (NSString *)[NSNull null])
    {
        [MBProgressHUD showError:@"亲~您的资料还不完整，请先完善您的资料!"];
        SetUseInfoVC *setVC = [[SetUseInfoVC alloc]init];
        setVC.title = @"完善个人资料";
        setVC.formWhere = @"set";
        [self.navigationController pushViewController:setVC animated:NO];
    }
    else
    {
        Schedules *schedules = nil;
        if (sender.superview.tag == 0)
        {
            schedules = self.pmSchedule[sender.tag -1];
        }
        else
        {
            schedules = self.pmSchedule[sender.tag +6];
        }
        InfoConfirmViewC *infoVC = [[InfoConfirmViewC alloc]init];
        infoVC.doctor = self.doctor;
        infoVC.depts = self.depts;
        infoVC.schedules = schedules;
        infoVC.hospital = self.hospital;
        infoVC.user = self.user;
        [self.navigationController pushViewController:infoVC animated:NO];
    }
}

//关注按钮事件
-(void)attentionAction:(UIButton *)sender
{
    
    if([XyqsTools isLogin])
    {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
        [params setObject:@(self.doctorDetail.doctorID) forKey:@"doctId"];
        if (self.attentionStatus == NO)
        {
             //添加关注的医生
            [HttpTool get:@"http://14.29.84.4:6060/0.1/myfollow/addDocFollow" params:params success:^(id responseObj) {
                if (responseObj)
                {
                    self.timeOutView.hidden = YES;
                    if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
                    {
                        NSString *message = [responseObj objectForKey:@"message"];
                        if ([message isEqualToString:@"成功添加关注"])
                        {
                            [sender setTitle:@"已关注" forState:UIControlStateNormal];
                            sender.titleLabel.adjustsFontSizeToFitWidth = YES;
                            [sender setBackgroundColor:LCWAttentionColor];
                            self.attentionStatus = YES;
                        }
                        
                    }
                    else
                    {
                        [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
                    }
                }
            } failure:^(NSError *error) {
                if (error)
                {
                    self.timeOutView.hidden = NO;
                }
            }];  
        }
        else
        {
            //取消关注的医生
            [HttpTool get:@"http://14.29.84.4:6060/0.1/myfollow/delDocFollow" params:params success:^(id responseObj) {
                if (responseObj)
                {
                    self.timeOutView.hidden = YES;
                    if ([[responseObj objectForKey:@"returnCode"] isEqual:@(1001)])
                    {
                        NSString *message = [responseObj objectForKey:@"message"];
                        if ([message isEqualToString:@"成功取消关注"])
                        {
                            [sender setTitle:@"关  注" forState:UIControlStateNormal];
                            [sender setBackgroundColor:LCWBottomColor];
                            self.attentionStatus = NO;
                        }
                    }
                    else
                    {
                        [MBProgressHUD showError:[responseObj objectForKey:@"message"]];
                    }
                }
            } failure:^(NSError *error) {
                if (error)
                {
                    self.timeOutView.hidden = NO;
                }
            }];
        }
        
    }
    else
    {
        [MBProgressHUD showError:@"亲~登录才能关注"];
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:NO];
    }
}


@end
