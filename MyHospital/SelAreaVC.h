//
//  SelAreaVC.h
//  MyHospital
//
//  Created by XYQS on 15/4/28.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Area;

@protocol  MyProtocol <NSObject>

-(void)passValue:(Area *)area;

@end

@interface SelAreaVC : UIViewController

@property(nonatomic,weak)id<MyProtocol>delegate;

@property(nonatomic,copy)NSString *locationCityName;            //自动定位的城市名称

@end
