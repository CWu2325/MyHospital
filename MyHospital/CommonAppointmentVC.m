//
//  CommonAppointmentVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "CommonAppointmentVC.h"
#import "XyqsApi.h"
#import "comMember.h"
#import "MemberInfoVC.h"
#import "User.h"

@interface CommonAppointmentVC ()

@property(nonatomic,strong)NSMutableArray *members;

@end

@implementation CommonAppointmentVC

-(NSMutableArray *)appointDatas
{
    if (!_members)
    {
        _members = [NSMutableArray array];
    }
    return _members;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(AddMember)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([self.fromWhere isEqualToString:@"A"] )
    {
        //如果是从选择预约人界面跳转过来的
        [XyqsApi requestCommonAppointInfoAndCallBack:^(id obj) {
            self.members = obj;
            [XyqsApi requestUserInfoWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] andCallBack:^(id obj) {
                User *user = obj;
                comMember *member = [[comMember alloc]init];
                if (user.name != (NSString *)[NSNull null])
                {
                    member.name = user.name;
                }
                
                member.comID = @"0";        //就诊人ID，0代表自己
                
                if (user.mobile != (NSString *)[NSNull null])
                {
                    member.mobile = user.mobile;
                }
                
                if (user.idCard != (NSString *)[NSNull null])
                {
                    member.idCard = user.idCard;
                }
                
                if (user.sscard != (NSString *)[NSNull null])
                {
                    member.sscard = user.sscard;
                }
                
                [self.members insertObject:member atIndex:0];
                
                //[self.members addObject:member];
                [self.tableView reloadData];
                
            }];
        }];
        
    }
    else
    {
        [XyqsApi requestCommonAppointInfoAndCallBack:^(id obj) {
            self.members = obj;
            [self.tableView reloadData];
        }];
    }
    
}

//点击右上角添加按钮添加预约人
-(void)AddMember
{
    if ([self.fromWhere isEqualToString:@"A"])
    {
        if (self.members.count < 6)
        {
            MemberInfoVC *vc =  [[MemberInfoVC alloc]init];
            vc.title = @"添加预约人";
            vc.fromWhere = @"add";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [MBProgressHUD showError:@"最多只能添加5位预约人"];
        }
        
    }
    else
    {
        if (self.members.count < 5)
        {
            MemberInfoVC *vc =  [[MemberInfoVC alloc]init];
            vc.title = @"添加预约人";
            vc.fromWhere = @"add";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [MBProgressHUD showError:@"最多只能添加5位预约人"];
        }
    }
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UIImageView *diviIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, WIDTH, 1)];
    diviIV.backgroundColor = LCWDivisionLineColor;
    [cell.contentView addSubview:diviIV];
    
    comMember *member = self.members[indexPath.row];
    
    cell.textLabel.text = member.name;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"可添加5位预约人";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = [XyqsTools getSizeWithText:label.text andFont:label.font];
    label.center = footerView.center;
    [footerView addSubview:label];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([self.fromWhere isEqualToString:@"A"])
    {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        comMember *m = self.members[indexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:m.comID forKey:@"mberId"];
        [params setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] forKey:@"token"];
        [XyqsApi removeCommonMemberWithParams:params andCallBack:^(id obj) {
            [MBProgressHUD showSuccess:obj];
        }];
        
        [self.appointDatas removeObject:self.appointDatas[indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fromWhere isEqualToString:@"A"])
    {
        comMember *member = self.members[indexPath.row];
        [self.delegate passMember:member];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {

        MemberInfoVC *vc = [[MemberInfoVC alloc]init];
        vc.member = self.members[indexPath.row];
        vc.title = @"查看预约人";
        vc.fromWhere = @"find";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}




@end
