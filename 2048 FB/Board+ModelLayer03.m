//
//  Board+ModelLayer03.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer03.h"
#import "History+ModelLayer03.h"
#import "AppDelegate.h"

@implementation Board (ModelLayer03)

+(Board *) initializeNewBoard {
	Board *board = nil;
	NSMutableArray *boardData = [NSMutableArray array];
	for (size_t i = 0; i < 4; ++i) { // 17 elements, the last one is swipe gesture info
		[boardData addObject:[NSMutableArray array] ];
		for (size_t j = 0; j < 4; ++j) {
			[boardData[i] addObject:@(0)];
		}
	}
	
	// Generate two random tiles with 2 or 4.
	CGPoint p = CGPointMake(-1.0f, -1.0f);
	for (int i = 0; i < 2; ++i) {
		CGPoint temp = [Board generateRandomAvailableCellPointFromCells2DArray:boardData];
		if (!CGPointEqualToPoint(p, temp)) {
			p = temp;
		} else {
			--i;
			continue;
		}
		int16_t val = [Tile generateRandomInitTileValue];
		boardData[(int)p.x][(int)p.y] = @(val);
	}
	[boardData addObject:boardData];
	
	board = [Board createBoardWithBoardData:boardData
									   gamePlaying:YES
											 score:0
									swipeDirection:BoardSwipeGestureDirectionNone];
	[[History latestHistory] addBoardsObject:board];
	return board;
}

// TODO
-(Board *) swipedToDirection: (BoardSwipeGestureDirection) direction {
	Board *nextBoard = nil;
	if (self.gameplaying) {
		self.swipeDirection = direction; // Set the direction for current last board
		// Data for the next board:
		NSMutableArray *arr = [[self getBoardDataArray] mutableCopy];
		BOOL gamePLaying = NO;
		int32_t score = self.score;
		
		if (direction == BoardSwipeGestureDirectionLeft) {
			for (int row = 0; row < 4; ++row) {
				NSMutableArray *rowArr = arr[row];
				int col1 = 0;
				int col2 = 0;
				int col3 = 1;
				
				while (col3 <= 3) {
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
					if ([rowArr[col2] intValue] == [rowArr[col3] intValue]) {
						newVal = 2 * [rowArr[col2] intValue];
						score += newVal;
						rowArr[col2] = @(0);
						rowArr[col3] = @(0);
						col2 += 2;
						col3 += 2;
					} else {
						newVal = [rowArr[col2] intValue];
						rowArr[col2] = @(0);
						col2 = col3++;
					}
					rowArr[col1++] = @(newVal);
				}
				int newVal = [rowArr[col2] intValue];
				if (newVal != 0) {
					rowArr[col1] = @(newVal);
					rowArr[col2] = @(0);
				}
			}
		} else if (direction == BoardSwipeGestureDirectionRight) {
			for (int row = 0; row < 4; ++row) {
				NSMutableArray *rowArr = arr[row];
				int col1 = 3;
				int col2 = 3;
				int col3 = 2;
				while (col3 >= 0) {
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
					if ([rowArr[col2] intValue] == [rowArr[col3] intValue]) {
						newVal = 2 * [rowArr[col2] intValue];
						score += newVal;
						rowArr[col2] = @(0);
						rowArr[col3] = @(0);
						col2 -= 2;
						col3 -= 2;
					} else {
						newVal = [rowArr[col2] intValue];
						rowArr[col2] = @(0);
						col2 = col3--;
					}
					rowArr[col1--] = @(newVal);
				}
				int newVal = [rowArr[col2] intValue];
				if (newVal != 0) {
					arr[col3] = @(newVal);
					arr[col2] = @(0);
				}
			}
		} else if (direction == BoardSwipeGestureDirectionUp) {
			for (int col = 0; col < 4; ++col) {
				int row1 = 0;
				int row2 = 0;
				int row3 = 1;
				while (row3 <= 3) {
					if ([arr[row2][col] intValue] == 0) {
						++row2;
						++row3;
						continue;
					}
					if ([arr[row3][col] intValue] == 0) {
						++row3;
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([arr[row2][col] intValue] == [arr[row3][col] intValue]) {
						newVal = 2 * [arr[row2][col] intValue];
						score += newVal;
						arr[row2][col] = @(0);
						arr[row3][col] = @(0);
						row2 += 2;
						row3 += 2;
					} else {
						newVal = [arr[row2][col] intValue];
						arr[row2][col] = @(0);
						row2 = row3++;
					}
					arr[row1++][col] = @(newVal);
				}
				int newVal = [arr[row2][col] intValue];
				if (newVal != 0) {
					arr[row1][col] = @(newVal);
					arr[row2][col] = @(0);
				}
			}
		} else if (direction == BoardSwipeGestureDirectionUp) {
			for (int col = 0; col < 4; ++col) {
				int row1 = 3;
				int row2 = 3;
				int row3 = 2;
				while (row3 >= 0) {
					if ([arr[row2][col] intValue] == 0) {
						--row2;
						--row3;
						continue;
					}
					if ([arr[row3][col] intValue] == 0) {
						--row3;
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([arr[row2][col] intValue] == [arr[row3][col] intValue]) {
						newVal = 2 * [arr[row2][col] intValue];
						score += newVal;
						arr[row2][col] = @(0);
						arr[row3][col] = @(0);
						row2 -= 2;
						row3 -= 2;
					} else {
						newVal = [arr[row2][col] intValue];
						arr[row2][col] = @(0);
						row2 = row3--;
					}
					arr[row1--][col] = @(newVal);
				}
				int newVal = [arr[row2][col] intValue];
				if (newVal != 0) {
					arr[row1][col] = @(newVal);
					arr[row2][col] = @(0);
				}
			}
		}
		
		// Generate a new random tile
		CGPoint p = [Board generateRandomAvailableCellPointFromCells2DArray: arr];
		arr[(int)p.x][(int)p.y] = @([Tile generateRandomInitTileValue]);
		
		
		// Check to see if the game is still playing and update onboard tiles.
		gamePLaying = NO;
		for (int i = 0; i < 4; ++i) {
			if (gamePLaying) {
				break;
			}
			for (int j = 0; j < 4; ++j) {
				if ([arr[i][j] integerValue] == 0) {
					self.gameplaying = @(YES);
					break;
				}
			}
		}
		
		// Update info for new board:
		nextBoard = [Board createBoardWithBoardData:arr
											   gamePlaying:gamePLaying
													 score:score
											swipeDirection:BoardSwipeGestureDirectionNone];
		
		[[History latestHistory] addBoardsObject:nextBoard];
		
	}
	return nextBoard;
}

-(NSMutableArray *)getBoardDataArray {
	NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:self.boardData];
	return array;
}

-(BOOL)setBoardDataArray: (NSMutableArray *) array {
	NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:array];
	self.boardData = arrayData;
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}

// Return all available cells with CGPoint, take the 2D array as data source
+(NSArray *)availableCellPointsFromCells2DArray: (NSArray *) arr {
	NSMutableArray *mutableArr = [NSMutableArray array];
	for (int row = 0; row < 4; ++row) {
		for (int col = 0; col < 4; ++col) {
			if ([arr[row][col] intValue] == 0) {
				[mutableArr addObject:[NSValue valueWithCGPoint:CGPointMake(row, col)]];
			}
		}
	}
	return mutableArr;
}

-(NSArray *)availableCellPoints {
	NSArray *arr = [self getBoardDataArray];
	return [Board availableCellPointsFromCells2DArray:arr];
}

/* Helper Methods:  */

// Generate a random available cell from cell data array, take the 2D array as data source
+(CGPoint) generateRandomAvailableCellPointFromCells2DArray: (NSArray *) arr {
	CGPoint res = CGPointMake(-1.0f, -1.0f);
	NSArray *arr2 = [self availableCellPointsFromCells2DArray:arr];
	if ([arr count]) {
		int ind = arc4random()%[arr2 count];
		res = [arr2[ind] CGPointValue];
	}
	return res;
}

-(CGPoint) generateRandomAvailableCellPoint {
	NSArray *arr = [self getBoardDataArray];
	return [Board generateRandomAvailableCellPointFromCells2DArray:arr];
}

#ifdef DEBUG_BOARD
-(void)printBoard {
	printf("***************\n");
	NSMutableArray *mutableArr = [self getBoardDataArray];
	for (int row = 0; row < 4; ++row) {
		for (int col = 0; col < 4; ++col) {
			printf("%d ", [mutableArr[row][col] intValue]);
		}
		printf("\n");
	}
	printf("direction: %d\n", self.swipeDirection);
	printf("score: %d\n", self.score);
	printf("gamePlaying: %d\n", self.gameplaying);
	printf("***************\n");
}

#endif

@end
