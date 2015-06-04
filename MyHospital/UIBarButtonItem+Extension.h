//
//  UIBarButtonItem+Extension.h
//  MyHospital
//
//  Created by apple on 15/4/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

@end
