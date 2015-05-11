//
//  InfoConfirmViewC.h
//  MyHospital
//
//  Created by XYQS on 15/4/10.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Doctor.h"
#import "Room.h"
#import "Schedules.h"
#import "Hospital.h"
#import "TimeQuantum.h"
#import "User.h"

@interface InfoConfirmViewC : UIViewController

@property(nonatomic,strong)Doctor *doctor;
@property(nonatomic,strong)Room *depts;
@property(nonatomic,strong)Schedules *schedules;
@property(nonatomic,strong)Hospital *hospital;
@property(nonatomic,strong)TimeQuantum *time;

@property(nonatomic,strong)User *user;

@end
