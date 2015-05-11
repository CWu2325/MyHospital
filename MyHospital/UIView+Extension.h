//
//  UIView+Extension.h
//  掌上医疗（纯代码）
//
//  Created by XYQS on 15/3/24.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property(nonatomic,assign) CGFloat maxX;
@property(nonatomic,assign) CGFloat maxY;
@end
