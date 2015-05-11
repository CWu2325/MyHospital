//
//  JsonParser.h
//  MyHospital
//
//  Created by XYQS on 15/4/2.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"
#import "City.h"
#import "Hospital.h"
#import "User.h"
#import "Doctor.h"
#import "OrderDetail.h"


@interface JsonParser : NSObject

//解析个人资料
+(User *)parseUserByDictionary:(NSDictionary *)dic;

//解析地区
+(NSMutableArray *)parseAreaByDictionary:(NSDictionary *)dic;

//解析城市
+(NSMutableArray *)parseCityByDictionary:(NSDictionary *)dic;

//解析医院
+(NSMutableArray *)parseHospitalByDictionary:(NSDictionary *)dic;

//获得时间tid
+(NSMutableArray *)parseTimesByDictionary:(NSDictionary *)dic;

//解析预约时间段
+(NSMutableArray *)parseSchedulesByDictionary:(NSDictionary *)dic;

//解析科室
+(NSMutableArray *)parseRoomByDictionary:(NSDictionary *)dic;

//解析医院医生-------->选择医生列表的界面
+(NSMutableArray *)parseDoctorByDictionary:(NSDictionary *)dic;

//解析医院医生-------->选择医生列表的界面
+(Doctor *)parseDoctorDetailByDictionary:(NSDictionary *)dic;

//常用预约人
+(NSMutableArray *)parseCommonMemberByDictionary:(NSDictionary *)dic;

//预约列表
+(NSMutableArray *)parseOrderListByDictionary:(NSDictionary *)dic;

//预约列表
+(OrderDetail *)parseOrderDetailByDictionary:(NSDictionary *)dic;

//关注医生列表解析
+(NSMutableArray *)parseAttentionDoctorByDictionary:(NSDictionary *)dic;
@end
