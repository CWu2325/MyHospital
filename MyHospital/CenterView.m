//
//  CenterView.m
//  MyHospital
//
//  Created by XYQS on 15/4/29.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "CenterView.h"

@implementation CenterView

+(UIView *)getCenterView
{
    CGFloat diviWidth = WIDTH/8;
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, diviWidth *3)];
    centerView.backgroundColor = LCWRandomColor;
    
    for (int i = 0 ; i < 4; i++)
    {
        UIImageView *horizontalIV = [[UIImageView alloc]init];
        horizontalIV.backgroundColor = [UIColor lightGrayColor];
        horizontalIV.x = 0;
        horizontalIV.y = i * diviWidth;
        horizontalIV.width = (WIDTH-diviWidth) *2;
        horizontalIV.height = 1;
        [centerView addSubview:horizontalIV];
    }
    
    
    for (int i = 0 ; i < 8; i++)
    {
        //竖直分割线
        UIImageView *divisionIv= [[UIImageView alloc]init];
        divisionIv.backgroundColor = [UIColor lightGrayColor];
        divisionIv.x = i * diviWidth;
        divisionIv.y = 0;
        divisionIv.width = 1;
        divisionIv.height = diviWidth * 3;
        [centerView addSubview:divisionIv];
        
        if (i == 0)
        {
            UILabel *amLabel = [[UILabel alloc]init];
            amLabel.text = @"上午";
            amLabel.font = [UIFont systemFontOfSize:15];
            amLabel.x = 0;
            amLabel.y = diviWidth;
            amLabel.width = diviWidth;
            amLabel.height = diviWidth;
            [centerView addSubview:amLabel];
            
            UILabel *pmLabel = [[UILabel alloc]init];
            pmLabel.text = @"下午";
            pmLabel.font = [UIFont systemFontOfSize:15];
            pmLabel.x = 0;
            pmLabel.y = 2 *diviWidth;
            pmLabel.size = amLabel.size;
            [centerView addSubview:pmLabel];
        }
        else
        {
            //星期标签
            UILabel *weakLabel = [[UILabel alloc]init];
            weakLabel.x = i * diviWidth;
            weakLabel.y = 0;
            weakLabel.width = diviWidth;
            weakLabel.height = diviWidth/2;
            weakLabel.textAlignment = NSTextAlignmentCenter;
            weakLabel.font = [UIFont systemFontOfSize:12];
            weakLabel.text = @"星期";
            [centerView addSubview:weakLabel];
            
            //日期标签
            UILabel *dateLabel = [[UILabel alloc]init];
            dateLabel.x = i * diviWidth;
            dateLabel.y = weakLabel.maxY;
            dateLabel.width = diviWidth;
            dateLabel.height = diviWidth/2;
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.font = weakLabel.font;
            dateLabel.text = @"日期";
            [centerView addSubview:dateLabel];
        }
    }
    return centerView;
}



@end
