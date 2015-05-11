//
//  TimeQuantum.h
//  MyHospital
//
//  Created by XYQS on 15/4/7.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeQuantum : NSObject

@property(nonatomic)long tid;
@property(nonatomic,copy)NSString *orderDate;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic)long remain;
@property(nonatomic)long total;


@end
