//
//  NewfeatureVC.m
//  MyHospital
//
//  Created by apple on 15/4/4.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "NewfeatureVC.h"
#import "TabBarVC.h"

@interface NewfeatureVC ()

@end

@implementation NewfeatureVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    for (int i = 0; i < 4; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"splash_img%d.png",i+1]];
        UIImageView *iv = [[UIImageView alloc]initWithImage:image];
        iv.x = i * sv.width;
        iv.y = 0;
        iv.width = sv.width;
        iv.height = sv.height;
        [sv addSubview:iv];
        
        if (i == 3)
        {
            UIButton *button = [[UIButton alloc]initWithFrame:self.view.bounds];
            button.x = i * sv.width;
            [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            [sv addSubview:button];
        }
        
    }
    sv.contentSize = CGSizeMake(4*sv.width, sv.height);
    sv.pagingEnabled = YES;
    [self.view addSubview:sv];
}

-(void)btnAction
{
    TabBarVC *vc =[[TabBarVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
