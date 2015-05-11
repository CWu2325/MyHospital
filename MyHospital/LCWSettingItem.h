//
//  LCWSettingItem.h
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LCWProductItemTypeArrow,
    LCWProductItemTypeSwitch
}LCWProductItemType;

typedef void (^optionBlcok)();

@interface LCWSettingItem : NSObject

@property(nonatomic,copy)NSString *icon;    //图标
@property(nonatomic,copy)NSString *title;   //标题
@property(nonatomic,copy)optionBlcok option;    //定义block保存将来要执行的代码

@property (nonatomic, assign) LCWProductItemType type;   // 定义属性保存cell后面显示什么类型辅助视图

-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title;

@end
