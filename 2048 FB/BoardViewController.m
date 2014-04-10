//
//  BoardViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/8/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "BoardViewController.h"

#import "UIImage+ImageEffects.h"

#import "AppDelegate.h"
#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "Theme.h"
#import "TileView.h"

const CGFloat kAnimationDuration_Default = 0.1f;
const CGFloat kAnimationDuration_ScreenBlur = 1.0f;
const CGFloat kAnimationDuration_ScaleTile = 1.0f;
const CGFloat kAnimationDuration_MoveTile = 0.5f;
const CGFloat kAnimationDelay_GameOver = 0.0f;
const CGFloat kAnimationDuration_TextFade = 0.5f;
const CGFloat kAnimationSpring_Damping = 0.3f;
const CGFloat kAnimationSpring_Velocity = 0.6f;
const CGFloat kTextShowDuration = 5.0f;

const CGFloat kBoardPanMinDistance = 5.0f;
const CGFloat kLineWidthDefault_iPhone = 8.0f;

@interface BoardViewController ()

@property  (nonatomic) BoardViewControllerMode mode;
@property (nonatomic, strong) Theme *theme;
@property (nonatomic, strong) UIView *latestSnapshotView;
@property (strong, nonatomic) NSArray *tileContainerViewsSorted;
@property (strong, nonatomic) NSMutableArray *onBoardTileViews;

-(CGRect) frameOfTileContainerAtPosition: (CGPoint) pos;
-(CGPoint) positionOfTileContainerAtFrame: (CGRect) frame;

-(void)startLeftSwipeAnimation;
-(void)startRightSwipeAnimation;
-(void)startUpSwipeAnimation;
-(void)startDownSwipeAnimation;

-(void) animateTileView: (TileView *) tView intoPosition: (CGPoint) posEnd;

-(BOOL) saveContext;

// Use this method to set the text, interact with iAd
@property (strong, nonatomic) NSTimer *lastTimer;

-(void)setTextForTextLabel: (NSString *) text;
-(void)setCanDisplayiAdBannerYES;
-(void)updateBoardFromBoard: (Board *)board;
-(void)updateBoardFromLatestBoardData;
-(void)enableGestureRecognizers: (BOOL) enable;


@end

@implementation BoardViewController

-(void)setup
{
	// Initialization code here...
	// Save context every 10 seconds:
	
	GameManager *gManager = [GameManager sharedGameManager];
	self.theme = [Theme sharedThemeWithID:gManager.currentThemeID];
	// Setup iAd
	self.canDisplayBannerAds = YES;
	self.onBoardTileViews = [NSMutableArray array];
	for (size_t i = 0; i < 4; ++i) {
		[self.onBoardTileViews addObject:[NSMutableArray array]];
	}
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
	self.pauseView.layer.cornerRadius = self.theme.boardCornerRadius;
	self.pauseView.layer.masksToBounds = YES;
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
				if (v1.frame.origin.y < v2.frame.origin.y) {
					res = NSOrderedAscending;
				} else if (v1.frame.origin.y == v2.frame.origin.y) {
					if (v1.frame.origin.x < v2.frame.origin.x) {
						res = NSOrderedAscending;
					}
				}
			}
			return res;
		}];
	}
	
	[self updateBoardFromLatestBoardData];
}

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

-(CGRect) frameOfTileContainerAtPosition: (CGPoint) pos {
	CGRect res = CGRectZero;
	UIView *view = self.tileContainerViewsSorted[(int)(pos.y * 4 + pos.x)];
	res = view.frame;
	return res;
}

-(CGPoint) positionOfTileContainerAtFrame: (CGRect) frame {
	return CGPointMake(frame.origin.x/(((UIView *)[self.tileContainerViews lastObject]).frame.size.width + kLineWidthDefault_iPhone), frame.origin.y/(((UIView *)[self.tileContainerViews lastObject]).frame.size.height + kLineWidthDefault_iPhone));
}

-(void)setCanDisplayiAdBannerYES {
	self.canDisplayBannerAds = YES;
}

- (IBAction)menuTapped:(UIButton *)sender {
	[self setTextForTextLabel:[NSString stringWithFormat:@"%@", [NSDate date]]];
	[self updateBoardFromLatestBoardData];
}

-(void) animateTileView: (TileView *) tView intoPosition: (CGPoint) posEnd {
	
	CGRect frameEnd = [self frameOfTileContainerAtPosition:posEnd];
	
	TileView *newTileView;
	if (tView.nextTileView) {
		// tView is behind join view
		[self.boardView bringSubviewToFront:tView.nextTileView];
		[self.boardView bringSubviewToFront:tView];
		
		// Add the new tile as the subview of the joining tile.
		CGRect frame = tView.nextTileView.bounds;
		int32_t val = tView.val * 2;
		newTileView = [[TileView alloc] initWithFrame:frame];
		newTileView.text = [Tile tileWithValue: val].text;
		newTileView.backgroundColor = self.theme.tileColors[@(val)];
		[tView.nextTileView addSubview:newTileView];
		[tView.nextTileView bringSubviewToFront:newTileView];
		newTileView.layer.cornerRadius = self.theme.tileCornerRadius;
		newTileView.layer.masksToBounds = YES;
		newTileView.textColor = (val <= 4 ? self.theme.tileTextColor:[UIColor whiteColor]);
		newTileView.alpha = 0.0f;
		[newTileView setNeedsDisplay];
	}
	
	[UIView animateWithDuration:kAnimationDuration_MoveTile
						  delay:0.0f
		 usingSpringWithDamping:kAnimationSpring_Damping
		  initialSpringVelocity:kAnimationSpring_Velocity
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 tView.frame = frameEnd;
					 }
					 completion:^(BOOL finished) {
						 if (tView.nextTileView) { // If there is a next tile
							 [UIView animateWithDuration:kAnimationDuration_Default/2.0f
												   delay:0.0f
								  usingSpringWithDamping:kAnimationSpring_Damping
								   initialSpringVelocity:kAnimationSpring_Velocity
												 options:UIViewAnimationOptionCurveEaseOut
											  animations:^{
												  CGFloat scaleFactor = 1.0f + ((self.boardView.bounds.size.width - tView.bounds.size.width * 4.0f)/5.0f)/(tView.bounds.size.width);
												  newTileView.alpha = 1.0f;
												  CGAffineTransform transform = tView.nextTileView.transform;
												  tView.nextTileView.transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);
											  }
											  completion:^(BOOL finished) {
												  [UIView animateWithDuration:kAnimationDuration_Default/2.0f
																		delay:0.0f
													   usingSpringWithDamping:kAnimationSpring_Damping
														initialSpringVelocity:kAnimationSpring_Velocity
																	  options:UIViewAnimationOptionCurveEaseOut
																   animations:^{
																	   tView.nextTileView.transform = CGAffineTransformIdentity;
																   }
																   completion:nil];
											  }];
						 }
					 }];
}

- (IBAction)retryOrKeepPlayingTapped:(UIButton *)sender {
	if (sender.tag == 0) {
		self.pauseView.alpha = 0.0f;
		[Board initializeNewBoard];
		[self updateBoardFromLatestBoardData];
		[self enableGestureRecognizers:YES];
	}
}

- (IBAction)boardSwiped:(UISwipeGestureRecognizer *)sender {
	BoardSwipeGestureDirection direction;
	if (sender.state == UIGestureRecognizerStateBegan) {
		
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		
		if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
			direction = BoardSwipeGestureDirectionRight;
			[self startRightSwipeAnimation];
		} else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
			direction = BoardSwipeGestureDirectionLeft;
			[self startLeftSwipeAnimation];
		} else if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
			direction = BoardSwipeGestureDirectionUp;
			[self startUpSwipeAnimation];
		} else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
			direction = BoardSwipeGestureDirectionDown;
			[self startDownSwipeAnimation];
		}
		
		Board *board = [[Board latestBoard] swipedToDirection:direction];
		// TODO animation for the new random tile
	} else if (sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {
		
	}
}

-(void)startLeftSwipeAnimation {
	NSMutableArray *arr = [[Board latestBoard] getBoardDataArray];
	arr = [arr mutableCopy];

	for (int row = 0; row < 4; ++row) {
		NSMutableArray *rowArr = arr[row];
		int col1 = 0;
		int col2 = 0;
		int col3 = 1;
		
		while (col1 < 4 && col2 < 4 && col3 < 4) {
			if ([rowArr[col2] intValue] == 0) {
				++col2;
				++col3;
				continue;
			}
			if ([rowArr[col3] intValue] == 0) {
				++col3;
				continue;
			}
			// If both formerTileInd and nextTileInd are not zero, the following code get executed.
			int newVal = 0;
			if ([rowArr[col2] intValue] == [rowArr[col3] intValue] && col2 != col3) {
				newVal = 2 * [rowArr[col2] intValue];
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col2]).center;
					((UIView *)self.onBoardTileViews[row][col2]).center = CGPointMake(center.x - 68 * (col2 - col1), center.y);
				}];
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col3]).center;
					((UIView *)self.onBoardTileViews[row][col3]).center = CGPointMake(center.x - 68 * (col3 - col1), center.y);
				}];
				
				TileView *newTileView = [[TileView alloc] init];
				CGRect frame = CGRectMake(col1 * 68 + 8, row * 68 + 8, 60, 60);
				int32_t val = newVal;
				newTileView = [[TileView alloc] initWithFrame:frame];
				newTileView.text = [Tile tileWithValue: val].text;
				newTileView.backgroundColor = self.theme.tileColors[@(val)];
				[self.boardView addSubview:newTileView];
				[self.boardView bringSubviewToFront:newTileView];
				newTileView.layer.cornerRadius = self.theme.tileCornerRadius;
				newTileView.layer.masksToBounds = YES;
				newTileView.textColor = (val <= 4 ? self.theme.tileTextColor:[UIColor whiteColor]);
				newTileView.alpha = 0.0f;
				[newTileView setNeedsDisplay];
				
				[UIView animateWithDuration:kAnimationDuration_Default/2.0f
									  delay:kAnimationDuration_Default
					 usingSpringWithDamping:kAnimationSpring_Damping
					  initialSpringVelocity:kAnimationSpring_Velocity
									options:UIViewAnimationOptionCurveEaseOut
								 animations:^{
									 CGFloat scaleFactor = 1.0f + 4.0f/60.0f;
									 newTileView.alpha = 1.0f;
									 CGAffineTransform transform = newTileView.transform;
									 newTileView.transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);
								 }
								 completion:^(BOOL finished) {
									 [UIView animateWithDuration:kAnimationDuration_Default/2.0f
														   delay:0.0f
										  usingSpringWithDamping:kAnimationSpring_Damping
										   initialSpringVelocity:kAnimationSpring_Velocity
														 options:UIViewAnimationOptionCurveEaseOut
													  animations:^{
														  newTileView.transform = CGAffineTransformIdentity;
													  }
													  completion:nil];
								 }];
				self.onBoardTileViews[row][col2] = [[UIView alloc] init];
				self.onBoardTileViews[row][col3] = [[UIView alloc] init];
				self.onBoardTileViews[row][col1] = newTileView;
				rowArr[col2] = @(0);
				rowArr[col3] = @(0);
				col2 += 2;
				col3 += 2;
				
			} else {
				newVal = [rowArr[col2] intValue];
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col2]).center;
					((UIView *)self.onBoardTileViews[row][col2]).center = CGPointMake(center.x - 68 * (col2 - col1), center.y);
				}];
				self.onBoardTileViews[row][col1] = self.onBoardTileViews[row][col2];
				self.onBoardTileViews[row][col2] = [[UIView alloc] init];
				rowArr[col2] = @(0);
				col2 = col3++;
			}
			rowArr[col1++] = @(newVal);
		}
		if (col1 < 4 && col2 < 4) {
			int newVal = [rowArr[col2] intValue];
			if (newVal != 0 && [arr[row][col1] intValue] == 0) {
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col2]).center;
					((UIView *)self.onBoardTileViews[row][col2]).center = CGPointMake(center.x - 68 * (col2 - col1), center.y);
				}];
				self.onBoardTileViews[row][col1] = self.onBoardTileViews[row][col2];
				self.onBoardTileViews[row][col2] = [[UIView alloc] init];
				rowArr[col1] = @(newVal);
				rowArr[col2] = @(0);
			}
		}
	}
}

-(void)startRightSwipeAnimation {
	NSMutableArray *arr = [[Board latestBoard] getBoardDataArray];
	arr = [arr mutableCopy];
	
	for (int row = 0; row < 4; ++row) {
		NSMutableArray *rowArr = arr[row];
		int col1 = 3;
		int col2 = 3;
		int col3 = 2;
		
		while (col1 >= 0 && col2 >= 0 && col3 >= 0) {
			if ([rowArr[col2] intValue] == 0) {
				--col2;
				--col3;
				continue;
			}
			if ([rowArr[col3] intValue] == 0) {
				--col3;
				continue;
			}
			// If both formerTileInd and nextTileInd are not zero, the following code get executed.
			int newVal = 0;
			if ([rowArr[col2] intValue] == [rowArr[col3] intValue] && col2 != col3) {
				newVal = 2 * [rowArr[col2] intValue];
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col2]).center;
					((UIView *)self.onBoardTileViews[row][col2]).center = CGPointMake(center.x + 68 * (col1 - col2), center.y);
				}];
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col3]).center;
					((UIView *)self.onBoardTileViews[row][col3]).center = CGPointMake(center.x + 68 * (col1 - col2), center.y);
				}];
				
				TileView *newTileView = [[TileView alloc] init];
				CGRect frame = CGRectMake(col1 * 68 + 8, row * 68 + 8, 60, 60);
				int32_t val = newVal;
				newTileView = [[TileView alloc] initWithFrame:frame];
				newTileView.text = [Tile tileWithValue: val].text;
				newTileView.backgroundColor = self.theme.tileColors[@(val)];
				[self.boardView addSubview:newTileView];
				[self.boardView bringSubviewToFront:newTileView];
				newTileView.layer.cornerRadius = self.theme.tileCornerRadius;
				newTileView.layer.masksToBounds = YES;
				newTileView.textColor = (val <= 4 ? self.theme.tileTextColor:[UIColor whiteColor]);
				newTileView.alpha = 0.0f;
				[newTileView setNeedsDisplay];
				
				[UIView animateWithDuration:kAnimationDuration_Default/2.0f
									  delay:kAnimationDuration_Default
					 usingSpringWithDamping:kAnimationSpring_Damping
					  initialSpringVelocity:kAnimationSpring_Velocity
									options:UIViewAnimationOptionCurveEaseOut
								 animations:^{
									 CGFloat scaleFactor = 1.067f;
									 newTileView.alpha = 1.0f;
									 CGAffineTransform transform = newTileView.transform;
									 newTileView.transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);
								 }
								 completion:^(BOOL finished) {
									 [UIView animateWithDuration:kAnimationDuration_Default/2.0f
														   delay:0.0f
										  usingSpringWithDamping:kAnimationSpring_Damping
										   initialSpringVelocity:kAnimationSpring_Velocity
														 options:UIViewAnimationOptionCurveEaseOut
													  animations:^{
														  newTileView.transform = CGAffineTransformIdentity;
													  }
													  completion:nil];
								 }];
				self.onBoardTileViews[row][col2] = [[UIView alloc] init];
				self.onBoardTileViews[row][col3] = [[UIView alloc] init];
				self.onBoardTileViews[row][col1] = newTileView;
				rowArr[col2] = @(0);
				rowArr[col3] = @(0);
				col2 -= 2;
				col3 -= 2;
				
			} else {
				newVal = [rowArr[col2] intValue];
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col2]).center;
					((UIView *)self.onBoardTileViews[row][col2]).center = CGPointMake(center.x + 68 * (col1 - col2), center.y);
				}];
				self.onBoardTileViews[row][col1] = self.onBoardTileViews[row][col2];
				self.onBoardTileViews[row][col2] = [[UIView alloc] init];
				rowArr[col2] = @(0);
				col2 = col3--;
			}
			rowArr[col1--] = @(newVal);
		}
		if (col1 >= 0 && col2 >= 0) {
			int newVal = [rowArr[col2] intValue];
			if (newVal != 0 && [arr[row][col1] intValue] == 0) {
				[UIView animateWithDuration:kAnimationDuration_Default animations:^{
					CGPoint center = ((UIView *)self.onBoardTileViews[row][col2]).center;
					((UIView *)self.onBoardTileViews[row][col2]).center = CGPointMake(center.x + 68 * (col1 - col2), center.y);
				}];
				self.onBoardTileViews[row][col1] = self.onBoardTileViews[row][col2];
				self.onBoardTileViews[row][col2] = [[UIView alloc] init];
				rowArr[col1] = @(newVal);
				rowArr[col2] = @(0);
			}
		}
	}
}

-(void)startUpSwipeAnimation {
	
}

-(void)startDownSwipeAnimation {
	
}

-(void)setMode:(BoardViewControllerMode) mode {
	_mode = mode;
	if (_mode == BoardViewControllerModePlaying) {
		self.originalContentView.userInteractionEnabled = YES;
		[self enableGestureRecognizers:YES];
	} else if (_mode == BoardViewControllerModeHisory) {
		self.originalContentView.userInteractionEnabled = YES;
		[self enableGestureRecognizers:NO];
	} else if (_mode == BoardViewControllerModeShow) {
		self.originalContentView.userInteractionEnabled = NO;
		self.canDisplayBannerAds = NO;
	}
}

-(void)updateBoardFromBoard: (Board *)board {
	for (UIView *tView in [self.boardView subviews]) {
		if ([tView isKindOfClass:[TileView class]]) {
			[tView removeFromSuperview];
		}
	}
	for (size_t i = 0; i < 4; ++i) {
		for (size_t j = 0; j < 4; ++j) {
			self.onBoardTileViews[i][j] = [[UIView alloc] init];
		}
	}
	[self.boardView setNeedsDisplay];
	board = [Board latestBoard];
	NSArray *gameData = [board getBoardDataArray];
	for (size_t i = 0; i < 4; ++i) {
		for (size_t j = 0; j < 4; ++j) {
			int val = [gameData[i][j] intValue];
			if (val) { // If there is a tile
				CGRect frame = CGRectMake(j * 68 + 8, i * 68 + 8, 60, 60);
				TileView *tView = [[TileView alloc] initWithFrame:frame];
				tView.val = val;
				tView.text = [Tile tileWithValue: val].text;
				tView.backgroundColor = self.theme.tileColors[@(val)];
				self.onBoardTileViews[i][j] = tView;
				[self.boardView addSubview:tView];
				[self.boardView bringSubviewToFront:tView];
				tView.layer.cornerRadius = self.theme.tileCornerRadius;
				tView.layer.masksToBounds = YES;
				tView.textColor = (val <= 4 ? self.theme.tileTextColor:[UIColor whiteColor]);
				[tView setNeedsDisplay];
			}
		}
	}
	[self.boardView bringSubviewToFront:self.boardViewInteractionLayer];
	self.bestScoreLabel.text = [NSString stringWithFormat:@"%d", [GameManager sharedGameManager].bestScore];
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", board.score];
	if (board.gameplaying == NO && self.mode == BoardViewControllerModePlaying) {
		[self enableGestureRecognizers:NO];
		self.pauseView.alpha = 0.0f;
		[self.boardView bringSubviewToFront:self.pauseView];
		[self.pauseView bringSubviewToFront:self.pauseImageView];
		[self.pauseView bringSubviewToFront:self.gameStatusLabel];
		[self.pauseView bringSubviewToFront:self.shareButton];
		[self.pauseView bringSubviewToFront:self.retryOrKeepPlayingButton];
		self.retryOrKeepPlayingButton.titleLabel.text = @"Play Again";
		self.retryOrKeepPlayingButton.tag = 0;
		__block UIImage *snapshot;
		NSMutableArray *allTileViews = [NSMutableArray array];
		for (size_t i = 0; i < 4; ++i) {
			for (size_t j = 0; j < 4; ++j) {
				UIView *tView = self.onBoardTileViews[i][j];
				if ([tView isKindOfClass:[TileView class]]) {
					[allTileViews addObject:tView];
				}
			}
		}
		for (UIView *tView in allTileViews) {
			CGAffineTransform transform = tView.transform;
			// Determin how much we should scale the tile to fill the entire board.
			CGFloat scaleFactor = 1.0f + ((self.boardView.bounds.size.width - tView.bounds.size.width * 4.0f)/5.0f)/(tView.bounds.size.width);
			[UIView animateWithDuration:kAnimationDuration_ScaleTile
								  delay:kAnimationDelay_GameOver
				 usingSpringWithDamping:0.3f
				  initialSpringVelocity:0.6f
								options:UIViewAnimationOptionCurveLinear
							 animations:^{
								 tView.transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);
							 }
							 completion:^(BOOL finished){
								 // Only execute once when the last tView is sent message
								 if (tView == [allTileViews lastObject]) { // Only taks one snapshot
									 if (!snapshot) {
										 UIGraphicsBeginImageContextWithOptions(self.boardView.bounds.size, YES, 0.0f);
										 [self.boardView drawViewHierarchyInRect:self.boardView.bounds afterScreenUpdates:YES];
										 snapshot = UIGraphicsGetImageFromCurrentImageContext();
										 UIGraphicsEndImageContext();
										 
										 UIColor *blurtTintColor = [self.theme backgroundColor];
										 CGFloat red, green, blue, alpha;
										 [blurtTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
										 blurtTintColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
										 snapshot = [snapshot applyBlurEffectWithRadius:3.0f tintColor:blurtTintColor];
										 self.pauseImageView.image = snapshot;
										 
										 [UIView animateWithDuration:kAnimationDuration_ScreenBlur
															   delay:0.0f
															 options:UIViewAnimationOptionCurveEaseInOut
														  animations:^{
															  self.pauseView.alpha = 1.0f;
														  }
														  completion:^(BOOL finished) {
															  [self.boardView bringSubviewToFront:self.pauseView];
															  self.pauseView.layer.mask.transform = CATransform3DTranslate(self.pauseView.layer.mask.transform, -100, -100, 0);
														  }];
									 }
								 }
							 }];
		}
		[self saveContext];
	} else {
		self.pauseView.alpha = 0.0f;
	}
}

-(void)updateBoardFromLatestBoardData {
	[self updateBoardFromBoard:[Board latestBoard]];
}

-(void)enableGestureRecognizers: (BOOL) enable {
	for (UIGestureRecognizer *gRecognizer in self.swipeGestureRecognizers) {
		gRecognizer.enabled = enable;
	}
}

-(BOOL) saveContext {
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}


//-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
//	// Taking snapshot:
//	UIGraphicsBeginImageContextWithOptions(self.originalContentView.bounds.size, YES, 0.0f);
//	[self.originalContentView drawViewHierarchyInRect:self.originalContentView.bounds afterScreenUpdates:YES];
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
//	[self.originalContentView addSubview:self.latestSnapshotView];
//	[self.originalContentView bringSubviewToFront:self.latestSnapshotView];
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

@end
