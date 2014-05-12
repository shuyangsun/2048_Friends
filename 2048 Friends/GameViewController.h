//
//  GameViewController.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/19/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardScene;
@class MenuTableViewControllerTransitionAnimator;

extern const NSTimeInterval kAnimationDuration_Default;
extern const NSTimeInterval kAnimationDuration_ScreenBlur;
extern const NSTimeInterval kAnimationDuration_MoveTile;
extern const NSTimeInterval kAnimationDelay_GameOver;
extern const NSTimeInterval kAnimationDuration_ScaleTile;
extern const NSTimeInterval kAnimationDuration_TextFade;
extern const NSTimeInterval kTextShowDuration;
extern const CGFloat kAnimationSpring_Damping;
extern const CGFloat kAnimationSpring_Velocity;
extern const CGFloat kBoardPanMinDistance;
extern const CGFloat kLineWidthDefault_iPhone;
// This fraction tells us how long should the animating tile takes comparing with default animation duration.
extern const CGFloat kTileMoveAnimationDurationFraction;
extern const NSUInteger kDefaultContextSavingSwipeNumber;


@interface GameViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) BoardScene *scene;
@property (nonatomic, strong) UIView *greyLayerView;
@property (nonatomic, strong) MenuTableViewControllerTransitionAnimator *menuNavigationViewControllerAnimator;

-(void)showGameEndView;
-(void)enableGestureRecognizers:(BOOL)enabled;
-(void)enableButtonAndGestureInteractions:(BOOL)enabled;

@end
