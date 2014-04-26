//
//  GameViewController.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/19/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSTimeInterval kAnimationDuration_Default;
extern const NSTimeInterval kAnimationDuration_ScreenBlur;
extern const NSTimeInterval kAnimationDuration_MoveTile;
extern const NSTimeInterval kAnimationDelay_GameOver;
extern const NSTimeInterval kAnimationDuration_ScaleTile;
extern const NSTimeInterval kAnimationDuration_TextFade;
extern const NSTimeInterval kTextShowDuration;
extern const CGFloat kTileMoveAnimationDurationFraction;
extern const CGFloat kAnimationSpring_Damping;
extern const CGFloat kAnimationSpring_Velocity;
extern const CGFloat kBoardPanMinDistance;
extern const CGFloat kLineWidthDefault_iPhone;
extern const NSUInteger kDefaultContextSavingSwipeNumber;


@interface GameViewController : UIViewController

- (IBAction)menuButtonTapped:(UIButton *)sender;
-(void)showGameEndView;
-(void)enableGestureRecognizers:(BOOL)enabled;
-(void)enableButtonAndGestureInteractions:(BOOL)enabled;

@end
