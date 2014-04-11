//
//  ViewController.h
//  2048 FB
//
//  Created by Shuyang Sun on 3/31/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

// constant variables
extern const NSTimeInterval kViewControllerDuration_Animation;
extern const NSTimeInterval kViewControllerDuration_Delay;
extern const NSTimeInterval kViewControllerDuration_SpringDamping;
extern const NSTimeInterval kViewControllerDuration_SpringVelocity;

@interface ViewController : UIViewController <FBLoginViewDelegate>

/// The Facebook login button, may not neccesarily be shown on the screen, but is sent event when user want to log in/out.
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet UIButton *customLoginButton;

/// Handles pan gestures on the "Introduction" page.
- (void)handlePan:(UIPanGestureRecognizer *)sender;
// When the custom login UI get touched
- (IBAction)customLoginButtonTouched:(UIButton *)sender;
- (IBAction)backTapped:(UIButton *)sender;

@end
