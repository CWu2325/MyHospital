//
//  PersonInfoCell.h
//  MyHospital
//
//  Created by XYQS on 15/3/30.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PersonInfoCell : UITableViewCell

@property(nonatomic,strong)UIImageView *useImageView;
@property(nonatomic,strong)UILabel *useNameLabel;
@property(nonatomic,strong)UILabel *useTelLabel;


@property(nonatomic,copy)NSString *value;
@property(nonatomic,strong)User *user;

-(id)init;
@end
