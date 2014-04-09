//
//  BoardViewController.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/8/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

extern const CGFloat kAnimationDuration_ScreenBlur;
extern const CGFloat kAnimationDuration_TextFade;
extern const CGFloat kTextShowDuration;
extern const CGFloat kBoardPanMinDistance;

@interface BoardViewController : UIViewController <ADBannerViewDelegate>

// Upper screen views
@property (weak, nonatomic) IBOutlet UIView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIButton *menuView;
@property (weak, nonatomic) IBOutlet UIView *bestScoreView;
@property (weak, nonatomic) IBOutlet UIView *scoreView;

// On board views
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *tileContainerViews;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

- (IBAction)menuTapped:(UIButton *)sender;
- (IBAction)boardPanned:(UIPanGestureRecognizer *)sender;

@end
