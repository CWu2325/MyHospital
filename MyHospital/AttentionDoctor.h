//
//  AttentionDoctor.h
//  MyHospital
//
//  Created by apple on 15/4/9.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionDoctor : NSObject

@property(nonatomic)int commMark;       //评分
@property(nonatomic)long attentionID;   //关注主键ID
@property(nonatomic)long userId;        //用户ID
@property(nonatomic)long doctId;      //医生ID
@property(nonatomic)long deptId;        //科室ID
@property(nonatomic,copy)NSString *doctorName;  //关注医生名字
@property(nonatomic,copy)NSString *hospitalName;    //医院名称
@property(nonatomic,copy)NSString *departmentName;  //科室名称
@property(nonatomic,copy)NSString *levelName;       //医生职称
@property(nonatomic,copy)NSString *coverUrl;         //医生的头像
@end
