//
//  Doctor.h
//  MyHospital
//
//  Created by XYQS on 15/4/2.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedules.h"

@interface Doctor : NSObject

@property(nonatomic,copy)NSString *expert;          //医生擅长科目
@property(nonatomic)long doctorID;                  //医生主键id
@property(nonatomic,copy)NSString *doctorName;      //医生名称
@property(nonatomic,copy)NSString *hospitalName;    //医生所属医院名称
@property(nonatomic,copy)NSString *coverUrl;        //医生头像
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,copy)NSString *levelName;       //医生职称
@property(nonatomic)long sex;
@property(nonatomic,copy)NSString *departmentName;  //医生所属科室名称
@property(nonatomic)float fee;                      //挂号费
@property(nonatomic)int remainState;                //预约状态 -1不坐诊     0:满  1可预约

@property(nonatomic)int followed;                   //对应的用户是否关注了此医生

@property(nonatomic,strong)NSMutableArray *schedules;         //排版表

@end
