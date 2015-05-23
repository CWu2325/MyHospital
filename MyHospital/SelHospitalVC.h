//
//  SelHospitalVC.h
//  MyHospital
//
//  Created by XYQS on 15/4/28.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface SelHospitalVC : UIViewController


@property(nonatomic,copy)NSString *formWhere;

@property(nonatomic,copy)NSString *locationCityName;                //自动定位的城市
@property(nonatomic,copy)NSString *selCityName;                     //手动选择的城市

@end
