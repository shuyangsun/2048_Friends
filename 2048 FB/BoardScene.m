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

#pragma mark - Class Initialization Methods

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
	self.scaleToFullSizeAction = [SKAction group:@[[SKAction scaleTo:1.0f duration:kAnimationDuration_TileContainerPopup],
												   [SKAction moveBy:CGVectorMake(-self.theme.tileWidth/2.0f, -self.theme.tileWidth/2.0f) duration:kAnimationDuration_TileContainerPopup]]];
	CGFloat scaleFactor = 1+((self.size.width - 4 * self.theme.tileWidth)/5.0f)/self.theme.tileWidth;
	self.popUpNewTileAction = [SKAction sequence:@[[SKAction group:@[[SKAction scaleTo:scaleFactor duration:kAnimationDuration_TileContainerPopup], [SKAction moveBy:CGVectorMake(-self.theme.tileWidth*((scaleFactor - 1)/2), -self.theme.tileWidth*((scaleFactor - 1)/2)) duration:kAnimationDuration_TileContainerPopup/2.0f], [SKAction fadeInWithDuration:kAnimationDuration_TileContainerPopup]]],
												   [SKAction group:@[[SKAction scaleTo:1.0f duration:kAnimationDuration_TileContainerPopup], [SKAction moveBy:CGVectorMake(self.theme.tileWidth*((scaleFactor - 1)/2), self.theme.tileWidth*((scaleFactor - 1)/2)) duration:kAnimationDuration_TileContainerPopup]]]]];
}

#pragma mark - Game Initialization Methods

-(void)initializePropertyLists{
	self.positionsForNodes = [NSMutableDictionary dictionary];
	self.positionForNewRandomTile = [NSMutableDictionary dictionary];
	self.positionForNewNodes = [NSMutableDictionary dictionary];
	self.indexesForNewNodes = [NSMutableDictionary dictionary];
	self.nodeForIndexes = [NSMutableDictionary dictionary];
	self.nextNodeForIndexes = [NSMutableDictionary dictionary];
	self.nextPositionsForNodes = [NSMutableDictionary dictionary];
	self.indexForNewRandomTile = [NSMutableDictionary dictionary];
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
	for (size_t row = 0; row < 4; ++row) {
		for (size_t col = 0; col < 4; col++) {
			SKShapeNode* tileContainer = [SKShapeNode node];
			[tileContainer setPath:CGPathCreateWithRoundedRect(CGRectMake(0,
																		  0,
																		  tileWidth,
																		  tileWidth),
															   self.theme.tileCornerRadius,
															   self.theme.tileCornerRadius, nil)];
			tileContainer.strokeColor = tileContainer.fillColor = self.theme.tileContainerColor;
			CGPoint pos = CGPointMake((col + 1) * edgeWidth + (col + 0.5) * tileWidth, (row + 1) * edgeWidth + (row + 0.5) * tileWidth);
			tileContainer.position = pos;
			tileContainer.xScale = tileContainer.yScale = 0.0f;
			[self addChild:tileContainer];
			self.tileContainers[row][col] = tileContainer;
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
		// Maybe we can use recursion to make it prettier (recursive call completion block in another function), but I like this art.
		int a1 = arr1[0];
		int a2 = arr1[1];
		int a3 = arr1[2];
		int a4 = arr1[3];
		int b1 = arr2[0];
		int b2 = arr2[1];
		int b3 = arr2[2];
		int b4 = arr2[3];
		// Please don't remove any awesome comment in this method, that will probably result a compile error. ;)
		[self.tileContainers[a1][b2] runAction:self.scaleToFullSizeAction completion:^{/*                    Painting while Coding                        */
			[self.tileContainers[a2][b3] runAction:self.scaleToFullSizeAction completion:^{/* (The man will probably hit this line of comment.)           */
				[self.tileContainers[a1][b1] runAction:self.scaleToFullSizeAction completion:^{/*                                                         */
					[self.tileContainers[a4][b3] runAction:self.scaleToFullSizeAction completion:^{/*                                                     */
						[self.tileContainers[a2][b2] runAction:self.scaleToFullSizeAction completion:^{/*                                                 */
							[self.tileContainers[a3][b3] runAction:self.scaleToFullSizeAction completion:^{/*                                             */
								[self.tileContainers[a3][b4] runAction:self.scaleToFullSizeAction completion:^{/*                                         */
									[self.tileContainers[a2][b1] runAction:self.scaleToFullSizeAction completion:^{/*                                     */
										[self.tileContainers[a3][b1] runAction:self.scaleToFullSizeAction completion:^{/*                                 */
											[self.tileContainers[a2][b4] runAction:self.scaleToFullSizeAction completion:^{/*                             */
												[self.tileContainers[a4][b2] runAction:self.scaleToFullSizeAction completion:^{/*                         */
													[self.tileContainers[a3][b2] runAction:self.scaleToFullSizeAction completion:^{/*         O           */
														[self.tileContainers[a4][b1] runAction:self.scaleToFullSizeAction completion:^{/*    -|-          */
															[self.tileContainers[a4][b4] runAction:self.scaleToFullSizeAction completion:^{/* /\          */
																[self.tileContainers[a1][b3] runAction:self.scaleToFullSizeAction completion:^{/*         */
																	[self.tileContainers[a1][b4] runAction:self.scaleToFullSizeAction completion:^{/*     */
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
		for (size_t row = 0; row < 4; ++row) {
			for (size_t col = 0; col < 4; col++) {
				if ([self.data[row][col] intValue] != 0) { // If it's not zero
					NSNumber *value = self.data[row][col];
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
					CGPoint pos = [self getPositionFromRow:row andCol:col];
					self.positionsForNodes[[NSValue valueWithNonretainedObject:tile]] = [NSValue valueWithCGPoint:pos];
					self.nodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row, col)]] = tile;
					pos = CGPointMake(pos.x+tileWidth/2.0f, pos.y+tileWidth/2.0f);
					tile.position = pos;
					tile.xScale = tile.yScale = 0.0f;
					[self addChild:tile];
					[tile runAction:self.scaleToFullSizeAction];
				}
			}
		}
	}
}

#pragma mark - Analysis Algorithms

-(void)analyzeTilesForSwipeDirection:(BoardSwipeGestureDirection) direction generateNewTile:(BOOL) generateNewTile completion:(void (^)(void))completion {
	
	if (self.gamePlaying && [self dataCanBeSwippedToDirection:direction]) {
		self.nextDirection = direction; // Set the direction for current last board
		self.gamePlaying = NO;
		self.nextData = [self.data mutableCopy];
		self.nextNodeForIndexes = [self.nodeForIndexes mutableCopy];
		self.nextPositionsForNodes = [self.positionsForNodes mutableCopy];
		
		if (direction == BoardSwipeGestureDirectionLeft) {
			for (int row = 0; row < 4; ++row) {
				NSMutableArray *rowArr = self.nextData[row];
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
						self.score += newVal;
						rowArr[col2] = @(0);
						rowArr[col3] = @(0);
						// Deals merging tile:
						[self processNewMergedTilesWithNewVal:newVal Row1:row Row2:row Row3:row Col1:col1 Col2:col2 Col3:col3];
						col2++;
						col3++;
					} else {
						newVal = [rowArr[col2] intValue];
						rowArr[col2] = @(0);
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row Row2:row Col1:col1 Col2:col2];
						col2 = col3++;
					}
					rowArr[col1++] = @(newVal);
				}
				while (col1 < 4 && col2 < 4) {
					int newVal = [rowArr[col2] intValue];
					if (newVal != 0 && [self.nextData[row][col1] intValue] == 0) {
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row Row2:row Col1:col1 Col2:col2];
						rowArr[col1++] = @(newVal);
						rowArr[col2] = @(0);
					}
					col2++;
				}
			}
		} else if (direction == BoardSwipeGestureDirectionRight) {
			for (int row = 0; row < 4; ++row) {
				NSMutableArray *rowArr = self.nextData[row];
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
						self.score += newVal;
						rowArr[col2] = @(0);
						rowArr[col3] = @(0);
						// Deals merging tile:
						[self processNewMergedTilesWithNewVal:newVal Row1:row Row2:row Row3:row Col1:col1 Col2:col2 Col3:col3];
						col2--;
						col3--;
					} else {
						newVal = [rowArr[col2] intValue];
						rowArr[col2] = @(0);
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row Row2:row Col1:col1 Col2:col2];
						col2 = col3--;
					}
					rowArr[col1--] = @(newVal);
				}
				while (col1 >= 0 && col2 >= 0) {
					int newVal = [rowArr[col2] intValue];
					if (newVal != 0 && [self.nextData[row][col1] intValue] == 0) {
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row Row2:row Col1:col1 Col2:col2];
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
					if ([self.nextData[row2][col] intValue] == 0) {
						++row2;
						++row3;
						continue;
					}
					if ([self.nextData[row3][col] intValue] == 0) {
						++row3;
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([self.nextData[row2][col] intValue] == [self.nextData[row3][col] intValue] && row2 != row3) {
						newVal = 2 * [self.nextData[row2][col] intValue];
						self.score += newVal;
						self.nextData[row2][col] = @(0);
						self.nextData[row3][col] = @(0);
						// Deals merging tile:
						[self processNewMergedTilesWithNewVal:newVal Row1:row1 Row2:row2 Row3:row3 Col1:col Col2:col Col3:col];
						row2++;
						row3++;
					} else {
						newVal = [self.nextData[row2][col] intValue];
						self.nextData[row2][col] = @(0);
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row1 Row2:row2 Col1:col Col2:col];
						row2 = row3++;
					}
					self.nextData[row1++][col] = @(newVal);
				}
				while (row1 < 4 && row2 < 4) {
					int newVal = [self.nextData[row2][col] intValue];
					if (newVal != 0 && [self.nextData[row1][col] intValue] == 0) {
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row1 Row2:row2 Col1:col Col2:col];
						self.nextData[row1++][col] = @(newVal);
						self.nextData[row2][col] = @(0);
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
					if ([self.nextData[row2][col] intValue] == 0) {
						--row2;
						--row3;
						continue;
					}
					if ([self.nextData[row3][col] intValue] == 0) {
						--row3;
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([self.nextData[row2][col] intValue] == [self.nextData[row3][col] intValue] && row2 != row3) {
						newVal = 2 * [self.nextData[row2][col] intValue];
						self.score += newVal;
						self.nextData[row2][col] = @(0);
						self.nextData[row3][col] = @(0);
						// Deals merging tile:
						[self processNewMergedTilesWithNewVal:newVal Row1:row1 Row2:row2 Row3:row3 Col1:col Col2:col Col3:col];
						row2--;
						row3--;
					} else {
						newVal = [self.nextData[row2][col] intValue];
						self.nextData[row2][col] = @(0);
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row1 Row2:row2 Col1:col Col2:col];
						row2 = row3--;
					}
					self.nextData[row1--][col] = @(newVal);
				}
				while (row1 >= 0 && row2 >= 0) {
					int newVal = [self.nextData[row2][col] intValue];
					if (newVal != 0 && [self.nextData[row1][col] intValue] == 0) {
						// Deals moving tile:
						[self processMoveOneTileWithRow1:row1 Row2:row2 Col1:col Col2:col];
						self.nextData[row1--][col] = @(newVal);
						self.nextData[row2][col] = @(0);
					}
					row2--;
				}
			}
		}
		
		if (generateNewTile) {
			// Generate a new random tile
			CGPoint p = [Board generateRandomAvailableCellPointFromCells2DArray: self.nextData];
			NSNumber *val = @([Tile generateRandomInitTileValue]);
			self.nextData[(int)p.y][(int)p.x] = val;
		}
		
		// Check to see if the game is still playing and update onboard tiles.
		self.gamePlaying = [Board gameEndFrom2DArray:self.nextData];
		self.board.swipeDirection = direction;
		// Update info for new board:
		self.board = [Board createBoardWithBoardData:self.nextData
							gamePlaying:self.gamePlaying
								  score:self.score
						 swipeDirection:BoardSwipeGestureDirectionNone];
		
		// Add this board to history
		[self.history addBoardsObject:self.board];
		
		// Update Best score
		GameManager *gManager = [GameManager sharedGameManager];
		if (self.score > gManager.bestScore) {
			gManager.bestScore = self.score;
		}
		
		NSMutableDictionary *maxOccuredDictionary = [[self.gManager getMaxOccuredDictionary] mutableCopy];
		NSMutableDictionary *occurTimeDictionary = [NSMutableDictionary dictionary];
		for (int i = 0; i < maxTilePower; ++i) {
			occurTimeDictionary[@((NSInteger)pow(2.0f, i + 1))] = @(0);
		}
		
		for (size_t i = 0; i < 4; ++i) {
			for (size_t j = 0; j < 4; ++j) {
				if ([self.nextData[i][j] intValue] != 0) {
					occurTimeDictionary[self.nextData[i][j]] = @([occurTimeDictionary[self.nextData[i][j]] intValue] + 1);
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
	// Run the completion block passed in
	if (completion) {
		completion();
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

-(void)analyzeTilesForSwipeDirection:(BoardSwipeGestureDirection) direction
						  completion:(void (^)(void))completion {
	[self analyzeTilesForSwipeDirection:direction generateNewTile:YES completion:completion];
}

#pragma mark - Helper Methods

-(CGPoint)getPositionFromRow:(size_t)row andCol: (size_t)col {
	SKShapeNode *container = self.tileContainers[(int)(3 - row)][(int)col];
	return container.position;
}

-(void)processMoveOneTileWithRow1:(int)row1 Row2:(int)row2 Col1:(int)col1 Col2:(int)col2 {
	if (col2 != col1) {
		TileSKShapeNode *node = self.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row2, col2)]];
		[self.nextNodeForIndexes removeObjectForKey:[NSValue valueWithCGPoint:CGPointMake(row2, col2)]];
		self.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row1, col1)]] = node;
		self.nextPositionsForNodes[[NSValue valueWithNonretainedObject:node]] = [NSValue valueWithCGPoint:[self getPositionFromRow:row1 andCol:col1]];
		[self.movingNodes addObject:node];
	}
}

-(void)processNewMergedTilesWithNewVal:(int32_t)newVal Row1:(int)row1 Row2:(int)row2 Row3:(int)row3 Col1:(int)col1 Col2:(int)col2 Col3:(int)col3 {
	CGFloat tileWidth = self.theme.tileWidth;
	TileSKShapeNode *node1 = self.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row2, col2)]];
	TileSKShapeNode *node2 = self.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row3, col3)]];
	
	[self.nextNodeForIndexes removeObjectForKey:[NSValue valueWithCGPoint:CGPointMake(row2, col2)]];
	[self.nextNodeForIndexes removeObjectForKey:[NSValue valueWithCGPoint:CGPointMake(row3, col3)]];
	
	/* Create new tile */
	TileSKShapeNode *node = [TileSKShapeNode node];
	[node setPath:CGPathCreateWithRoundedRect(CGRectMake(0,
														 0,
														 tileWidth,
														 tileWidth),
											  self.theme.tileCornerRadius,
											  self.theme.tileCornerRadius, nil)];
	node.strokeColor = node.fillColor = self.theme.tileColors[@(newVal)];
	[node setValue:newVal
			  text:[NSString stringWithFormat:@"%d", newVal]
		 textColor:(newVal <= 4 ? self.theme.tileTextColor:[UIColor whiteColor])
			  type:TileTypeNumber];
	CGPoint pos = [self getPositionFromRow:row1 andCol:col1];
	self.indexesForNewNodes[[NSValue valueWithNonretainedObject:node]] = [NSValue valueWithCGPoint:CGPointMake(row1, col1)];
	self.positionForNewNodes[[NSValue valueWithNonretainedObject:node]] = [NSValue valueWithCGPoint:pos];
	self.nextNodeForIndexes[[NSValue valueWithCGPoint:CGPointMake(row1, col1)]] = node;
	node.alpha = 0.0f; // Not visible for now
	[self addChild:node];
	/* Done creating new tile */
	
	self.nextPositionsForNodes[[NSValue valueWithNonretainedObject:node1]] = [NSValue valueWithCGPoint:[self getPositionFromRow:row1 andCol:col1]];
	self.nextPositionsForNodes[[NSValue valueWithNonretainedObject:node2]] = [NSValue valueWithCGPoint:[self getPositionFromRow:row1 andCol:col1]];
	
	if (col2 != col1) {[self.movingNodes addObject: node1];}
	[self.movingNodes addObject:node2];
	
	[self.removingNodes addObject:node1];
	[self.removingNodes addObject:node2];
}

@end

