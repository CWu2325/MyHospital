//
//  JsonParser.m
//  MyHospital
//
//  Created by XYQS on 15/4/2.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "JsonParser.h"
#import "Room.h"
#import "Doctor.h"
#import "comMember.h"
#import "TimeQuantum.h"
#import "Schedules.h"
#import "OrderRecord.h"
#import "AttentionDoctor.h"

@implementation JsonParser
//解析个人资料
+(User *)parseUserByDictionary:(NSDictionary *)dic
{
    User *user = [[User alloc]init];
    if ([dic objectForKey:@"user"] != [NSNull null])
    {
        NSDictionary *userDic = [dic objectForKey:@"user"];
        
        user.name = [userDic objectForKey:@"name"];
        user.Sex = [[userDic objectForKey:@"sex"]intValue];
        user.idCard = [userDic objectForKey:@"idCard"];
        user.address = [userDic objectForKey:@"address"];
        user.mobile = [userDic objectForKey:@"mobile"];
        user.sscard = [userDic objectForKey:@"sscard"];
        user.attentCard = [userDic objectForKey:@"attentCard"];
        user.coverUrl = [userDic objectForKey:@"coverUrl"];
        user.memberCount = [userDic objectForKey:@"memberCount"];
        
    }
    return user;
}

//解析地区
+(NSMutableArray *)parseAreaByDictionary:(NSDictionary *)dic
{
    NSDictionary *areadic = [dic objectForKey:@"data"];
    NSArray *arr = [areadic objectForKey:@"area"];
    NSMutableArray *areas = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        Area *a = [[Area alloc]init];
        a.areaID = [[dic objectForKey:@"id"] longValue];
        a.areaName = [dic objectForKey:@"name"];
        a.parsentID = [[dic objectForKey:@"parentId"] longValue];
        [areas addObject:a];
    }
    return areas;
}

//解析城市
+(NSMutableArray *)parseCityByDictionary:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"area"];
    NSMutableArray *cities = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        City *c = [[City alloc]init];
        c.cityID = [[dic objectForKey:@"id"]longValue];
        c.cityName = [dic objectForKey:@"name"];
        [cities addObject:c];
    }
    return cities;
}

//解析医院
+(NSMutableArray *)parseHospitalByDictionary:(NSDictionary *)dic
{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    NSArray *arr = [dataDic objectForKey:@"hospitals"];
    NSMutableArray *hospitals = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        Hospital *h = [[Hospital alloc]init];
//        h.address = [dic objectForKey:@"address"];
//        h.areaID = [[dic objectForKey:@"areaId"] longValue];
//       h.city = [dic objectForKey:@"city"];
        h.coverUrl = [dic objectForKey:@"coverUrl"];
//        h.geo = [dic objectForKey:@"geo"];
        h.hospitalID = [[dic objectForKey:@"id"]longValue];
//        h.images = [dic objectForKey:@"images"];
//        h.introduction = [dic objectForKey:@"introduction"];
        h.level = [dic objectForKey:@"level"];
        h.name = [dic objectForKey:@"name"];
//        h.province = [dic objectForKey:@"province"];
//        h.qnumber = [dic objectForKey:@"qnumber"];
//        h.ssid = [dic objectForKey:@"ssid"];
//        h.telephone = [dic objectForKey:@"telephone"];
//        h.traffic = [dic objectForKey:@"traffic"];
//        h.website = [dic objectForKey:@"website"];
        h.orderLimitDate = [dic objectForKey:@"orderLimitDate"];
        [hospitals addObject:h];
    }
    return hospitals;
}

//解析医生-------->医生详情的界面--->请求
+(Doctor *)parseDoctorDetailByDictionary:(NSDictionary *)dic
{
    NSDictionary *doctorDic = [dic objectForKey:@"doctor"];
    Doctor *d = [[Doctor alloc]init];
    d.coverUrl = [doctorDic objectForKey:@"coverUrl"];
    d.doctorName = [doctorDic objectForKey:@"doctorName"];
    d.expert = [doctorDic objectForKey:@"expert"];
    d.hospitalName = [doctorDic objectForKey:@"hospitalName"];
    d.doctorID = [[doctorDic objectForKey:@"id"] longValue];
    d.introduction = [doctorDic objectForKey:@"introduction"];
    d.levelName = [doctorDic objectForKey:@"levelName"];
    d.sex = [[doctorDic objectForKey:@"sex"] longValue];
    d.fee = [[doctorDic objectForKey:@"fee"] floatValue];
    d.departmentName = [doctorDic objectForKey:@"departmentName"];
    d.remainState = [[doctorDic objectForKey:@"remainState"] intValue];
    d.followed = [[doctorDic objectForKey:@"followed"] intValue];
    
    NSArray *arr = [dic objectForKey:@"schedules"];
    NSMutableArray *schedules = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        Schedules *d = [[Schedules alloc]init];
        d.ampm = [[dic objectForKey:@"ampm"] longValue];
        d.date = [dic objectForKey:@"date"];
        d.week = [dic objectForKey:@"week"];
        d.remain = [[dic objectForKey:@"remain"] longValue] ;
        
        [schedules addObject:d];
    }
    d.schedules = schedules;
    
    return d;
}

//解析科室
+(NSMutableArray *)parseRoomByDictionary:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"depts"];
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        Room *r = [[Room alloc]init];
        r.coverUrl = [dic objectForKey:@"coverUrl"];
        r.roomID = [[dic objectForKey:@"id"] longValue];
        r.introduction = [dic objectForKey: @"introduction"];
        r.name = [dic objectForKey:@"name"];
     
        [rooms addObject:r];
    }
    return rooms;
}

//解析医生-------->选择医生列表的界面
+(NSMutableArray *)parseDoctorByDictionary:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"doctors"];
    NSMutableArray *doctors = [NSMutableArray array];

    for (NSDictionary *dic in arr)
    {
        Doctor *d = [[Doctor alloc]init];
        d.coverUrl = [dic objectForKey:@"coverUrl"];
        d.doctorName = [dic objectForKey:@"doctorName"];
        d.expert = [dic objectForKey:@"expert"];
        d.hospitalName = [dic objectForKey:@"hospitalName"];
        d.doctorID = [[dic objectForKey:@"id"] longValue];
        d.introduction = [dic objectForKey:@"introduction"];
        d.levelName = [dic objectForKey:@"levelName"];
        d.sex = [[dic objectForKey:@"sex"] longValue];
        d.fee = [[dic objectForKey:@"fee"] floatValue];
        d.departmentName = [dic objectForKey:@"departmentName"];
        d.remainState = [[dic objectForKey:@"remainState"] intValue];
        d.followed = [[dic objectForKey:@"followed"] boolValue];
        [doctors addObject:d];
    }
    return doctors;
}

//常用预约人
+(NSMutableArray *)parseCommonMemberByDictionary:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"members"];
    NSMutableArray *members = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        comMember *d = [[comMember alloc]init];
        d.name = [dic objectForKey:@"name"];
        d.attentCard = [dic objectForKey:@"attentCard"];
        d.idCard = [dic objectForKey:@"idCard"];
        d.mobile = [dic objectForKey:@"mobile"];
        d.sex = [dic objectForKey:@"sex"] ;
        d.sscard = [dic objectForKey:@"sscard"];
        d.comID = [dic objectForKey:@"id"];
        d.birthdate = [dic objectForKey:@"birthdate"];
        [members addObject:d];
    }
    return members;
}

//解析预约时间段(上、下午)
+(NSMutableArray *)parseTimesByDictionary:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"times"];
    NSMutableArray *times = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        TimeQuantum *d = [[TimeQuantum alloc]init];
        d.tid = [[dic objectForKey:@"tid"] longValue];
        d.orderDate = [dic objectForKey:@"orderDate"];
        d.startTime = [dic objectForKey:@"startTime"];
        d.endTime = [dic objectForKey:@"endTime"];
        d.remain = [[dic objectForKey:@"remain"] longValue] ;
        d.total = [[dic objectForKey:@"total"] longValue];
        [times addObject:d];
    }
    return times;
}

//解析预约时间段（日期，和可预订与否）
+(NSMutableArray *)parseSchedulesByDictionary:(NSDictionary *)dic
{
    NSArray *arr = [dic objectForKey:@"schedules"];
    NSMutableArray *schedules = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        Schedules *d = [[Schedules alloc]init];
        d.ampm = [[dic objectForKey:@"ampm"] longValue];
        d.date = [dic objectForKey:@"date"];
        d.week = [dic objectForKey:@"week"];
        d.remain = [[dic objectForKey:@"remain"] longValue] ;

        [schedules addObject:d];
    }
    return schedules;
}

//预约列表
+(NSMutableArray *)parseOrderListByDictionary:(NSDictionary *)dic
{
    NSDictionary *orderDic = [dic objectForKey:@"data"];
    NSArray *arr = [orderDic objectForKey:@"orderrecords"];
    
    NSMutableArray *orderrecords = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        OrderRecord *d = [[OrderRecord alloc]init];
        d.commState = [[dic objectForKey:@"commState"] longValue];
        d.deptId = [[dic objectForKey:@"deptId"] longValue] ;
        d.deptName = [dic objectForKey:@"deptName"];
        d.doctorName = [dic objectForKey:@"doctorName"];
        d.doctorId = [[dic objectForKey:@"doctorId"] longValue];
        d.fee = [[dic objectForKey:@"fee"] floatValue] ;
        d.hospitalId = [[dic objectForKey:@"hospitalId"] longValue];
        d.hospitalName = [dic objectForKey:@"hospitalName"];
        d.iconUrl = [dic objectForKey:@"iconUrl"];
        d.orderListID = [[dic objectForKey:@"id"] longValue] ;      //列表ID
        d.orderId = [dic objectForKey:@"orderId"];                  //预约号
        d.idCard = [dic objectForKey:@"idCard"];
        d.payState = [[dic objectForKey:@"payState"] longValue];
        d.payWay = [[dic objectForKey:@"payWay"] longValue] ;
        d.levelName = [dic objectForKey:@"levelName"];
        d.patientName = [dic objectForKey:@"patientName"];
        d.sourceId = [[dic objectForKey:@"sourceId"] longValue];
        d.userId = [[dic objectForKey:@"userId"] longValue] ;
        d.orderDate = [dic objectForKey:@"orderDate"];
        d.orderEndTime = [dic objectForKey:@"orderEndTime"];
        d.orderState = [[dic objectForKey:@"orderState"] longValue];
        d.orderStartTime = [dic objectForKey:@"orderStartTime"];
        [orderrecords addObject:d];
    }
    return orderrecords;
}

//预约详情
+(OrderDetail *)parseOrderDetailByDictionary:(NSDictionary *)dic
{
    NSDictionary *orderDic = [dic objectForKey:@"data"];
    NSDictionary *orderDetailDic = [orderDic objectForKey:@"orderRecord"];
    OrderDetail *order = [[OrderDetail alloc]init];
    order.hospitalName = [orderDetailDic objectForKey:@"hospitalName"];
    order.orderDate = [orderDetailDic objectForKey:@"orderDate"];
    order.doctorName = [orderDetailDic objectForKey:@"doctorName"];
    order.sourceId = [[orderDetailDic objectForKey:@"sourceId"] longValue];
    order.leftTime = [[orderDetailDic objectForKey:@"leftTime"] intValue];
    order.userId = [[orderDetailDic objectForKey:@"userId"]longValue];
    order.patientName = [orderDetailDic objectForKey:@"patientName"];
    order.orderStartTime = [orderDetailDic objectForKey:@"orderStartTime"];
    order.deptId = [[orderDetailDic objectForKey:@"deptId"] longValue];
    order.payState = [[orderDetailDic objectForKey:@"payState"] intValue];
    order.doctorId = [[orderDetailDic objectForKey:@"doctorId"]longValue];
    order.hospitalId = [[orderDetailDic objectForKey:@"hospitalId"] longValue];
    order.orderRecoderID = [[orderDetailDic objectForKey:@"id"] longValue];
    order.orderState = [[orderDetailDic objectForKey:@"orderState"] intValue];
    order.orderId = [orderDetailDic objectForKey:@"orderId"];
    order.iconUrl = [orderDetailDic objectForKey:@"iconUrl"];
    order.fee = [[orderDetailDic objectForKey:@"fee"] floatValue];
    order.idCard = [orderDetailDic objectForKey:@"idCard"];
    order.levelName = [orderDetailDic objectForKey:@"levelName"];
    order.payWay = [[orderDetailDic objectForKey:@"payWay"] intValue];
    order.deptName = [orderDetailDic objectForKey:@"deptName"];
    order.orderEndTime = [orderDetailDic objectForKey:@"orderEndTime"];
    order.commState = [[orderDetailDic objectForKey:@"commState"]intValue];
    order.mobile = [orderDetailDic objectForKey:@"mobile"];
    return order;
}

//关注医生列表解析
+(NSMutableArray *)parseAttentionDoctorByDictionary:(NSDictionary *)dic
{
    NSDictionary *attentionDic = [dic objectForKey:@"data"];
    NSArray *arr = [attentionDic objectForKey:@"myfollows"];

    NSMutableArray *attentionDoctors = [NSMutableArray array];
    for (NSDictionary *dic in arr)
    {
        AttentionDoctor *d = [[AttentionDoctor alloc]init];
        d.attentionID = [[dic objectForKey:@"id"] longValue];
        d.commMark = [[dic objectForKey:@"commMark"] intValue] ;
        d.departmentName = [dic objectForKey:@"departmentName"];
        d.doctorName = [dic objectForKey:@"doctorName"];
        d.doctId = [[dic objectForKey:@"doctId"] longValue];
        d.hospitalName = [dic objectForKey:@"hospitalName"];
        d.levelName = [dic objectForKey:@"levelName"] ;
        d.userId = [[dic objectForKey:@"userId"] longValue];
        d.coverUrl = [dic objectForKey:@"coverUrl"];
        d.deptId = [[dic objectForKey:@"deptId"] longValue];
        [attentionDoctors addObject:d];
    }
    return attentionDoctors;
}


@end
