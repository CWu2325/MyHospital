//
//  CacheDic.m
//  MyHospital
//
//  Created by XYQS on 15/5/23.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "CacheDic.h"

@implementation CacheDic


/**
 *  把网络请求的用户数据保存到沙盒中
 */
+ (void)saveDicDataData:(NSDictionary *)dic andFileName:(NSString *)name
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:name];
    [dic writeToFile:path atomically:YES];
}

/**
 *  //读取沙盒中得用户数据
 */
+ (NSDictionary *)getDicWithFileName:(NSString *)name
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:name];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
