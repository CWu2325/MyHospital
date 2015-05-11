//
//  Encrypt.h
//  MyHospital
//
//  Created by XYQS on 15/4/27.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encrypt : NSObject


+(NSString *)md5HexDigest:(NSString *)input;

+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

@end

