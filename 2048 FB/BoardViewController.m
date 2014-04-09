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
#import "TileView.h"

const CGFloat kAnimationDuration_ScreenBlur = 1.0f;
const CGFloat kAnimationDuration_SpineTile = 1.0f;
const CGFloat kAnimationDelay_GameOver = 0.0f;
const CGFloat kAnimationDuration_TextFade = 0.5f;
const CGFloat kTextShowDuration = 5.0f;

const CGFloat kBoardPanMinDistance = 5.0f;

@interface BoardViewController ()

@property (nonatomic, strong) Theme *theme;
@property (nonatomic, strong) UIView *latestSnapshotView;
@property (strong, nonatomic) NSArray *tileContainerViewsSorted;
@property (strong, nonatomic) NSMutableArray *onBoardTileViews;

-(CGRect) frameOfTileContainerAtPosition: (CGPoint) pos;

// Use this method to set the text, interact with iAd
@property (strong, nonatomic) NSTimer *lastTimer;

-(void)setTextForTextLabel: (NSString *) text;
-(void)setCanDisplayiAdBannerYES;
-(void)updateBoardFromLatestBoardData;

@end

@implementation BoardViewController

-(void)setup
{
	// Initialization code here...
	GameManager *gManager = [GameManager sharedGameManager];
	self.theme = [Theme sharedThemeWithID:gManager.currentThemeID];
	// Setup iAd
	self.canDisplayBannerAds = YES;
	self.onBoardTileViews = [NSMutableArray array];
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
	
	// Change the corner radius of views
	self.boardView.layer.cornerRadius = self.theme.boardCornerRadius;
	self.boardView.layer.masksToBounds = YES;
	self.pauseImageView.layer.cornerRadius = self.theme.boardCornerRadius;
	self.pauseImageView.layer.masksToBounds = YES;
	self.profilePictureView.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.menuView.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.bestScoreView.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.scoreView.layer.cornerRadius = self.theme.buttonCornerRadius;
	for (UIView *v in self.tileContainerViews) {
		v.layer.cornerRadius = self.theme.tileCornerRadius;
	}
	
	// Change the color of views
	self.boardView.backgroundColor = self.theme.boardColor;
	self.profilePictureView.backgroundColor = self.theme.tileContainerColor;
	self.menuView.backgroundColor = self.theme.tileColors[@(8)];
	self.bestScoreView.backgroundColor = self.theme.tileColors[@(2048)];
	self.scoreView.backgroundColor = self.theme.tileColors[@(4)];
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
	// Sort the view outlets
	if ([self.tileContainerViewsSorted count] == 0) {
		self.tileContainerViewsSorted = [self.tileContainerViews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			NSComparisonResult res = NSOrderedAscending;
			if ([obj1 isKindOfClass:[UIView class]] && [obj2 isKindOfClass:[UIView class]]) {
				UIView *v1 = obj1;
				UIView *v2 = obj2;
				if (v1.frame.origin.x > v2.frame.origin.x) {
					res = NSOrderedDescending;
				} else if (v1.frame.origin.x == v2.frame.origin.x) {
					if (v1.frame.origin.y > v2.frame.origin.y) {
						res = NSOrderedDescending;
					}
				}
			}
			return res;
		}];
	}
	
	[self updateBoardFromLatestBoardData];
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

-(void)setTextForTextLabel: (NSString *) text {
	[self.lastTimer invalidate];
	[UIView animateWithDuration:kAnimationDuration_TextFade
					 animations:^{
						 self.textLabel.alpha = 0.0f;
					 } completion:^(BOOL finished) {
						 self.textLabel.text = text;
						 if ([UIScreen mainScreen].bounds.size.height < 568 ) { // If it's an iPhone 4/4S screen
							 self.canDisplayBannerAds = NO;
						 }
						 [UIView animateWithDuration:kAnimationDuration_TextFade
										  animations:^{
											  self.textLabel.alpha = 1.0f;
										  } completion:^(BOOL finished) {
											  self.lastTimer = [NSTimer scheduledTimerWithTimeInterval:kTextShowDuration
																					   target:self
																					 selector:@selector(setCanDisplayiAdBannerYES)
																					 userInfo:nil
																					  repeats:NO];
										  }];
					 }];
}

//-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
//	// Taking snapshot:
//	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0f);
//	[self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
//	UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	UIColor *blurtTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
//	snapshot = [snapshot applyBlurEffectWithRadius:5.0f tintColor:blurtTintColor];
//	self.latestSnapshotView = [[UIImageView alloc] initWithImage:snapshot];
//	CGRect snapshotMaskFrame = self.latestSnapshotView.frame;
//	CAShapeLayer *mask = (CAShapeLayer *)self.latestSnapshotView.layer.mask;
//	mask.frame = snapshotMaskFrame;
//
//	self.latestSnapshotView.alpha = 0.0f;
//	[self.view addSubview:self.latestSnapshotView];
//	[self.view bringSubviewToFront:self.latestSnapshotView];
//	[UIView animateWithDuration:kAnimationDuration_ScreenBlur
//					 animations:^{
//						 self.latestSnapshotView.alpha = 1.0f;
//					 }];
//}
//
//-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
//	
//}
//
//-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
//	[UIView animateWithDuration:kAnimationDuration_ScreenBlur
//					 animations:^{
//						 self.latestSnapshotView.alpha = 0.0f;
//					 } completion:^(BOOL finished) {
//						 self.latestSnapshotView = nil;
//					 }];
//}
//
//-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
//	
//}


-(CGRect) frameOfTileContainerAtPosition: (CGPoint) pos {
	CGRect res = CGRectZero;
	UIView *view = self.tileContainerViewsSorted[(int)(pos.y * 4 + pos.x)];
	res = view.frame;
	return res;
}

-(void)setCanDisplayiAdBannerYES {
	self.canDisplayBannerAds = YES;
}

- (IBAction)menuTapped:(UIButton *)sender {
	[self setTextForTextLabel:[NSString stringWithFormat:@"%@", [NSDate date]]];
}

- (IBAction)boardPanned:(UIPanGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		int x = [sender translationInView:self.boardView].x;
		int y = [sender translationInView:self.boardView].y;
		if (fabs(x) >= fabs(y) && fabs(x) > kBoardPanMinDistance) {
			if (x > 0) {
				[[Board latestBoard] swipedToDirection:BoardSwipeGestureDirectionRight];
			} else {
				[[Board latestBoard] swipedToDirection:BoardSwipeGestureDirectionLeft];
			}
			[self updateBoardFromLatestBoardData];
		} else if (fabs(y) > fabs(x) && fabs(y) > kBoardPanMinDistance) {
			if (y > 0) {
				[[Board latestBoard] swipedToDirection:BoardSwipeGestureDirectionDown];
			} else {
				[[Board latestBoard] swipedToDirection:BoardSwipeGestureDirectionUp];
			}
			[self updateBoardFromLatestBoardData];
		}
	} else if (sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
		
	}
}

- (IBAction)retryOrKeepPlayingTapped:(UIButton *)sender {
	if (sender.tag == 0) {
		self.pauseView.alpha = 0.0f;
		[Board initializeNewBoard];
		[self updateBoardFromLatestBoardData];
		self.panGestureRecognizer.enabled = YES;
	}
}

-(void)updateBoardFromLatestBoardData {
	for (UIView *tView in [self.boardView subviews]) {
		if ([tView isKindOfClass:[TileView class]]) {
			[tView removeFromSuperview];
		}
	}
	for (size_t i = 0; i <= [self.onBoardTileViews count]; ++i) {
		[self.onBoardTileViews removeObject:[self.onBoardTileViews lastObject]];
	}
	[self.boardView setNeedsDisplay];
	Board *board = [Board latestBoard];
	NSArray *gameData = [board getBoardDataArray];
	for (size_t i = 0; i < 4; ++i) {
		for (size_t j = 0; j < 4; ++j) {
			int val = [gameData[i][j] intValue];
			if (val) { // If there is a tile
				CGRect frame = [self frameOfTileContainerAtPosition:CGPointMake(i, j)];
				TileView *tView = [[TileView alloc] initWithFrame:frame];
				tView.text = [Tile tileWithValue: val].text;
				tView.backgroundColor = [self.theme tileColors][@(val)];
				[self.onBoardTileViews addObject:tView];
				[self.boardView addSubview:tView];
				[self.boardView bringSubviewToFront:tView];
				tView.layer.cornerRadius = [self.theme tileCornerRadius];
				tView.layer.masksToBounds = YES;
				tView.label.textColor = [self.theme textColor];
			}
		}
	}
	[self.boardView bringSubviewToFront:self.boardViewInteractionLayer];
	self.bestScoreLabel.text = [NSString stringWithFormat:@"%d", [GameManager sharedGameManager].bestScore];
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", board.score];
	if (board.gameplaying == NO) {
		self.panGestureRecognizer.enabled = NO;
		self.pauseView.alpha = 0.0f;
				[self.boardView bringSubviewToFront:self.pauseView];
		[self.pauseView bringSubviewToFront:self.pauseImageView];
		[self.pauseView bringSubviewToFront:self.gameStatusLabel];
		[self.pauseView bringSubviewToFront:self.shareButton];
		[self.pauseView bringSubviewToFront:self.retryOrKeepPlayingButton];
		self.retryOrKeepPlayingButton.titleLabel.text = @"Play Again";
		self.retryOrKeepPlayingButton.tag = 0;
		for (UIView *tView in self.onBoardTileViews) {
			CGAffineTransform transform = tView.transform;
			[UIView animateWithDuration:kAnimationDuration_SpineTile
								  delay:kAnimationDelay_GameOver
				 usingSpringWithDamping:0.4f
				  initialSpringVelocity:0.6f
								options:UIViewAnimationOptionCurveLinear
							 animations:^{
								 tView.transform = CGAffineTransformScale(transform, 1.1f, 1.1f);
							 }
							 completion:^(BOOL finished){
								 [UIView animateWithDuration:kAnimationDuration_SpineTile
													   delay:kAnimationDelay_GameOver
									  usingSpringWithDamping:0.4f
									   initialSpringVelocity:0.6f
													 options:UIViewAnimationOptionCurveLinear
												  animations:^{
													  tView.transform = CGAffineTransformIdentity;
												  }
												  completion:nil];
							 }];
		}
		UIGraphicsBeginImageContextWithOptions(self.boardView.bounds.size, YES, 0.0f);
		[self.boardView drawViewHierarchyInRect:self.boardView.bounds afterScreenUpdates:YES];
		UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		UIColor *blurtTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.7f];
		snapshot = [snapshot applyBlurEffectWithRadius:5.0f tintColor:blurtTintColor];
		self.pauseImageView.image = snapshot;

		[UIView animateWithDuration:kAnimationDuration_ScreenBlur
							  delay:kAnimationDuration_SpineTile
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.pauseView.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {
							 [self.view bringSubviewToFront:self.pauseView];
						 }];
	} else {
		self.pauseView.alpha = 0.0f;
	}
}

@end
