//
//  User.h
//  MyHospital
//
//  Created by apple on 15/4/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


@property(nonatomic,copy)NSString *name;        //用户姓名
@property(nonatomic) int Sex;                   //用户性别
@property(nonatomic,copy)NSString *mobile;      //手机号码
@property(nonatomic,copy)NSString *idCard;      //用户身份证号
@property(nonatomic,copy)NSString *address;     //居住地址
@property(nonatomic,copy)NSString *sscard;      //社保卡号
@property(nonatomic,copy)NSString *attentCard;      //就诊卡号
@property(nonatomic,copy)NSString *coverUrl;        //头像地址
@property(nonatomic,copy)NSString *memberCount;     //成员数量


@end
