//
//  XyqsTools.h
//  MyHospital
//
//  Created by XYQS on 15/4/10.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XyqsTools : NSObject

//得到字体的空间大小
+(CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font;

//动态获取字体空间大小
+(CGSize)getSizeByText:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width;

//通过正则表达式判断输入的号码是不是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//浮点数处理并去掉多余的0
+(NSString *)stringDisposeWithFloat:(float)floatValue;

//获得一定范围的颜色
//+ (UIImage *)imageWithColor:(UIColor *)color;

@end
