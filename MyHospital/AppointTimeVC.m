//
//  AppointTimeVC.m
//  MyHospital
//
//  Created by XYQS on 15/3/26.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppointTimeVC.h"
#import "InfoConfirmVC.h"
#import "XyqsApi.h"
#import "Schedules.h"
#import "LoginViewController.h"

@interface AppointTimeVC ()

@property(nonatomic,strong)UIView *scView;      //SV里面的view
@property(nonatomic,strong)NSMutableArray *amSchedule;
@property(nonatomic,strong)NSMutableArray *pmSchedule;
@property(nonatomic,strong)Doctor *doctorDetail;        //医生排版详情带是否关注

@property(nonatomic)BOOL isEnable;          //关注的状态


@end

@implementation AppointTimeVC


//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.amSchedule = [NSMutableArray array];
//    self.pmSchedule = [NSMutableArray array];
//    
//    for (Schedules *s in self.schedules)
//    {
//        if (s.ampm == 0)
//        {
//            [self.amSchedule addObject:s];
//        }
//        else
//        {
//            [self.pmSchedule addObject:s];
//        }
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.amSchedule = [NSMutableArray array];
    self.pmSchedule = [NSMutableArray array];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.depts.roomID) forKey:@"deptId"];
    [params setObject:@(self.doctor.doctorID) forKey:@"doctId"];
    
    if ([XyqsApi isLogin])
    {
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    }
    
//    //获取医生详情的方法
//    [XyqsApi requestDoctorDetailWithParams:params andCallBack:^(id obj) {
//        self.doctorDetail = obj;
//        
//        for (Schedules *s in self.doctorDetail.schedules)
//        {
//            if (s.ampm == 0)
//            {
//                [self.amSchedule addObject:s];
//            }
//            else
//            {
//                [self.pmSchedule addObject:s];
//            }
//        }
//        [self.view setNeedsDisplay];
//        [self.view setNeedsLayout];
//    }];
    
    //布局
   // [self initUI];
}






-(void)initUI
{
    //初始化头部头像
    UIImageView *docImageView = [[UIImageView alloc]init];
    [docImageView setImageWithURL:[NSURL URLWithString:self.doctor.coverUrl]];
    docImageView.x = 15;
    docImageView.y = 74;
    docImageView.width = 60;
    docImageView.height = 60;
    [self.view addSubview:docImageView];
    docImageView.layer.cornerRadius = docImageView.width/2;
    docImageView.layer.borderWidth = 1.5;
    docImageView.layer.borderColor = [UIColor greenColor].CGColor;
    docImageView.layer.masksToBounds = YES;
    if (self.doctorDetail.coverUrl)
    {
        [docImageView setImageWithURL:[NSURL URLWithString:self.doctorDetail.coverUrl]];
    }
    
    //关注按钮
    UIButton *attentionBtn = [[UIButton alloc]init];
    attentionBtn.width = 45;
    attentionBtn.height = 20;
    attentionBtn.x = WIDTH - attentionBtn.width - 10;
    attentionBtn.y = docImageView.y;
    attentionBtn.layer.cornerRadius = 5;
    [attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attentionBtn];
    if (self.doctorDetail.followed)
    {
        [attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [attentionBtn setBackgroundColor:[UIColor lightGrayColor]];
        self.isEnable = NO;
    }
    else
    {
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [attentionBtn setBackgroundColor:[UIColor greenColor]];
        self.isEnable  = YES;
    }
    
    
    //头部医生名称
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = self.doctorDetail.doctorName;
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.size = [self getSizeByText:nameLabel.text andFont:nameLabel.font andWidth:WIDTH];
    nameLabel.x = docImageView.x + docImageView.width + 15;
    nameLabel.y = docImageView.y + 2;
    [self.view addSubview:nameLabel];
    
    //头部医生等级
    UILabel *docLevelLabel = [[UILabel alloc]init];
    docLevelLabel.text = self.doctorDetail.levelName;
    docLevelLabel.font = [UIFont systemFontOfSize:14];
    docLevelLabel.size = [self getSizeByText:docLevelLabel.text andFont:docLevelLabel.font andWidth:WIDTH];
    docLevelLabel.x = nameLabel.x;
    docLevelLabel.y = nameLabel.y + nameLabel.height+ 2;
    [self.view addSubview:docLevelLabel];
    
    //详情描述
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = self.doctorDetail.hospitalName;
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.size = [self getSizeByText:detailLabel.text andFont:detailLabel.font andWidth:WIDTH];
    detailLabel.x = nameLabel.x;
    detailLabel.y = docLevelLabel.y +docLevelLabel.height + 2;
    [self.view addSubview:detailLabel];
    
    //头部分割线
    UIView *view1 = [[UIView alloc]init];
    view1.x = 0;
    view1.y = docImageView.y + docImageView.height+10;
    view1.width = WIDTH;
    view1.height = 1.5;
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];

    
    //排班表
    CGFloat W = WIDTH / 8;
    UILabel *MakeAppointLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view1.maxY + 5, WIDTH - 100, W)];
    MakeAppointLabel.centerX = self.view.centerX;
    MakeAppointLabel.textAlignment = NSTextAlignmentCenter;
    MakeAppointLabel.text = @"排  班  表";
    MakeAppointLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:MakeAppointLabel];
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, MakeAppointLabel.maxY, WIDTH, W*3+1)];
    self.scView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH * 2, W*3)];
    [self initSV];
    [sv addSubview:self.scView];
    sv.contentSize = CGSizeMake(WIDTH *2, W*3);
    [self.view addSubview:sv];
    
    
    //擅长标签
    UILabel *skillLabel = [[UILabel alloc]init];
    skillLabel.x = 10;
    skillLabel.y = sv.maxY+ 10;
    skillLabel.text = @"擅长";
    skillLabel.font = [UIFont systemFontOfSize:14];
    skillLabel.size = [self getSizeByText:skillLabel.text andFont:skillLabel.font andWidth:WIDTH];
    [self.view addSubview:skillLabel];
    
    //擅长下的黑条
    UIView *view2 = [[UIView alloc]init];
    view2.x = 0;
    view2.y = skillLabel.y + skillLabel.height+1;
    view2.width = skillLabel.size.width + 60;
    view2.height = 1.5;
    view2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view2];
    
    //擅长的说明
    UILabel *skillDetailLabel = [[UILabel alloc]init];
    skillDetailLabel.numberOfLines = 0;
    skillDetailLabel.x = 10;
    skillDetailLabel.y = skillLabel.y + skillLabel.height + 2;
    skillDetailLabel.text = self.doctorDetail.expert;
    skillDetailLabel.font = [UIFont systemFontOfSize:14];
    skillDetailLabel.size = [self getSizeByText:skillDetailLabel.text andFont:skillDetailLabel.font andWidth:WIDTH-20];
    [self.view addSubview:skillDetailLabel];
    
    //经历标签 和 标签下的条
    UILabel *undergoLabel = [[UILabel alloc]init];
    undergoLabel.x = skillLabel.x;
    undergoLabel.y = skillDetailLabel.y + skillDetailLabel.height + 15;
    undergoLabel.text = @"职业经验";
    undergoLabel.font = [UIFont systemFontOfSize:14];
    undergoLabel.size = [self getSizeByText:undergoLabel.text andFont:undergoLabel.font andWidth:WIDTH];
    [self.view addSubview:undergoLabel];
    
    UIView *view3 = [[UIView alloc]init];
    view3.x = 0;
    view3.y = undergoLabel.y + undergoLabel.height + 1;
    view3.width = view2.width;
    view3.height = 1.5;
    view3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view3];
    
    //职业经历的内容
    UILabel *undergoDetailLabel = [[UILabel alloc]init];
    undergoDetailLabel.numberOfLines = 0;
    undergoDetailLabel.x = skillDetailLabel.x;
    undergoDetailLabel.y = view3.y + 2;
    undergoDetailLabel.text = self.doctorDetail.introduction;
    undergoDetailLabel.font = [UIFont systemFontOfSize:14];
    undergoDetailLabel.size = [self getSizeByText:undergoDetailLabel.text andFont:undergoDetailLabel.font andWidth:WIDTH-20];
    [self.view addSubview:undergoDetailLabel];
}


//动态获取字体高度
-(CGSize)getSizeByText:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

//初始化SV里面的控件
-(void)initSV
{
    CGFloat w = WIDTH/8;
    
    //空白
    UILabel *Label = [[UILabel alloc]init];
    Label.x = 0;
    Label.y = 0;
    Label.width = w;
    Label.height = Label.width;
    Label.textAlignment = NSTextAlignmentCenter;
    Label.adjustsFontSizeToFitWidth = YES;
    [self.scView addSubview:Label];
    
    
    //上午
    UILabel *amLabel = [[UILabel alloc]init];
    amLabel.x = 0;
    amLabel.y = w;
    amLabel.width = w;
    amLabel.height = amLabel.width;
    amLabel.text = @"上午";
    amLabel.font = [UIFont systemFontOfSize:13];
    amLabel.textAlignment = NSTextAlignmentCenter;
    amLabel.adjustsFontSizeToFitWidth = YES;
    [self.scView addSubview:amLabel];
    
    //下午
    UILabel *pmLabel = [[UILabel alloc]init];
    pmLabel.x = 0;
    pmLabel.y = w*2;
    pmLabel.width = w;
    pmLabel.height = pmLabel.width;
    pmLabel.text = @"下午";
    pmLabel.font = amLabel.font;
    pmLabel.textAlignment = NSTextAlignmentCenter;
    pmLabel.adjustsFontSizeToFitWidth = YES;
    [self.scView addSubview:pmLabel];
    
    //水平分割线
    for (int i = 0 ; i < 4; i++)
    {
        UIImageView *horizontalIV = [[UIImageView alloc]init];
        horizontalIV.backgroundColor = [UIColor lightGrayColor];
        horizontalIV.x = 0;
        horizontalIV.y = i *w;
        horizontalIV.width = WIDTH *2;
        horizontalIV.height = 1;
        
        [self.scView addSubview:horizontalIV];
    }
    
    
    for (int i = 0 ; i < self.amSchedule.count; i++)
    {
        Schedules *s1 = self.amSchedule[i];
        Schedules *s2 = self.pmSchedule[i];
        //竖直分割线
        UIImageView *divisionIv= [[UIImageView alloc]init];
        divisionIv.backgroundColor = [UIColor lightGrayColor];
        divisionIv.x = w + i * w;
        divisionIv.y = 0;
        divisionIv.width = 1;
        divisionIv.height = w * 3;
        [self.scView addSubview:divisionIv];
        
        //星期标签
        UILabel *weakLabel = [[UILabel alloc]init];
        weakLabel.x = w+i * w;
        weakLabel.y = 0;
        weakLabel.width = w;
        weakLabel.height = w/2;
        weakLabel.textAlignment = NSTextAlignmentCenter;
        weakLabel.font = [UIFont systemFontOfSize:12];
        [self.scView addSubview:weakLabel];
        
        
        //日期标签
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.x = w+i * w;
        dateLabel.y = weakLabel.maxY;
        dateLabel.width = w;
        dateLabel.height = w/2;
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.adjustsFontSizeToFitWidth = YES;
        [self.scView addSubview:dateLabel];
        
        weakLabel.text = s1.week;
        dateLabel.text = s1.date;

        
        //上午的btn
        UIButton *amBtn = [[UIButton alloc]init];
        amBtn.tag = i;
        amBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        amBtn.enabled = NO;
        amBtn.x = dateLabel.x;
        amBtn.y = dateLabel.maxY;
        amBtn.width = w;
        amBtn.height = amBtn.width;
        [amBtn addTarget:self action:@selector(amBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scView addSubview:amBtn];
        if (s1.remain > 0)
        {
            [amBtn setTitle:@"可预约" forState:UIControlStateNormal];
            [amBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            amBtn.enabled = YES;
        }
        else if(s1.remain == 0)
        {
            [amBtn setTitle:@"已预满" forState:UIControlStateNormal];
            [amBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        //下午的btn
        UIButton *pmBtn = [[UIButton alloc]init];
        pmBtn.tag = i;
        pmBtn.enabled = NO;
        pmBtn.titleLabel.font = amBtn.titleLabel.font;
        pmBtn.x = amBtn.x;
        pmBtn.y = amBtn.maxY;
        pmBtn.width = w;
        pmBtn.height = pmBtn.width;
        [pmBtn addTarget:self action:@selector(pmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scView addSubview:pmBtn];
        
       
        if (s2.remain > 0)
        {
            [pmBtn setTitle:@"可预约" forState:UIControlStateNormal];
            [pmBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            pmBtn.enabled = YES;
        }
        else if(s2.remain == 0)
        {
            [pmBtn setTitle:@"已预满" forState:UIControlStateNormal];
            [pmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

//按钮的点击事件(上午)
-(void)amBtnAction:(UIButton *)sender
{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
    {
        [MBProgressHUD showError:@"亲~您还没登录!"];
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
    else
    {
        Schedules *s = self.amSchedule[sender.tag];
        InfoConfirmVC *infoVC = [[InfoConfirmVC alloc]initWithNibName:@"InfoConfirmVC" bundle:nil];
        infoVC.doctor = self.doctor;
        infoVC.depts = self.depts;
        infoVC.schedules = s;
        
        //传个可变字典用于保存预约订单的请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(self.doctor.doctorID) forKey:@"doctId"];
        [params setObject:@(self.depts.roomID) forKey:@"deptId"];
        [params setObject:@(s.ampm) forKey:@"ampm"];
        [params setObject:s.date forKey:@"orderDate"];
        
        infoVC.params2 = params;
#pragma -------
        [self.navigationController pushViewController:infoVC animated:YES];
    }

}

//按钮点击事件（下午）
-(void)pmBtnAction:(UIButton *)sender
{
    
    
    Schedules *s = self.pmSchedule[sender.tag];
    
    
    InfoConfirmVC *infoVC = [[InfoConfirmVC alloc]initWithNibName:@"InfoConfirmVC" bundle:nil];
    infoVC.doctor = self.doctor;
    infoVC.depts  = self.depts;
    infoVC.schedules = s;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.doctor.doctorID) forKey:@"doctId"];
    [params setObject:@(self.depts.roomID) forKey:@"deptId"];
    [params setObject:@(s.ampm) forKey:@"ampm"];
    [params setObject:s.date forKey:@"orderDate"];
    infoVC.params = params;
    [self.navigationController pushViewController:infoVC animated:YES];
}



//关注按钮事件
-(void)attentionAction:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
    [params setObject:@(self.doctor.doctorID) forKey:@"doctorId"];
    
    if([XyqsApi isLogin])
    {
        if (self.isEnable)
        {
            //添加关注的医生
            [XyqsApi requestAddDoctorAttentionWithParams:params andCallBack:^(id obj) {
                if ([obj isEqualToString:@"成功添加关注"])
                {
                    [sender setTitle:@"已关注" forState:UIControlStateNormal];
                    sender.titleLabel.adjustsFontSizeToFitWidth = YES;
                    [sender setBackgroundColor:[UIColor lightGrayColor]];
                }
            }];
            self.isEnable = NO;
        }
        else
        {
            //添加关注的医生
            [XyqsApi requestCancerDoctorAttentionWithParams:params andCallBack:^(id obj) {
                if ([obj isEqualToString:@"成功取消关注"])
                {
                    [sender setTitle:@"关注" forState:UIControlStateNormal];
                    [sender setBackgroundColor:[UIColor greenColor]];
                }
            }];
            self.isEnable = YES;
        }
        
    }
    else
    {
        [MBProgressHUD showError:@"亲~您还没登录!"];
        LoginViewController *login = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
