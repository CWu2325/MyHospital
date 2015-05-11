//
//  SelTimeVC.h
//  MyHospital
//
//  Created by XYQS on 15/4/9.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Doctor.h"
#import "Room.h"
#import "Hospital.h"
#import "AttentionDoctor.h"

@interface SelTimeVC : UIViewController

@property(nonatomic,strong)Doctor *doctor;
@property(nonatomic,strong)Room *depts;
@property(nonatomic,strong)Hospital *hospital;
@property(nonatomic,strong)AttentionDoctor *att;
@property(nonatomic,copy)NSString *formWhere;
@end
