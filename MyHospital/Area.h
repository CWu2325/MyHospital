//
//  Area.h
//  MyHospital
//
//  Created by XYQS on 15/4/2.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject

@property(nonatomic)long areaID;                //区域主键
@property(nonatomic,copy)NSString *areaName;    //区域名称

@property(nonatomic)long parsentID;         //上级区域ID

@end
