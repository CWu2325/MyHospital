//
//  Room.h
//  MyHospital
//
//  Created by XYQS on 15/4/2.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property(nonatomic,copy)NSString *coverUrl;    //科室图片

@property(nonatomic)long roomID;                //科室主键
@property(nonatomic)int remainOrderCount;       //剩余号源数

@property(nonatomic,copy)NSString *introduction;

@property(nonatomic,copy)NSString *name;        //科室名称
@property(nonatomic)long parentID;              //上级科室ID


@end
