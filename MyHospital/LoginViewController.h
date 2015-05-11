//
//  LoginViewController.h
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Passvalue <NSObject>

-(void)passvalue:(NSString *)value;

@end

@interface LoginViewController : UIViewController

@property(nonatomic,weak)id<Passvalue>delegate;
@property(nonatomic,copy)NSString *formWhere;

@end
