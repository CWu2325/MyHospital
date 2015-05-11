//
//  MyLeftBtn.m
//  MyHospital
//
//  Created by XYQS on 15/5/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyLeftBtn.h"

@implementation MyLeftBtn

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //设置图片的填充模式
       // self.imageView.contentMode = UIViewContentModeCenter;
        //文字对齐方式
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        
        //高亮时候图片不变
        self.adjustsImageWhenHighlighted = NO;
        
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = self.height;
    CGFloat imageH = imageW;
    CGFloat imageY = 0;
    CGFloat imageX = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleH = self.height;
    CGFloat titleW = self.width - self.height;
    CGFloat titleY = 0;
    CGFloat titleX = self.width - titleW;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


@end
