//
//  HeaderView.m
//  MyHospital
//
//  Created by XYQS on 15/4/15.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView





+(UIView *)getViewWithText:(NSString *)text1 andImage:(NSString *)imageName1 text:(NSString *)text2 andImage:(NSString *)imageName2 text:(NSString *)text3 andImage:(NSString *)imageName3 andTextColor:(UIColor *)color1 andTextColor:(UIColor *)color2 andTextColor:(UIColor *)color3
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName1]];
    UIImageView *imageV2 = [[UIImageView alloc]init];
    imageV2.backgroundColor = MYSELCOLOR;
    UIImageView *imageV3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName2]];
    UIImageView *imageV4 = [[UIImageView alloc]init];
    imageV4.backgroundColor = MYSELCOLOR;
    UIImageView *imageV5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName3]];

    imageV1.x = 30;
    imageV1.y = 20;
    imageV1.width = 30;
    imageV1.height = 30;
    
    imageV2.width =  (WIDTH-30*2-imageV1.width*3)/2;
    imageV2.height = 1.5;
    imageV2.x = imageV1.maxX;
    imageV2.y = imageV1.centerY;
    
    imageV3.x = imageV2.maxX;
    imageV3.y = imageV1.y;
    imageV3.size = imageV1.size;
    
    imageV4.x = imageV3.maxX;
    imageV4.y = imageV2.y;
    imageV4.size = imageV2.size;
    
    imageV5.x = imageV4.maxX;
    imageV5.y = imageV1.y;
    imageV5.size = imageV1.size;
    
    [headerView addSubview:imageV1];
    [headerView addSubview:imageV2];
    [headerView addSubview:imageV3];
    [headerView addSubview:imageV4];
    [headerView addSubview:imageV5];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = text1;
    label1.textColor = color1;
    label1.font = [UIFont systemFontOfSize:12];
    label1.x = 5;
    label1.y = imageV1.maxY + 5;
    CGFloat labelMaxWidth = WIDTH/3 - label1.x*2;
    CGSize size = [XyqsTools getSizeByText:label1.text andFont:label1.font andWidth:labelMaxWidth];
    label1.height = [XyqsTools getSizeWithText:label1.text andFont:label1.font].height;
    label1.width = size.width;
    label1.centerX = imageV1.centerX;
    if (label1.width/2 >imageV1.centerX - 5)
    {
        label1.x = 5;
    }
    
    [headerView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = text2;
    label2.textColor = color2;
    label2.font = label1.font;
    label2.x = 10;
    label2.y = label1.y;
    label2.size = [XyqsTools getSizeByText:label2.text andFont:label2.font andWidth:labelMaxWidth];
    label2.centerX = imageV3.centerX;
    [headerView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = text3;
    label3.textColor = color3;
    label3.font = label1.font;
    label3.y = label1.y;
    label3.size = [XyqsTools getSizeByText:label3.text andFont:label3.font andWidth:labelMaxWidth];
    label3.x = WIDTH - 5 -label3.size.width;
    [headerView addSubview:label3];
    label3.centerX = imageV5.centerX;

    //分割线
    UIView *view = [[UIView alloc]init];
    view.x = 0;
    view.y = 89;
    view.width = WIDTH;
    view.height = 1;
    view.backgroundColor = LCWDivisionLineColor;
    [headerView addSubview:view];
    
    return headerView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
