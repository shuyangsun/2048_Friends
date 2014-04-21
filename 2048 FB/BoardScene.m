//
//  BoardScene.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/19/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "BoardScene.h"
#import "Theme.h"
#import "TileSKShapeNode.h"

const NSTimeInterval kAnimationDuration_TileContainerPopup = 0.035f;

@interface BoardScene()

@property (nonatomic) UIUserInterfaceIdiom uiIdiom;

// SKNode: NSValue(CGPoint) dictionaries
@property (strong, nonatomic) NSMutableDictionary *positionsForNodes;
@property (strong, nonatomic) NSMutableDictionary *nextPositionsForNodes;
@property (strong, nonatomic) NSMutableSet *movingNodes;

@property (strong, nonatomic) NSMutableArray *tileContainers;

// Frequently used SKActions:
@property (strong, nonatomic) SKAction *scaleToFullSize;

@end

@implementation BoardScene

-(id)initWithSize:(CGSize)size {
	if (self = [super initWithSize:size]) {
		self.uiIdiom = [UIDevice currentDevice].userInterfaceIdiom;
		
    }
    return self;
}

-(id)initWithSize:(CGSize)size andTheme:(Theme *)theme {
	BoardScene *res = [self initWithSize:size];
	res.theme = theme;
	[self initializePropertyLists];
	[self initializeTileContainers:size];
	[self popupTileContainersAnimated:YES];
	return res;
}

+(id)sceneWithSize:(CGSize)size andTheme:(Theme *)theme {
	BoardScene *res = [[BoardScene alloc] initWithSize:size andTheme:theme];
	return res;
}

-(void)setTheme:(Theme *)theme {
	_theme = theme;
	self.backgroundColor = theme.boardColor;
	// Setup SKActions:
	self.scaleToFullSize = [SKAction group:@[[SKAction scaleTo:1.0f duration:kAnimationDuration_TileContainerPopup],
											 [SKAction moveBy:CGVectorMake(-self.theme.tileWidth/2.0f, -self.theme.tileWidth/2.0f) duration:kAnimationDuration_TileContainerPopup]]];
}

#warning TODO (Need a updateTheme: Animated method)

-(void)initializePropertyLists{
	self.positionsForNodes = [NSMutableDictionary dictionary];
	self.nextPositionsForNodes = [NSMutableDictionary dictionary];
	self.movingNodes = [NSMutableSet set];
	self.tileContainers = [NSMutableArray array];
	for (size_t i = 0; i < 4; ++i) {
		self.tileContainers[i] = [NSMutableArray array];
	}
}

-(void)initializeTileContainers:(CGSize) size {
	CGFloat tileWidth = self.theme.tileWidth;
	CGFloat edgeWidth = (size.width - 4 * (tileWidth))/5.0f;
	for (size_t i = 0; i < 4; ++i) {
		for (size_t j = 0; j < 4; j++) {
			SKShapeNode* tileContainer = [SKShapeNode node];
			[tileContainer setPath:CGPathCreateWithRoundedRect(CGRectMake(0,
																		  0,
																		  tileWidth,
																		  tileWidth),
															   self.theme.tileCornerRadius,
															   self.theme.tileCornerRadius, nil)];
			tileContainer.strokeColor = tileContainer.fillColor = self.theme.tileContainerColor;
			CGPoint pos = CGPointMake((i + 1) * edgeWidth + (i + 0.5) * tileWidth, (j + 1) * edgeWidth + (j + 0.5) * tileWidth);
			tileContainer.position = pos;
			tileContainer.xScale = tileContainer.yScale = 0.0f;
			[self addChild:tileContainer];
			self.tileContainers[i][j] = tileContainer;
		}
	}
}

// This method pops the tile containers
-(void)popupTileContainersAnimated:(BOOL) animated {
	if (animated) {
		int arr1[] = {0, 1, 2, 3};
		int arr2[] = {3, 1, 0, 2};
		// Shuffle the index array:
		for (size_t i = 0; i < 4; ++i) {
			int tempInd1 = arc4random()%4;
			int tempInd2 = arc4random()%4;
			int temp = arr1[tempInd1];
			arr1[tempInd1] = arr1[tempInd2];
			arr1[tempInd2] = temp;
			temp = arr2[tempInd1];
			arr2[tempInd1] = arr2[tempInd2];
			arr2[tempInd2] = temp;
		}
		// Doing this because CANNOT reference an array inside block!
		int a1 = arr1[0];
		int a2 = arr1[1];
		int a3 = arr1[2];
		int a4 = arr1[3];
		int b1 = arr2[0];
		int b2 = arr2[1];
		int b3 = arr2[2];
		int b4 = arr2[3];
		[self.tileContainers[a1][b2] runAction:self.scaleToFullSize completion:^{
			[self.tileContainers[a2][b3] runAction:self.scaleToFullSize completion:^{
				[self.tileContainers[a1][b1] runAction:self.scaleToFullSize completion:^{
					[self.tileContainers[a4][b3] runAction:self.scaleToFullSize completion:^{
						[self.tileContainers[a2][b2] runAction:self.scaleToFullSize completion:^{
							[self.tileContainers[a3][b3] runAction:self.scaleToFullSize completion:^{
								[self.tileContainers[a3][b4] runAction:self.scaleToFullSize completion:^{
									[self.tileContainers[a2][b1] runAction:self.scaleToFullSize completion:^{
										[self.tileContainers[a3][b1] runAction:self.scaleToFullSize completion:^{
											[self.tileContainers[a2][b4] runAction:self.scaleToFullSize completion:^{
												[self.tileContainers[a4][b2] runAction:self.scaleToFullSize completion:^{
													[self.tileContainers[a3][b2] runAction:self.scaleToFullSize completion:^{
														[self.tileContainers[a4][b1] runAction:self.scaleToFullSize completion:^{
															[self.tileContainers[a4][b4] runAction:self.scaleToFullSize completion:^{
																[self.tileContainers[a1][b3] runAction:self.scaleToFullSize completion:^{
																	[self.tileContainers[a1][b4] runAction:self.scaleToFullSize completion:nil];
																}];
															}];
														}];
													}];
												}];
											}];
										}];
									}];
								}];
							}];
						}];
					}];
				}];
			}];
		}];
	} else {
		for (size_t i = 0; i < 4; ++i) {
			for (size_t j = 0; j < 4; ++j) {
				SKShapeNode *container = self.tileContainers[i][j];
				container.xScale = container.yScale = 1.0f;
				CGPoint point = container.position;
				container.position = CGPointMake(point.x - self.theme.tileWidth/2.0f, point.y - self.theme.tileWidth/2.0f);
			}
		}
	}
}

@end

