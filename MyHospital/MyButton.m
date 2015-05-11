//
//  MyButton.m
//  掌上医疗（纯代码）
//
//  Created by XYQS on 15/3/25.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyButton.h"

@interface MyButton()

@property(nonatomic)CGRect boundingRect;

@end

@implementation MyButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = self.frame.size.width/2 + self.boundingRect.size.width/2;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat imageY = contentRect.origin.y + 14;
    CGFloat width = 24;
    CGFloat heigth = 24;
    return CGRectMake(imageX, imageY, width, heigth);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX=(self.frame.size.width-self.boundingRect.size.width)/2;
    CGFloat imageY=contentRect.origin.y+10;
    CGFloat width=220;
    CGFloat height=25;
    return CGRectMake(imageX, imageY, width, height);
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
