//
//  LCWSettingItem.m
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "LCWSettingItem.h"

@implementation LCWSettingItem

-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title
{
    if (self = [super init])
    {
        self.icon = icon;
        self.title = title;
    }
    return self;
}

@end
