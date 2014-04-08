//
//  ViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 3/31/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "ViewController.h"
#import "Theme.h"
#import "GameManager+ModelLayer03.h"

const NSTimeInterval kViewControllerDuration_Animation = 0.1f;
const NSTimeInterval kViewControllerDuration_Delay = 0.0f;
const NSTimeInterval kViewControllerDuration_SpringDamping = 0.4f;
const NSTimeInterval kViewControllerDuration_SpringVelocity = 0.6f;

@interface ViewController ()

@property (strong, nonatomic) UIButton *fbLoginViewButton;

// Private property to check if the user
@property (nonatomic, getter = isUserLoggedIn) BOOL userLoggedIn;
@property (nonatomic, strong) Theme *theme;
@property (nonatomic) CGRect originCutomButtonFrame;

/** This method is a private helper method to find the UIButton in the fbLoginView.
 *  So we can send touch events to fbLoginView programmatically.
 *  This is used for customizing our own Facebook login UI.
 *  This method will set the private "fbLoginViewButton" property as the button.
 */
-(void)findUIButtonInfbLoginView;

/**
 * 
 */
-(BOOL)fetchFbFriendsImages;

@end

@implementation ViewController

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
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.fbLoginView.delegate = self;
	// Get the pointer to the button.
	[self findUIButtonInfbLoginView];
	self.customLoginButton.layer.cornerRadius = self.theme.buttonCornerRadius;
	self.view.backgroundColor = self.theme.backgroundColor;
	self.originCutomButtonFrame = self.customLoginButton.frame;
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handle events when users start panning on "Introduction" page.
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
	CGFloat viewWidth = self.view.frame.size.width;
	CGFloat maxPanLength1 = 5.0f;
	CGFloat maxPanLength2 = 2.0f;
	CGFloat newWidthAdded = 0.0f;
	CGRect newFrame;
	if (sender.state == UIGestureRecognizerStateBegan) {
		NSArray *viewArr = [self.view subviews];
		for (UIView *v in viewArr) {
			v.translatesAutoresizingMaskIntoConstraints = YES;
		}
		self.originCutomButtonFrame = self.customLoginButton.frame;
		newFrame = self.originCutomButtonFrame;
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		CGFloat translationX = [sender translationInView:self.view].x;
		newWidthAdded += maxPanLength1 * MIN(1.0f, fabs(translationX)/(viewWidth/2));
		newWidthAdded += maxPanLength2 * MAX(0.0f, (fabs(translationX) - (viewWidth/2))/(viewWidth/2));
		if (translationX > 0) {
			newFrame = CGRectMake(self.originCutomButtonFrame.origin.x, self.originCutomButtonFrame.origin.y, self.originCutomButtonFrame.size.width + newWidthAdded, self.originCutomButtonFrame.size.height);
		} else {
			newFrame = CGRectMake(self.originCutomButtonFrame.origin.x - newWidthAdded, self.originCutomButtonFrame.origin.y, self.originCutomButtonFrame.size.width + newWidthAdded, self.originCutomButtonFrame.size.height);
		}
		
		self.customLoginButton.frame = newFrame;
		[self.customLoginButton setNeedsDisplay];
	} else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
		[UIView animateWithDuration:kViewControllerDuration_Animation
							  delay:kViewControllerDuration_Delay
			 usingSpringWithDamping:kViewControllerDuration_SpringDamping
			   initialSpringVelocity:kViewControllerDuration_SpringVelocity
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.customLoginButton.frame = self.originCutomButtonFrame;
						 }
						 completion:^(BOOL finished){
							 NSArray *viewArr = [self.view subviews];
							 for (UIView *v in viewArr) {
								 v.translatesAutoresizingMaskIntoConstraints = YES;
							 }
						 }];
	}
}

- (IBAction)customLoginButtonTouched:(UIButton *)sender {
	[self.fbLoginViewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

// <FBLoginViewDelegate> method
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
	
}

// <FBLoginViewDelegate> method
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
	
}

// <FBLoginViewDelegate> method
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView
						   user:(id<FBGraphUser>)user {
}

// Private helper method.
-(BOOL)fetchFbFriendsImages {
	return YES;
}

// Get the pointer to UIButton in fbLoginView, so we can programmatically "touch" it.
-(void)findUIButtonInfbLoginView {
	// Code and idea from "ozba - StackOverflow"
	for (id obj in self.fbLoginView.subviews) {
		if ([obj isKindOfClass:[UIButton class]]) {
			self.fbLoginViewButton = (UIButton *)obj;
		}
	}
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
