//
//  Schedules.h
//  MyHospital
//
//  Created by XYQS on 15/4/7.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedules : NSObject

@property(nonatomic)long ampm;
@property(nonatomic)long remain;
@property(nonatomic,copy)NSString *week;
@property(nonatomic,copy)NSString *date;

@end
