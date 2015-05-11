//
//  HeaderView.h
//  MyHospital
//
//  Created by XYQS on 15/4/15.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MYSELCOLOR [UIColor colorWithRed:41.0/255 green:192.0/255 blue:50.0/255 alpha:1]
#define MYUNSELCOLOR [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1]


@interface HeaderView : UIView

+(UIView *)getViewWithText:(NSString *)text1 andImage:(NSString *)imageName1 text:(NSString *)text2 andImage:(NSString *)imageName2 text:(NSString *)text3 andImage:(NSString *)imageName3 andTextColor:(UIColor *)color1 andTextColor:(UIColor *)color2 andTextColor:(UIColor *)color3;

@end
