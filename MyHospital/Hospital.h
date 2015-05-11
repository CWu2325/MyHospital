//
//  Hospital.h
//  MyHospital
//
//  Created by XYQS on 15/4/2.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hospital : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic)long areaID;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *coverUrl;
@property(nonatomic,copy)NSString *geo;
@property(nonatomic)long hospitalID;
@property(nonatomic,copy)NSString *images;
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *qnumber;
@property(nonatomic,copy)NSString *ssid;
@property(nonatomic,copy)NSString *telephone;
@property(nonatomic,copy)NSString *traffic;
@property(nonatomic,copy)NSString *website;
@property(nonatomic,copy)NSString *orderLimitDate;

@end
