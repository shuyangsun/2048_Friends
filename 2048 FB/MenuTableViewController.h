//
//  MenuTableViewController.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/27/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Theme;

@interface MenuTableViewController : UITableViewController

@property (nonatomic, strong) Theme *theme;

-(void)dismissNavigationBarController;

@end
