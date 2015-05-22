//
//  HttpTool.m
//  MyHospital
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 2.发送GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (success)
         {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:0 error:nil];
             success(dic);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure)
         {
             failure(error);
         }
     }];
}


+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 2.发送POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObj) {
          if (success)
          {
              NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:0 error:nil];
              success(dic);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure)
          {
              failure(error);
          }
      }];
}

@end
