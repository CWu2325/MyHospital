//
//  AlipayConfirmVC.h
//  MyHospital
//
//  Created by XYQS on 15/3/27.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"
#import "Schedules.h"
#import "TimeQuantum.h"
#import "comMember.h"


@interface AlipayConfirmVC : UIViewController


@property(nonatomic,strong)Doctor *doctor;
@property(nonatomic,strong)Schedules *schedules;
@property(nonatomic,strong)comMember *member;
@property(nonatomic,strong)TimeQuantum *time;

@property(nonatomic,strong)NSString *orderNum;      //如果预约成功则有值为预约号
@property(nonatomic)long leftTime;                     //剩余时间

@property(nonatomic)int radioBtn;       //支付方式的单选值


@end
