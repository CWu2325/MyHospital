//
//  AppSettingVC.m
//  MyHospital
//
//  Created by XYQS on 15/4/16.
//  Copyright (c) 2015年 XYQS. All rights reserved.
//

#import "AppSettingVC.h"

@interface AppSettingVC ()

@end

@implementation AppSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"App设置";
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return 1;
    }
    else
        return 2;
        
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"修改密码";
    }
    else if (indexPath.section)
    {
        
    }

    return cell;
}



@end
