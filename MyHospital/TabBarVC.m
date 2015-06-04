//
//  TabBarVC.m
//  MyHospital
//
//  Created by apple on 15/4/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "TabBarVC.h"
#import "PersonalVC.h"
#import "MyNavigationController.h"
#import "FirstPageVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setSelectedImageTintColor:LCWBottomColor];

    FirstPageVC *gvc = [[FirstPageVC alloc]init];
    [self addChildVC:gvc title:@"就医" imageName:@"jiuyi2.png" selImageName:@"jiuyi.png"];
    

    PersonalVC *prevc = [[PersonalVC alloc]init];
    [self addChildVC:prevc title:@"我" imageName:@"wo2.png" selImageName:@"wo.png"];

}

/**
 *  tabbar
 */
-(void)addChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName
{
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selImage = [UIImage imageNamed:selImageName];
    if (IS_IOS7)
    {
        selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    childVC.tabBarItem.selectedImage = selImage;
    
    MyNavigationController *nav = [[MyNavigationController alloc]initWithRootViewController:childVC];

    [self addChildViewController:nav];
}



@end
