//
//  TileView.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/8/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "TileView.h"
#import "UIImage+ImageEffects.h"
#import "FXBlurView.h"
#import "GameManager+ModelLayer03.h"

@interface TileView()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *numberLayerView;
@property (strong, nonatomic) UIImageView *blurImageView;

// UIKit Dynamics
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;

@end


@implementation TileView

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame
						 value:2
						  text:@"2"
					 textColor:[UIColor blackColor]
						  type:TileViewTypeImage];
}

-(id)initWithFrame:(CGRect)frame
			 value: (int32_t)val
			  text: (NSString *)text
		 textColor: (UIColor *)textColor
			  type:(TileViewType)type{
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.frame = frame;
		self.imageTransparent = NO;
		// UIKit Dynamic:
		self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
		
		self.gravityBehavior = [[UIGravityBehavior alloc] init];
		[self.animator addBehavior:self.gravityBehavior];
		
		self.collisionBehavior = [[UICollisionBehavior alloc] init];
		// We need to manually define the boundry because of the corner radius, so set translatesReferenceBoundsIntoBoundary to NO.
		self.collisionBehavior.translatesReferenceBoundsIntoBoundary = NO;
		// Adding bottom line boundry manually
		[self.collisionBehavior addBoundaryWithIdentifier:@"Bottom Boundry Identifier"
												fromPoint:CGPointMake(0, self.bounds.size.height)
												  toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
		[self.animator addBehavior:self.collisionBehavior];
		
		self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] init];
		self.dynamicItemBehavior.elasticity = 0.37f; // Bounce once after the imageView get dropped on the "ground"
		[self.animator addBehavior:self.dynamicItemBehavior];
		
		self.type = type;
		self.val = val;
		self.text = text;
		self.textColor = textColor;
    }
    return self;
}

// Override setter method for textColor, update label.textColor.
-(void)setTextColor:(UIColor *)textColor {
	_textColor = textColor;
	self.label.textColor = _textColor;
}

// Override setter method for text, update label.
-(void)setText:(NSString *)text {
	_text = text;
	self.label = [[UILabel alloc] initWithFrame:self.bounds];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.text = _text;
	self.label.textColor = self.textColor;
	CGFloat fontSize = 25.0f;
	self.label.font = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
}

-(void)setImageTransparent:(BOOL)imageTransparent {
	_imageTransparent = imageTransparent;
	[UIView animateWithDuration:0.1f
					 animations:^{
						 if (imageTransparent) {
							 self.imageView.alpha = 0.3f;
						 } else {
							 self.imageView.alpha = 1.0f;
						 }
					 }];
}

- (void)drawRect:(CGRect)rect
{
	// No matter what the view type is, the underlaying layer is always the number view.
	[self addSubview:self.label];
	if (self.type == TileViewTypeImage && self.image) {
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		self.imageView.image = self.image;
		self.imageView.layer.cornerRadius = self.layer.cornerRadius;
		self.imageView.layer.masksToBounds = YES;
		self.imageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:self.imageView];
		[self bringSubviewToFront:self.imageView];
	}
		
}

-(void)setImage:(UIImage *)image{
	_image = image;
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, -(self.bounds.size.height - 2), self.bounds.size.width - 2, self.bounds.size.height - 2)];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView.image = self.image;
	self.imageView.layer.cornerRadius = self.layer.cornerRadius;
	self.imageView.layer.masksToBounds = YES;
	self.imageView.contentMode = UIViewContentModeScaleToFill;
	[self addSubview:self.imageView];
	[self bringSubviewToFront:self.imageView];
}


-(void)setType:(TileViewType)type {
	_type = type;
}

-(void)showImageLayerAnimated: (BOOL) animated {
	// frame1 is for frame in self, frame2 is for frame inside numberLayerView
	
	if (self.imageView && self.type == TileViewTypeNumber) {
		if (![self.gravityBehavior.items containsObject:self.imageView]) {[self.gravityBehavior addItem:self.imageView];}
		if (![self.collisionBehavior.items containsObject:self.imageView]) {[self.collisionBehavior addItem:self.imageView];}
		if (![self.dynamicItemBehavior.items containsObject:self.imageView]) {[self.dynamicItemBehavior addItem:self.imageView];}
		[self bringSubviewToFront:self.imageView];
		self.type = TileViewTypeImage;
	}
	/*
	CGRect frame1 = CGRectMake(1, -(self.bounds.size.height - 1), self.bounds.size.width - 2, self.bounds.size.height - 1);
	CGRect frame2 = CGRectMake(0, 0, self.bounds.size.width - 2, self.bounds.size.height - 1);
	
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 self.imageView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y - 60);
					 } completion:^(BOOL finished) {
						 
						 if (!self.numberLayerView) {
							 // Setup the parent view
							 self.numberLayerView = [[UIView alloc] initWithFrame:frame1];
							 self.numberLayerView.layer.cornerRadius = self.layer.cornerRadius;
							 self.numberLayerView.layer.masksToBounds = YES;
							 self.numberLayerView.backgroundColor = [UIColor clearColor];
							 
							 
							 // Setup the blured image
							 UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame2];
							 imageView.contentMode = UIViewContentModeScaleAspectFit;
							 UIColor *tintColor = self.backgroundColor;
							 CGFloat red, green, blue, alpha;
							 [tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
							 tintColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
							 tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
							 imageView.contentMode = UIViewContentModeScaleAspectFill;
							 imageView.image = [self.image applyBlurEffectWithRadius:2.0f tintColor:tintColor];
							 imageView.layer.cornerRadius = self.layer.cornerRadius;
							 imageView.layer.masksToBounds = YES;
							 [self.numberLayerView addSubview:imageView];
							 [self.numberLayerView bringSubviewToFront:imageView];
							 
							 // Setup the label
							 UILabel *label = [[UILabel alloc] initWithFrame:frame2];
							 label.textAlignment = NSTextAlignmentCenter;
							 label.text = self.text;
							 label.textColor = [UIColor darkTextColor];
							 CGFloat fontSize = 25.0f;
							 label.font = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
							 [self.numberLayerView addSubview:label];
							 [self.numberLayerView bringSubviewToFront:label];
						 }
						 self.numberLayerView.frame = frame1;
						 [self addSubview:self.numberLayerView];
						 [self bringSubviewToFront:self.numberLayerView];
						 
						 // UIKit Dynamic:
						 self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
						 
						 self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.numberLayerView]];
						 [self.animator addBehavior:self.gravityBehavior];
						 
						 self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.numberLayerView]];
						 // We need to manually define the boundry because of the corner radius, so set translatesReferenceBoundsIntoBoundary to NO.
						 self.collisionBehavior.translatesReferenceBoundsIntoBoundary = NO;
						 // Adding bottom line boundry manually
						 [self.collisionBehavior addBoundaryWithIdentifier:@"Bottom Boundry Identifier"
															fromPoint:CGPointMake(0, self.bounds.size.height)
															  toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
						 [self.animator addBehavior:self.collisionBehavior];
						 
						 self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.numberLayerView]];
						 self.dynamicItemBehavior.elasticity = 0.5f;
						 [self.animator addBehavior:self.dynamicItemBehavior];

					 }];
	 */
}

-(void)hideImageLayerAnimated: (BOOL) animated {
	if (self.imageView && self.type == TileViewTypeImage) {
		if ([self.gravityBehavior.items containsObject:self.imageView]) {[self.gravityBehavior removeItem:self.imageView];}
		if ([self.collisionBehavior.items containsObject:self.imageView]) {[self.collisionBehavior removeItem:self.imageView];}
		if ([self.dynamicItemBehavior.items containsObject:self.imageView]) {[self.dynamicItemBehavior removeItem:self.imageView];}
		[UIView animateWithDuration:0.2f
							  delay:0.0f
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
							 self.imageView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y - 60);
						 } completion:^(BOOL finished) {
//							 [self.gravityBehavior addItem:self.imageView];
//							 [self.collisionBehavior addItem:self.imageView];
//							 [self.dynamicItemBehavior addItem:self.imageView];
						 }];
		self.type = TileViewTypeNumber;
	}
}

@end
