//
//  BoardScene.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/19/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "BoardScene.h"
#import "Theme.h"
#import "GameManager+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "TileSKShapeNode.h"

const NSTimeInterval kAnimationDuration_TileContainerPopup = 0.05f;

@interface BoardScene()



@end

@implementation BoardScene

-(id)initWithSize:(CGSize)size {
	if (self = [super initWithSize:size]) {
		self.uiIdiom = [UIDevice currentDevice].userInterfaceIdiom;
		self.gManager = [GameManager sharedGameManager];
		self.history = [History latestHistory];
		self.board = [Board latestBoard];
		if (!self.board) {
			self.board = [Board initializeNewBoard];
		}
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

-(void)initializePropertyLists{
	self.positionsForNodes = [NSMutableDictionary dictionary];
	self.nextPositionsForNodes = [NSMutableDictionary dictionary];
	self.theNewNodes = [NSMutableDictionary dictionary];
	self.nodeForIndexes = [NSMutableDictionary dictionary];
	self.theNewNodeForIndexes = [NSMutableDictionary dictionary];
	self.movingNodes = [NSMutableSet set];
	self.removingNodes = [NSMutableSet set];
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
		// Doing this because we CANNOT reference an array inside block!
		int a1 = arr1[0];
		int a2 = arr1[1];
		int a3 = arr1[2];
		int a4 = arr1[3];
		int b1 = arr2[0];
		int b2 = arr2[1];
		int b3 = arr2[2];
		int b4 = arr2[3];
		// Please don't remove any awesome comment in this method, that will probably result a compile error. ;)
		[self.tileContainers[a1][b2] runAction:self.scaleToFullSize completion:^{/*                    Painting while Coding                        */
			[self.tileContainers[a2][b3] runAction:self.scaleToFullSize completion:^{/* (The man will probably hit this line of comment.)           */
				[self.tileContainers[a1][b1] runAction:self.scaleToFullSize completion:^{/*                                                         */
					[self.tileContainers[a4][b3] runAction:self.scaleToFullSize completion:^{/*                                                     */
						[self.tileContainers[a2][b2] runAction:self.scaleToFullSize completion:^{/*                                                 */
							[self.tileContainers[a3][b3] runAction:self.scaleToFullSize completion:^{/*                                             */
								[self.tileContainers[a3][b4] runAction:self.scaleToFullSize completion:^{/*                                         */
									[self.tileContainers[a2][b1] runAction:self.scaleToFullSize completion:^{/*                                     */
										[self.tileContainers[a3][b1] runAction:self.scaleToFullSize completion:^{/*                                 */
											[self.tileContainers[a2][b4] runAction:self.scaleToFullSize completion:^{/*                             */
												[self.tileContainers[a4][b2] runAction:self.scaleToFullSize completion:^{/*                         */
													[self.tileContainers[a3][b2] runAction:self.scaleToFullSize completion:^{/*         O           */
														[self.tileContainers[a4][b1] runAction:self.scaleToFullSize completion:^{/*    -|-          */
															[self.tileContainers[a4][b4] runAction:self.scaleToFullSize completion:^{/* /\          */
																[self.tileContainers[a1][b3] runAction:self.scaleToFullSize completion:^{/*         */
																	[self.tileContainers[a1][b4] runAction:self.scaleToFullSize completion:^{/*     */
																		[self startGameFromBoard:self.board animated:animated];
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
		[self startGameFromBoard:[Board latestBoard] animated:animated];
	}
}

-(void)startGameFromBoard:(Board *)board animated:(BOOL)animated {
	if (board) {
		self.score = board.score;
		self.gamePlaying = board.gameplaying;
		self.data = [board getBoardDataArray];
		CGFloat tileWidth = self.theme.tileWidth;
		for (size_t i = 0; i < 4; ++i) {
			for (size_t j = 0; j < 4; j++) {
				if ([self.data[i][j] intValue] != 0) { // If it's not zero
					NSNumber *value = self.data[i][j];
					TileSKShapeNode *tile = [TileSKShapeNode node];
					[tile setPath:CGPathCreateWithRoundedRect(CGRectMake(0,
																		 0,
																		 tileWidth,
																		 tileWidth),
																	   self.theme.tileCornerRadius,
																	   self.theme.tileCornerRadius, nil)];
					tile.strokeColor = tile.fillColor = self.theme.tileColors[value];
					[tile setValue:[value intValue]
							  text:[NSString stringWithFormat:@"%d", [value intValue]]
						 textColor:([value intValue] <= 4 ? self.theme.tileTextColor:[UIColor whiteColor])
							  type:TileTypeNumber];
					CGPoint pos = [self getPositionFromX:i andY:j];
					self.positionsForNodes[tile] = [NSValue valueWithCGPoint:pos];
					self.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(i, j)]] = tile;
					pos = CGPointMake(pos.x+tileWidth/2.0f, pos.y+tileWidth/2.0f);
					tile.position = pos;
					tile.xScale = tile.yScale = 0.0f;
					[self addChild:tile];
					[tile runAction:self.scaleToFullSize];
				}
			}
		}
	}
}

// Some helper methods:
-(CGPoint)getPositionFromX:(size_t)x andY: (size_t) y {
	SKShapeNode *container = self.tileContainers[(int)y][(int)(3-x)];
	return container.position;
}

-(void)analyzeTilesForSwipeDirection:(BoardSwipeGestureDirection) direction {
	/* Reminder - What to change:
	 
	 NSMutableDictionary *positionsForNodes;
	 NSMutableDictionary *nextPositionsForNodes;
	 NSMutableDictionary *theNewNodes;
	 NSMutableDictionary *theNewNodeForIndexes;
	 NSMutableSet *movingNodes;
	 NSMutableSet *removingNodes;
	 
	 */
	if (self.gamePlaying && [self dataCanBeSwippedToDirection:direction]) {
		self.theNewDirection = direction; // Set the direction for current last board
		self.gamePlaying = NO;
		int32_t score = self.score;
		self.theNewData = [self.data mutableCopy];
		self.theNewNodeForIndexes = [self.nodeForIndexes mutableCopy];
		self.nextPositionsForNodes = [self.positionsForNodes mutableCopy];
		
		if (direction == BoardSwipeGestureDirectionLeft) {
			for (int row = 0; row < 4; ++row) {
				NSMutableArray *rowArr = self.theNewData[row];
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
						score += newVal;
						rowArr[col2] = @(0);
						rowArr[col3] = @(0);
						/*_____________________________*/
						TileSKShapeNode *node1 = self.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col2)]];
						TileSKShapeNode *node2 = self.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col3)]];
						[self.movingNodes addObject:node2];
						if (col2 != col1) {[self.movingNodes addObject: node1];}
						[self.removingNodes addObject:node1];
						[self.removingNodes addObject:node2];
						/*_____________________________*/
						col2++;
						col3++;
					} else {
						newVal = [rowArr[col2] intValue];
						rowArr[col2] = @(0);
						col2 = col3++;
					}
					rowArr[col1++] = @(newVal);
				}
				while (col1 < 4 && col2 < 4) {
					int newVal = [rowArr[col2] intValue];
					if (newVal != 0 && [self.theNewData[row][col1] intValue] == 0) {
						rowArr[col1++] = @(newVal);
						rowArr[col2] = @(0);
					}
					col2++;
				}
			}
		} else if (direction == BoardSwipeGestureDirectionRight) {
			for (int row = 0; row < 4; ++row) {
				NSMutableArray *rowArr = self.theNewData[row];
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
						score += newVal;
						rowArr[col2] = @(0);
						rowArr[col3] = @(0);
						col2--;
						col3--;
					} else {
						newVal = [rowArr[col2] intValue];
						rowArr[col2] = @(0);
						col2 = col3--;
					}
					rowArr[col1--] = @(newVal);
				}
				while (col1 >= 0 && col2 >= 0) {
					int newVal = [rowArr[col2] intValue];
					if (newVal != 0 && [self.theNewData[row][col1] intValue] == 0) {
						rowArr[col1--] = @(newVal);
						rowArr[col2] = @(0);
					}
					col2--;
				}
			}
		} else if (direction == BoardSwipeGestureDirectionUp) {
			for (int col = 0; col < 4; ++col) {
				int row1 = 0;
				int row2 = 0;
				int row3 = 1;
				while (row1 < 4 && row2 < 4 && row3 < 4) {
					if ([self.theNewData[row2][col] intValue] == 0) {
						++row2;
						++row3;
						continue;
					}
					if ([self.theNewData[row3][col] intValue] == 0) {
						++row3;
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([self.theNewData[row2][col] intValue] == [self.theNewData[row3][col] intValue] && row2 != row3) {
						newVal = 2 * [self.theNewData[row2][col] intValue];
						score += newVal;
						self.theNewData[row2][col] = @(0);
						self.theNewData[row3][col] = @(0);
						row2++;
						row3++;
					} else {
						newVal = [self.theNewData[row2][col] intValue];
						self.theNewData[row2][col] = @(0);
						row2 = row3++;
					}
					self.theNewData[row1++][col] = @(newVal);
				}
				while (row1 < 4 && row2 < 4) {
					int newVal = [self.theNewData[row2][col] intValue];
					if (newVal != 0 && [self.theNewData[row1][col] intValue] == 0) {
						self.theNewData[row1++][col] = @(newVal);
						self.theNewData[row2][col] = @(0);
					}
					row2++;
				}
			}
		} else if (direction == BoardSwipeGestureDirectionDown) {
			for (int col = 0; col < 4; ++col) {
				int row1 = 3;
				int row2 = 3;
				int row3 = 2;
				while (row1 >= 0 && row2 >= 0 && row3 >= 0) {
					if ([self.theNewData[row2][col] intValue] == 0) {
						--row2;
						--row3;
						continue;
					}
					if ([self.theNewData[row3][col] intValue] == 0) {
						--row3;
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([self.theNewData[row2][col] intValue] == [self.theNewData[row3][col] intValue] && row2 != row3) {
						newVal = 2 * [self.theNewData[row2][col] intValue];
						score += newVal;
						self.theNewData[row2][col] = @(0);
						self.theNewData[row3][col] = @(0);
						row2--;
						row3--;
					} else {
						newVal = [self.theNewData[row2][col] intValue];
						self.theNewData[row2][col] = @(0);
						row2 = row3--;
					}
					self.theNewData[row1--][col] = @(newVal);
				}
				while (row1 >= 0 && row2 >= 0) {
					int newVal = [self.theNewData[row2][col] intValue];
					if (newVal != 0 && [self.theNewData[row1][col] intValue] == 0) {
						self.theNewData[row1--][col] = @(newVal);
						self.theNewData[row2][col] = @(0);
					}
					row2--;
				}
			}
		}
		
		// Generate a new random tile
		CGPoint p = [Board generateRandomAvailableCellPointFromCells2DArray: self.theNewData];
		NSNumber *val = @([Tile generateRandomInitTileValue]);
		self.theNewData[(int)p.y][(int)p.x] = val;
		
		// Check to see if the game is still playing and update onboard tiles.
		self.gamePlaying = [Board gameEndFrom2DArray:self.theNewData];
		self.board.swipeDirection = direction;
		// Update info for new board:
		self.board = [Board createBoardWithBoardData:self.theNewData
							gamePlaying:self.gamePlaying
								  score:score
						 swipeDirection:BoardSwipeGestureDirectionNone];
		
		// Add this board to history
		[self.history addBoardsObject:self.board];
		
		// Update Best score
		GameManager *gManager = [GameManager sharedGameManager];
		if (score > gManager.bestScore) {
			gManager.bestScore = score;
		}
		
		NSMutableDictionary *maxOccuredDictionary = [[self.gManager getMaxOccuredDictionary] mutableCopy];
		NSMutableDictionary *occurTimeDictionary = [NSMutableDictionary dictionary];
		for (int i = 0; i < maxTilePower; ++i) {
			occurTimeDictionary[@((NSInteger)pow(2.0f, i + 1))] = @(0);
		}
		
		for (size_t i = 0; i < 4; ++i) {
			for (size_t j = 0; j < 4; ++j) {
				if ([self.theNewData[i][j] intValue] != 0) {
					occurTimeDictionary[self.theNewData[i][j]] = @([occurTimeDictionary[self.theNewData[i][j]] intValue] + 1);
				}
			}
		}
		
		for (int i = 0; i < maxTilePower; ++i) {
			if ([occurTimeDictionary[@((NSInteger)pow(2.0f, i + 1))] intValue] > [maxOccuredDictionary[@((NSInteger)pow(2.0f, i + 1))] intValue]) {
				maxOccuredDictionary[@((NSInteger)pow(2.0f, i + 1))] = occurTimeDictionary[@((NSInteger)pow(2.0f, i + 1))];
			}
		}
		
		[self.gManager setMaxOccuredDictionary:[maxOccuredDictionary copy]];
	}
}

-(BOOL)dataCanBeSwippedToDirection:(BoardSwipeGestureDirection) direction {
	BOOL res = NO;
	if (direction == BoardSwipeGestureDirectionLeft) {
		for (size_t i = 0; i < 4; ++i) {
			if (res == NO) {
				NSArray *rowArr = self.data[i];
				int j = 3;
				// Loop to the first none zero element
				while (j >= 0 && [rowArr[j] intValue] == 0) {
					--j;
				}
				if (j < 0) {
					continue;
				} else {
					while (j >= 0) {
						// If there is a 0 between two numbers (e.g. @[2, 0, 4, 0]) or there are repeated adjacent numbers: (e.g. @[2, 4, 4, 0])
						if ([rowArr[j] intValue] == 0 || (j - 1 >= 0 && [rowArr[j] intValue] == [rowArr[j - 1] intValue])) {
							res = YES;
							break;
						} else {
							--j;
						}
					}
				}
				
			} else {
				break;
			}
		}
	} else if (direction == BoardSwipeGestureDirectionRight) {
		for (size_t i = 0; i < 4; ++i) {
			if (res == NO) {
				NSArray *rowArr = self.data[i];
				int j = 0;
				// Loop to the first none zero element
				while (j < 4 && [rowArr[j] intValue] == 0) {
					++j;
				}
				if (j > 3) {
					continue;
				} else {
					while (j < 4) {
						// If there is a 0 between two numbers (e.g. @[0, 4, 0, 2]) or there are repeated adjacent numbers: (e.g. @[0, 2, 4, 4])
						if ([rowArr[j] intValue] == 0 || (j + 1 < 4 && [rowArr[j] intValue] == [rowArr[j + 1] intValue])) {
							res = YES;
							break;
						} else {
							++j;
						}
					}
				}
				
			} else {
				break;
			}
		}
	} else if (direction == BoardSwipeGestureDirectionUp) {
		for (size_t j = 0; j < 4; ++j) {
			if (res == NO) {
				NSArray *colArr = @[self.data[0][j], self.data[1][j], self.data[2][j], self.data[3][j]];
				int j = 3;
				// Loop to the first none zero element
				while (j >= 0 && [colArr[j] intValue] == 0) {
					--j;
				}
				if (j < 0) {
					continue;
				} else {
					while (j >= 0) {
						// If there is a 0 between two numbers (e.g. @[2, 0, 4, 0]) or there are repeated adjacent numbers: (e.g. @[2, 4, 4, 0])
						if ([colArr[j] intValue] == 0 || (j - 1 >= 0 && [colArr[j] intValue] == [colArr[j - 1] intValue])) {
							res = YES;
							break;
						} else {
							--j;
						}
					}
				}
				
			} else {
				break;
			}
		}
	} else if (direction == BoardSwipeGestureDirectionDown) {
		for (size_t j = 0; j < 4; ++j) {
			if (res == NO) {
				NSArray *colArr = @[self.data[0][j], self.data[1][j], self.data[2][j], self.data[3][j]];
				int j = 0;
				// Loop to the first none zero element
				while (j < 4 && [colArr[j] intValue] == 0) {
					++j;
				}
				if (j > 3) {
					continue;
				} else {
					while (j < 4) {
						// If there is a 0 between two numbers (e.g. @[0, 4, 0, 2]) or there are repeated adjacent numbers: (e.g. @[0, 2, 4, 4])
						if ([colArr[j] intValue] == 0 || (j + 1 < 4 && [colArr[j] intValue] == [colArr[j + 1] intValue])) {
							res = YES;
							break;
						} else {
							++j;
						}
					}
				}
				
			} else {
				break;
			}
		}
	}
	return res;
}

@end

