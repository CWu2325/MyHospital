//
//  LCWSettingGroup.h
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCWSettingGroup : NSObject

@property(nonatomic,copy)NSString *headerTitle;     //头部标题
@property(nonatomic,copy)NSString *footerTitle;     //底部标题

@property(nonatomic,strong)NSArray *items;

@end
