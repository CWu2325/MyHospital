//
//  CacheDic.h
//  MyHospital
//
//  Created by XYQS on 15/5/23.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDic : NSObject

/**
 *  把网络请求的用户数据保存到沙盒中
 */
+ (void)saveDicDataData:(NSDictionary *)dic andFileName:(NSString *)name;

/**
 *  //读取沙盒中得用户数据
 */
+ (NSDictionary *)getDicWithFileName:(NSString *)name;

@end
