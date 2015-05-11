//
//  XyqsApi.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.


#import "XyqsApi.h"
#import "AFNetworking.h"
#import "JsonParser.h"
#import "User.h"
#import "MBProgressHUD+MJ.h"

@implementation XyqsApi

//获取本地保存的token
+(NSString *)getToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

//注册功能
+(void)requestTelLoginWithMobile:(NSString *)mobile andPassword:(NSString *)password andCode:(NSString *)code andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/mobile_regist";
    NSDictionary *params = @{@"mobile":mobile,@"password":password,@"code":code};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSString *token = [dataDic objectForKey:@"token"];
            callback(token);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//登陆功能
+(void)requestTelLoginWithMobile:(NSString *)mobile andPassword:(NSString *)password andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/mobile_login";
    NSDictionary *params = @{@"mobile":mobile,@"password":password};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSString *token = [dataDic objectForKey:@"token"];
            callback(token);
        }
        else
        {
           [MBProgressHUD showError:@"用户名或密码错误"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

//验证电话号码是否可用
+(void)verifyTelWithMobile:(NSString *)mobile andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/verify_mobile";
    NSDictionary *params = @{@"mobile":mobile};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        callback(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

//重置密码Step1
+(void)resetPwdFirstWithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/reset_pwd";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            callback(dic);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}


//获取个人信息接口(只有电话号码)
+(void)requestUserInfoWithToken:(NSString *)token andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/userinfo";
    NSDictionary *params = @{@"token":token};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
                NSDictionary *dataDic = [dic objectForKey:@"data"];
                User *user = [JsonParser parseUserByDictionary:dataDic];
                callback(user);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//更新个人资料(完整4.14)
+(void)updateUserInfoWithParams:(NSDictionary *)params andCallBack:(Callback)callback
{
 
    NSString *path = @"http://14.29.84.4:6060/0.1/user/update_user";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [MBProgressHUD showMessage:@"正在加载"];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            callback([dic objectForKey:@"message"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}


//判断是否已经登陆
+(BOOL)isLogin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"token"])
    {
        return YES;
    }
    else
        return NO;
}

//选择区域
+(void)requestWithParentld:(long)parentld andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/area/list";
    NSDictionary *params = @{@"parentId":@(parentld)};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *areas = [JsonParser parseAreaByDictionary:dataDic];
            callback(areas);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//获取城市列表
+(void)requestCitiesListwithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/area/list";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSMutableArray *areas = [JsonParser parseAreaByDictionary:dic];
        callback(areas);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        
    }];
}

//根据城市名称返回城市ID
+(void)getCityIDWithCityNameDic:(NSDictionary *)params andCallback:(Callback)callback
{

    NSString *path = @"http://14.29.84.4:6060/0.1/area/getId";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSString *areaID = [dataDic objectForKey:@"areaId"];
            callback(areaID);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//选择医院
+(void)requestHospitalParentld:(long)areald andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/hospital/list";
    NSDictionary *params = @{@"areaId":@(areald)};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *hospitals = [JsonParser parseHospitalByDictionary:dataDic];
            callback(hospitals);
        }
        else
        {
            NSMutableArray *hospitals = [NSMutableArray array];
            callback(hospitals);
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//选择科室
+(void)requestDeptsWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/hospital/dept";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *depts = [JsonParser parseRoomByDictionary:dataDic];
            callback(depts);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
            NSMutableArray *depts = [NSMutableArray array];
            callback(depts);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//解析省下的城市
+(void)requestWithCityParentld:(long)parentld andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/area/list";
    NSDictionary *params = @{@"parentld":@(parentld)};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *cities = [JsonParser parseCityByDictionary:dataDic];
            callback(cities);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
       [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//选择医生---------->医生列表里面显示的医生
+(void)requestDoctorWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/hospital/doctor";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *doctors = [JsonParser parseDoctorByDictionary:dataDic];
            callback(doctors);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//获取医生某日上午或下午的坐诊时段列表
+(void)requestTimesWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/order/time";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *times = [JsonParser parseTimesByDictionary:dataDic];
            callback(times);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
    
}

//获取医生详情
+(void)requestDoctorDetailWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/doctor/detail";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            Doctor *doctor = [JsonParser parseDoctorDetailByDictionary:dataDic];
            callback(doctor);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//添加关注医生
+(void)requestAddDoctorAttentionWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    [MBProgressHUD showMessage:@"正在加载"];
    NSString *path = @"http://14.29.84.4:6060/0.1/myfollow/addDocFollow";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSString *message = [dic objectForKey:@"message"];
            callback(message);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//取消关注医生
+(void)requestCancerDoctorAttentionWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/myfollow/delDocFollow";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSString *message = [dic objectForKey:@"message"];
            [MBProgressHUD showSuccess:message];
            callback(message);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}


//获取常用预约人息接口
+(void)requestCommonAppointInfoAndCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/memberinfo";
    NSDictionary *params = @{@"token":[self getToken]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSMutableArray *members = [JsonParser parseCommonMemberByDictionary:dataDic];
            callback(members);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//添加常用预约人息接口
+(void)addCommonMemberWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/create_member";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在添加"];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            callback([dic objectForKey:@"message"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}


//更新常用预约人资料
+(void)updateCommonMemberWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/update_member";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            callback([dic objectForKey:@"message"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

//删除常用预约人
+(void)removeCommonMemberWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/user/remove_member";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            callback([dic objectForKey:@"message"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

//获取订单预约号
+(void)requestOrderNumWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/order/create";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            [MBProgressHUD showSuccess:@"预约成功"];
            callback([dic objectForKey:@"data"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

//取消订单
+(void)CancelOrderWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/order/cancel";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[dic objectForKey:@"returnCode"]isEqual: @(1001)])
        {
            [MBProgressHUD showSuccess:@"您已取消预约"];
            callback([dic objectForKey:@"message"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

//获取预约记录列表
+(void)requestOrderRecordListWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/orderrecord/list";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];

        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSArray *orderrecords = [JsonParser parseOrderListByDictionary:dic]; 
            callback(orderrecords);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//获取预约记录列表中的预约详情
+(void)requestOrderDetailWithParams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/orderrecord/detail";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            OrderDetail *order = [JsonParser parseOrderDetailByDictionary:dic];
            callback(order);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

//获取关注的医生列表
+(void)requestAttentionDoctorListwithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/myfollow/doctor";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSArray *attentionDoctors = [JsonParser parseAttentionDoctorByDictionary:dic];
            if (attentionDoctors.count == 0)
            {
                [MBProgressHUD showSuccess:@"暂未关注任何医生"];
            }
            else
            {
                [MBProgressHUD showSuccess:@"医生关注列表获取成功"];
            }
            callback(attentionDoctors);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}

/**
 *  银联wap支付
 */
+(void)payWithparams:(NSMutableDictionary *)params andCallBack:(Callback)callback
{
    NSString *path = @"http://14.29.84.4:6060/0.1/pay/unionpay_wap";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [MBProgressHUD showMessage:@"正在加载"];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [MBProgressHUD hideHUD];
        if ([[dic objectForKey:@"returnCode"] isEqual:@(1001)])
        {
            NSDictionary *htmldic = [dic objectForKey:@"data"];
            callback([htmldic objectForKey:@"html"]);
        }
        else
        {
            [MBProgressHUD showError:[dic objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"服务器繁忙，请稍后再试"];
    }];
}




@end
