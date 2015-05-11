//
//  CommonAppointmentVC.h
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class comMember;

@protocol PassMember <NSObject>

-(void)passMember:(comMember *)member;

@end

@interface CommonAppointmentVC : UITableViewController

@property(nonatomic,copy)NSString *fromWhere;

@property(nonatomic,weak)id<PassMember>delegate;

@end
