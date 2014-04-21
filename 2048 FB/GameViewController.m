//
//  GameViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/19/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "GameViewController.h"
#import <iAd/iAd.h>
#import "AppDelegate.h"
#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "Theme.h"

#import "BoardScene.h"

// Constants
const CGFloat kAnimationDuration_Default = 0.1f;
const CGFloat kAnimationDuration_ScreenBlur = 1.0f;
const CGFloat kAnimationDuration_ScaleTile = 1.0f;
const CGFloat kAnimationDuration_MoveTile = 0.25f;
const CGFloat kAnimationDelay_GameOver = 0.0f;
const CGFloat kAnimationDuration_TextFade = 0.5f;
const CGFloat kAnimationSpring_Damping = 0.5f;
const CGFloat kAnimationSpring_Velocity = 0.4f;
const CGFloat kTextShowDuration = 5.0f;

const CGFloat kBoardPanMinDistance = 5.0f;
const CGFloat kLineWidthDefault_iPhone = 8.0f;

const NSUInteger kDefaultContextSavingSwipeNumber = 10;

@interface GameViewController ()

// IBOutlets in interface builder
@property (weak, nonatomic) IBOutlet UIView *profilePictureView;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet SKView *boardSKView;
@property (weak, nonatomic) IBOutlet UIView *boardInteractionLayerVIew;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

// Other properties
@property (strong, nonatomic) Theme *theme;
@property (strong, nonatomic) BoardScene *scene;

@end

@implementation GameViewController


-(void)setup
{
	// Initialization code here...
	
	GameManager *gManager = [GameManager sharedGameManager];
	self.theme = [Theme sharedThemeWithID:gManager.currentThemeID];
	self.canDisplayBannerAds = YES;
}

-(void)awakeFromNib
{
	[self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self updateThemeAnimated:NO];
    // SpriteKit stuff
    SKView * skView = (SKView *)self.boardSKView;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    self.scene = [BoardScene sceneWithSize:skView.bounds.size andTheme:self.theme];
	if (!self.theme) {
		GameManager *gManager = [GameManager sharedGameManager];
		self.theme = [Theme sharedThemeWithID:gManager.currentThemeID];
	}
	self.scene.theme = self.theme;
    self.scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:self.scene];
}

-(void)updateThemeAnimated:(BOOL) animated {
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration_ScreenBlur
							  delay:0.0f
							options:UIViewAnimationOptionCurveEaseIn
						 animations:^{
							 [self setThemeDataForViews];
						 } completion:nil];
	} else {
		[self setThemeDataForViews];
	}
}

-(void)setThemeDataForViews {
	// Change the corner radius of views
	self.originalContentView.backgroundColor = self.theme.backgroundColor;
	self.boardSKView.layer.cornerRadius = self.theme.boardCornerRadius;
	self.boardSKView.layer.masksToBounds = YES;
//	self.pauseView.layer.cornerRadius = self.theme.boardCornerRadius;
//	self.pauseView.layer.masksToBounds = YES;
//	self.pauseImageView.layer.cornerRadius = self.theme.boardCornerRadius;
//	self.pauseImageView.layer.masksToBounds = YES;
	self.profilePictureView.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.profilePictureView.layer.masksToBounds = YES;
	self.profilePictureButton.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.profilePictureButton.layer.masksToBounds = YES;
	self.menuButton.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.bestScoreLabel.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.scoreLabel.layer.cornerRadius = self.theme.buttonCornerRadius;
//	for (UIView *v in self.tileContainerViews) {
//		v.layer.cornerRadius = self.theme.tileCornerRadius;
//		v.layer.masksToBounds = YES;
//	}
	
	// Change the color of views
	self.boardSKView.backgroundColor = self.theme.boardColor;
	self.profilePictureView.backgroundColor = self.theme.tileContainerColor;
	self.menuButton.backgroundColor = self.theme.tileColors[@(8)];
	self.boardSKView.backgroundColor = self.theme.tileColors[@(2048)];
	self.scoreLabel.backgroundColor = self.theme.tileColors[@(4)];
//	self.retryOrKeepPlayingButton.titleLabel.textColor = [UIColor whiteColor];
//	self.retryOrKeepPlayingButton.backgroundColor = self.theme.tileColors[@(8)];
//	self.retryOrKeepPlayingButton.layer.cornerRadius = self.theme.buttonCornerRadius;
//	self.retryOrKeepPlayingButton.layer.masksToBounds = YES;
//	self.shareButton.titleLabel.textColor = [UIColor whiteColor];
//	self.shareButton.backgroundColor = self.theme.tileColors[@(8)];
//	self.shareButton.layer.cornerRadius = self.theme.buttonCornerRadius;
//	self.shareButton.layer.masksToBounds = YES;
//	for (UIView *v in self.tileContainerViews) {
//		v.backgroundColor = self.theme.tileContainerColor;
//	}
//	for (UIView *tView in self.onBoardTileViews) {
//		if ([tView isKindOfClass:[TileView class]]) {
//			tView.backgroundColor = self.theme.tileColors[@(((TileView *)tView).val)];
//			tView.layer.cornerRadius = self.theme.tileCornerRadius;
//			tView.layer.masksToBounds = YES;
//		}
//	}
}

-(BOOL)prefersStatusBarHidden {
	return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
