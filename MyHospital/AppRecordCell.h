//
//  AppRecordCell.h
//  MyHospital
//
//  Created by XYQS on 15/4/1.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRecord.h"

@protocol MyTableViewCellDelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell;

@end


@interface AppRecordCell : UITableViewCell

@property(nonatomic,strong)OrderRecord *orderList;

@property(nonatomic,weak)id<MyTableViewCellDelegate>delegate;

@end
