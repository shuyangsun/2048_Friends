//
//  TFFBViewController.h
//  2048 FB
//
//  Created by Shuyang Sun on 3/31/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

// constant variables:
const CGFloat kTTFBViewController_ButtonCornerRadiusDefault = 3.0f;

@interface TFFBViewController : UIViewController <FBLoginViewDelegate>

/// The Facebook login button, may not neccesarily be shown on the screen, but is sent event when user want to log in/out.
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
/// Indicates how what is the current page for the "Introduction" guid.
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *customLoginButton;

/// Handles pan gestures on the "Introduction" page.
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;
// When the custom login UI get touched
- (IBAction)customLoginButtonTouched:(UIButton *)sender;

@end
