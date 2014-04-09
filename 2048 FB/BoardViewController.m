//
//  BoardViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/8/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "BoardViewController.h"

#import "UIImage+ImageEffects.h"

#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "Theme.h"

const CGFloat kAnimationDuration_ScreenBlur = 0.2f;

@interface BoardViewController ()

@property (nonatomic, strong) Theme *theme;
@property (nonatomic, strong) UIView *latestSnapshotView;

@end

@implementation BoardViewController

-(void)setup
{
	// Initialization code here...
	GameManager *gManager = [GameManager sharedGameManager];
	self.theme = [Theme sharedThemeWithID:gManager.currentThemeID];
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
    // Do any additional setup after loading the view.
	// Setup iAd Banner
	
	// Change the corner radius of views
	self.boardView.layer.cornerRadius = self.theme.boardCornerRadius;
	self.profilePictureView.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.bestScoreView.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.scoreView.layer.cornerRadius = self.theme.buttonCornerRadius;
	for (UIView *v in self.tileContainerViews) {
		v.layer.cornerRadius = self.theme.tileCornerRadius;
	}
	
	// Change the color of views
	self.boardView.backgroundColor = self.theme.boardColor;
	self.profilePictureView.backgroundColor = self.theme.tileContainerColor;
	self.menuView.backgroundColor = self.theme.settingsPageColor;
	self.bestScoreView.backgroundColor = self.theme.boardColor;
	self.scoreView.backgroundColor = self.theme.boardColor;
	for (UIView *v in self.tileContainerViews) {
		v.backgroundColor = self.theme.tileContainerColor;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear: animated];
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

// iAd banner view delegate methods:
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	return !willLeave; // If the ad leaves the application, don't allow it.
}

-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
	// Taking snapshot:
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0f);
	[self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
	UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIColor *blurtTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
	snapshot = [snapshot applyBlurEffectWithRadius:5.0f tintColor:blurtTintColor];
	self.latestSnapshotView = [[UIImageView alloc] initWithImage:snapshot];
	CGRect snapshotMaskFrame = self.latestSnapshotView.frame;
	snapshotMaskFrame.size.height -= self.iAdBannerView.frame.size.height;
	CAShapeLayer *mask = (CAShapeLayer *)self.latestSnapshotView.layer.mask;
	mask.frame = snapshotMaskFrame;

	self.latestSnapshotView.alpha = 0.0f;
	[self.view addSubview:self.latestSnapshotView];
	[self.view bringSubviewToFront:self.latestSnapshotView];
	[UIView animateWithDuration:kAnimationDuration_ScreenBlur
					 animations:^{
						 self.latestSnapshotView.alpha = 1.0f;
					 }];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
	
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
	[UIView animateWithDuration:kAnimationDuration_ScreenBlur
					 animations:^{
						 self.latestSnapshotView.alpha = 0.0f;
					 } completion:^(BOOL finished) {
						 self.latestSnapshotView = nil;
					 }];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	
}

@end
