//
//  AppointmentRecordVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppointmentRecordVC.h"
#import "AppRecordCell.h"
#import "XyqsApi.h"
#import "OrderRecord.h"
#import "OrderDetailVC.h"

@interface AppointmentRecordVC ()

@property(nonatomic,strong)NSMutableArray *recordDatas;

@property(nonatomic)int limit;
@property(nonatomic)int offset;

@end

@implementation AppointmentRecordVC

-(NSMutableArray *)recordDatas
{
    if (!_recordDatas)
    {
        _recordDatas = [NSMutableArray array];
    }
    return _recordDatas;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约记录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LCWBackgroundColor;
    
    self.limit = 0;
    self.offset = 0;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
//    [params setObject:@(self.limit) forKey:@"limit"];
//    [params setObject:@(self.offset) forKey:@"offset"];
//    
//    [XyqsApi requestOrderRecordListWithParams:params andCallBack:^(id obj) {
//        self.recordDatas = obj;
//        [self.tableView reloadData];
//    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.limit += 10;
    self.offset = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]forKey:@"token"];
    [params setObject:@(self.limit) forKey:@"limit"];
    [params setObject:@(self.offset) forKey:@"offset"];
    
    [XyqsApi requestOrderRecordListWithParams:params andCallBack:^(id obj) {
        self.recordDatas = obj;
        [self.tableView reloadData];
    }];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[AppRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    OrderRecord *orderList = self.recordDatas[indexPath.row];
    cell.orderList = orderList;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderRecord *orderList = self.recordDatas[indexPath.row];
    OrderDetailVC *vc = [[OrderDetailVC alloc]init];
    vc.orderList = orderList;
    vc.title = @"预约记录详情";
    [self.navigationController pushViewController:vc animated:YES];
}




@end
