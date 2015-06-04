//
//  TimeoutView.h
//  MyHospital
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeOutDelegate <NSObject>

- (void)tapTimeOutBtnAction;

@end

@interface TimeoutView : UIView

@property(nonatomic,weak)id<TimeOutDelegate>delegate;

@end
