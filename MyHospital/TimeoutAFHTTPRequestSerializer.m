//
//  TimeoutAFHTTPRequestSerializer.m
//  MyHospital
//
//  Created by XYQS on 15/4/29.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "TimeoutAFHTTPRequestSerializer.h"

@implementation TimeoutAFHTTPRequestSerializer


-(id)initWithTimeout:(NSTimeInterval)timeout
{
    if (self = [super init])
    {
        self.timeout = timeout;
    }
    return self;
}

-(NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    if (self.timeout > 0)
    {
        [request setTimeoutInterval:self.timeout];
    }
    return request;
}



@end
