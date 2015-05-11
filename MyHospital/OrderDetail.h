//
//  OrderDetail.h
//  MyHospital
//
//  Created by XYQS on 15/4/20.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetail : NSObject

@property(nonatomic,copy)NSString *hospitalName;        //医院名称.
@property(nonatomic,copy)NSString *orderDate;           //预约日期.
@property(nonatomic,copy)NSString *doctorName;          //医生名字.
@property(nonatomic)long sourceId;                      //号源ID.
@property(nonatomic)int leftTime;                       //支付时间倒计时.
@property(nonatomic)long userId;                        //挂号的注册用户.
@property(nonatomic,copy)NSString *patientName;         //就诊人.
@property(nonatomic)NSDate *orderStartTime;             //就诊开始时间.
@property(nonatomic)long deptId;                        //科室ID.
@property(nonatomic)int payState;                       //支付状态.
@property(nonatomic)long doctorId;                      //医生ID.
@property(nonatomic)long hospitalId;                    //医院ID.
@property(nonatomic)long orderRecoderID;                //订单主键ID.
@property(nonatomic)int orderState;                     //预约状态.
@property(nonatomic,copy)NSString *orderId;             //预约号.
@property(nonatomic,copy)NSString *iconUrl;             //医生头像地址.
@property(nonatomic)float fee;                          //挂红费用.
@property(nonatomic,copy)NSString *idCard;              //就诊人身份证号.
@property(nonatomic,copy)NSString *levelName;           //医生等级.
@property(nonatomic)int payWay;                         //支付方式.
@property(nonatomic,copy)NSString *deptName;            //科室名称.
@property(nonatomic)NSDate *orderEndTime;               //就诊结束时间.
@property(nonatomic)int commState;                      //评价状态.
@property(nonatomic,copy)NSString *mobile;              //就诊人电话
@property(nonatomic,copy)NSString *cancelState;         //是否可以取消预约在orderState=1也就是成功预约时候才有用.
@property(nonatomic,copy)NSString *created;             //下订单日期.


@end
