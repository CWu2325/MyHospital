//
//  TimeoutAFHTTPRequestSerializer.h
//  MyHospital
//
//  Created by XYQS on 15/4/29.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AFURLRequestSerialization.h"

@interface TimeoutAFHTTPRequestSerializer : AFHTTPRequestSerializer

@property(nonatomic,assign)NSTimeInterval timeout;

-(id)initWithTimeout:(NSTimeInterval)timeout;

@end
