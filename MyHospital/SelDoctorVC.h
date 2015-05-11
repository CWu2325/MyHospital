//
//  SelDoctorVC.h
//  MyHospital
//
//  Created by XYQS on 15/5/5.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hospital.h"
#import "Room.h"


@interface SelDoctorVC : UIViewController

@property(nonatomic,strong)Hospital *hospital;
@property(nonatomic,strong)Room *depts;

@end
