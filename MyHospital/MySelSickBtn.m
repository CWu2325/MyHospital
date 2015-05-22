//
//  MySelSickBtn.m
//  MyHospital
//
//  Created by XYQS on 15/5/8.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MySelSickBtn.h"

@implementation MySelSickBtn

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //设置图片的填充模式
       // self.imageView.contentMode = UIViewContentModeCenter;
        //文字对齐方式
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        //文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        
        //高亮时候图片不变
        self.adjustsImageWhenHighlighted = NO;
        
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = self.height - 14 * 2;
    CGFloat imageH = imageW;
    CGFloat imageY = 14;
    CGFloat imageX = self.width -imageW - 15;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleH = self.height;
    CGFloat titleW = self.width - self.height;
    CGFloat titleY = 0;
    CGFloat titleX = 10;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end
