//
//  OrderRecord.h
//  MyHospital
//
//  Created by XYQS on 15/4/8.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderRecord : NSObject

@property(nonatomic)int commState;              //？？？？？？
@property(nonatomic)int deptId;                 //科室主键
@property(nonatomic)int doctorId;               //医生主键
@property(nonatomic)int hospitalId;             //医院主键
@property(nonatomic)float fee;                  //挂号费
@property(nonatomic)long orderListID;           //预约记录主键id
@property(nonatomic)long orderState;            //订单状态
@property(nonatomic)long payState;              //支付状态
@property(nonatomic)long payWay;                //支付方式
@property(nonatomic)long sourceId;                //支付方式
@property(nonatomic)long userId;                //支付方式

@property(nonatomic,copy)NSString *idCard;          //身份证信息
@property(nonatomic,copy)NSString *deptName;        //科室名称
@property(nonatomic,copy)NSString *doctorName;      //医生名称
@property(nonatomic,copy)NSString *hospitalName;    //医生名称
@property(nonatomic,copy)NSString *levelName;       //医生等级
@property(nonatomic,copy)NSString *orderDate;       //预约日期
@property(nonatomic,copy)NSString *patientName;     //就诊人姓名
@property(nonatomic,copy)NSString *iconUrl;         //医生头像地址
@property(nonatomic,copy)NSString *orderId;         //预约号
@property(nonatomic,copy)NSDate *orderEndTime;          //预约结束时间
@property(nonatomic,copy)NSDate *orderStartTime;          //预约开始时间

@end
