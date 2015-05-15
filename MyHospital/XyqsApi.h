//
//  XyqsApi.h
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

typedef void (^Callback)(id obj);

@interface XyqsApi : NSObject

//注册功能
+(void)requestTelLoginWithMobile:(NSString *)mobile andPassword:(NSString *)password andCode:(NSString *)code andCallBack:(Callback)callback;

//判断是否已经登陆
+(BOOL)isLogin;

//登陆功能
+(void)requestTelLoginWithMobile:(NSString *)mobile andPassword:(NSString *)password andCallBack:(Callback)callback;

//验证电话号码是否可用
+(void)verifyTelWithMobile:(NSString *)mobile andCallBack:(Callback)callback;

//重置密码Step1
+(void)resetPwdFirstWithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//解析区域
+(void)requestWithParentld:(long)parentld andCallBack:(Callback)callback;

//获取城市列表
+(void)requestCitiesListwithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//根据城市名称返回城市ID
+(void)getCityIDWithCityNameDic:(NSDictionary *)params andCallback:(Callback)callback;

//解析城市
+(void)requestWithCityParentld:(long)parentld andCallBack:(Callback)callback;

//选择医院
+(void)requestHospitalParentld:(long)areald andCallBack:(Callback)callback;


//选择科室
+(void)requestDeptsWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;


//选择医生
+(void)requestDoctorWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;


//获取医生某日上午或下午的坐诊时段列表
+(void)requestTimesWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//获取订单预约号
+(void)requestOrderNumWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//取消订单
+(void)CancelOrderWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//获取预约记录列表
+(void)requestOrderRecordListWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//获取预约记录列表中的预约详情
+(void)requestOrderDetailWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;


//获取医生信息和排班表的详情
+(void)requestDoctorDetailWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//添加关注医生
+(void)requestAddDoctorAttentionWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//取消关注医生
+(void)requestCancerDoctorAttentionWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//获取个人信息接口
+(void)requestUserInfoWithToken:(NSString *)token andCallBack:(Callback)callback;

//更新个人资料(完整4.14)
+(void)updateUserInfoWithParams:(NSDictionary *)params andCallBack:(Callback)callback;



//获取常用预约人息接口
+(void)requestCommonAppointInfoAndCallBack:(Callback)callback;

//添加常用预约人资料
+(void)addCommonMemberWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//更新常用预约人资料
+(void)updateCommonMemberWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//删除常用预约人
+(void)removeCommonMemberWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

//获取关注的医生列表
+(void)requestAttentionDoctorListwithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

/**
 *  银联wap支付
 */
+(void)payWithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

/**
 *  发送验证码
 */
+(void)getVerifycodeWithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback;

/**
 *  更改密码
 */
+(void)changePasswordWithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback;


@end
