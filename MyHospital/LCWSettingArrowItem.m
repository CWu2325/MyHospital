//
//  LCWSettingArrowItem.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "LCWSettingArrowItem.h"

@implementation LCWSettingArrowItem

-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title destClass:(Class)destVC
{
    if (self = [super initWithIcon:icon andTitle:title])
    {
        self.destVC = destVC;
    }
    return self;
}

@end
