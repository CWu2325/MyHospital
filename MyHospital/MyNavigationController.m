//
//  MyNavigationController.m
//  MyHospital
//
//  Created by apple on 15/4/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



+(void)initialize
{
    //设置导航栏背景
    [self setupUINavigation];
    
    
    //设置UIBarButtonItem主题
    [self setupUIBarButtonItem];
}

//设置导航栏主题
+(void)setupUINavigation
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    //设置导航栏背景
    [appearance setBackgroundImage:[UIImage imageNamed:@"nav_background.png"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs];
    
}

//设置UIBarButtonItem主题
+(void)setupUIBarButtonItem
{
    //通过appearance能修改整个项目中所有UIBarbarButtonItem样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    //设置普通状态文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置高亮状态文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    //设置不可用状态文字属性
    NSMutableDictionary *disabletextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disabletextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:disabletextAttrs forState:UIControlStateNormal];
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        //设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back-icon@2x.png" highImageName:@"back-icon@2x.png" target:self action:@selector(back)];
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"goback_homepage@2x.png" highImageName:@"goback_homepage@2x.png" target:self action:@selector(home)];
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

-(void)home
{
    [self popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
