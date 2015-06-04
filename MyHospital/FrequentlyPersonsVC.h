//
//  FrequentlyPersonsVC.h
//  MyHospital
//
//  Created by XYQS on 15/5/23.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class comMember,User;

@protocol PassMember <NSObject>

-(void)passMember:(comMember *)member;

@end

@interface FrequentlyPersonsVC : UIViewController

@property(nonatomic,copy)NSString *fromWhere;

@property(nonatomic,weak)id<PassMember>delegate;
@property(nonatomic,strong)User *user;

@end
