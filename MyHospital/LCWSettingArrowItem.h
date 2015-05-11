//
//  LCWSettingArrowItem.h
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "LCWSettingItem.h"

@interface LCWSettingArrowItem : LCWSettingItem

@property(nonatomic,assign)Class destVC;    //目标跳转控制器

-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title destClass:(Class)destVC;

@end
