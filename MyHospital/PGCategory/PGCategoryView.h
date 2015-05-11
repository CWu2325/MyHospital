//
//  PGCategoryView.h
//  分级菜单
//


#import <UIKit/UIKit.h>
@class PGCategoryView;

@interface PGCategoryView : UIView

@property (nonatomic,strong) UIView *rightView;
@property (strong, nonatomic) UIImageView *toggleView;

+(PGCategoryView *)categoryRightView:(UIView *)rightView;
-(void)show;
-(void)hide;

@end
