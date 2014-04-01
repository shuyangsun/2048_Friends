//
//  TFFBStartPageViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 3/31/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "TFFBStartPageViewController.h"

@interface TFFBStartPageViewController ()

@end

@implementation TFFBStartPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	 viewControllerBeforeViewController:(UIViewController *)viewController {
	
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerAfterViewController:(UIViewController *)viewController {
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
