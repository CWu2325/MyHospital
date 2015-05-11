//
//  MemberInfoVC.h
//  MyHospital
//
//  Created by XYQS on 15/4/14.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comMember.h"

@interface MemberInfoVC : UIViewController
@property(nonatomic,copy)NSString *fromWhere;
@property(nonatomic,strong)comMember *member;
@end
