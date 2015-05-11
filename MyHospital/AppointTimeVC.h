//
//  AppointTimeVC.h
//  MyHospital
//
//  Created by XYQS on 15/3/26.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"
#import "Room.h"
#import "Hospital.h"

@interface AppointTimeVC : UIViewController


@property(nonatomic,strong)Doctor *doctor;
@property(nonatomic,strong)Room *depts;
@property(nonatomic,strong)Hospital *hospital;


@end
