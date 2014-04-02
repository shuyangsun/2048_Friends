//
//  TFFBViewController.m
//  2048 FB
//
//  Created by Shuyang Sun on 3/31/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "TFFBViewController.h"

@interface TFFBViewController ()

@property (strong, nonatomic) UIButton *fbLoginViewButton;

// Private property to check if the user
@property (nonatomic, getter = isUserLoggedIn) BOOL userLoggedIn;
@property (nonatomic, getter = isShowPageControl) BOOL showPageControl;

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

@implementation TFFBViewController


-(void)setup
{
	// Initialization code here...
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
	self.customLoginButton.layer.cornerRadius = kTTFBViewController_ButtonCornerRadiusDefault;
	if (self.isShowPageControl == NO) {
		self.pageControl.hidden = YES;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handle events when users start panning on "Introduction" page.
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"Hello", nil]];
	array[0] = @"hi";
	NSLog(@"%@", array[0]);
	if (sender.state == UIGestureRecognizerStateBegan) {
		
	} else if (sender.state == UIGestureRecognizerStateChanged) {
		
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		if ([sender translationInView:self.view].x < 0) { // If the user is swiping to the left:
			if (self.pageControl.currentPage < self.pageControl.numberOfPages - 1){
				self.pageControl.currentPage++;
			}
		} else if ([sender translationInView:self.view].x > 0) { // If the user is swiping to the right:
			if (self.pageControl.currentPage > 0) {
				self.pageControl.currentPage--;
			}
		} // TODO add animations to up/down swip (bouns a little bit)
	} else if (sender.state == UIGestureRecognizerStateFailed) {
		
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
	self.showPageControl = NO;
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
