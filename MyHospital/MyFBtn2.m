//
//  MyFBtn2.m
//  MyHospital
//
//  Created by XYQS on 15/5/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyFBtn2.h"
#define H1 [XyqsTools getSizeWithText:@"测试" andFont:[UIFont systemFontOfSize:13]].height


@implementation MyFBtn2

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //设置图片的填充模式
        //self.imageView.contentMode = UIViewContentModeCenter;
        //文字对齐方式
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        //高亮时候图片不变
        self.adjustsImageWhenHighlighted = NO;
        
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = self.height - (24 * 2 + 5 + H1 ) * SCALEFACTOR;
    CGFloat imageW = imageH;
    CGFloat imageX = (self.width - imageW)/2;
    CGFloat imageY = 21 * SCALEFACTOR;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = H1;
    CGFloat titleW = self.width;
    CGFloat titleX = 0;
    CGFloat titleY = self.height - (24 + H1) * SCALEFACTOR;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end
