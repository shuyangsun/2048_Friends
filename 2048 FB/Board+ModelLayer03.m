//
//  Board+ModelLayer03.m
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board+ModelLayer03.h"
#import "Tile+ModelLayer02.h"
#import "AppDelegate.h"

@implementation Board (ModelLayer03)

+(Board *) initializeNewBoard {
    NSMutableArray *boardData_1D = [NSMutableArray array];
	NSMutableArray *boardData_2D = [NSMutableArray array];
	for (int i = 0; i < 17; ++i) { // 17 elements, the last one is swipe gesture info
		boardData_2D[i] = @(0);
	}
	
	// Generate two random tiles with 2 or 4.
	for (int i = 0; i < 2; ++i) {
		NSInteger ind = [Board generateRandomAvailableCellIndexFromCellsArray:boardData_2D];
		NSInteger val = [Board generateRandomInitTileValue];
		boardData_2D[ind] = @(val);
	}
	[boardData_1D addObject:boardData_2D];
	
	Board *board = [Board createBoardInDatabaseWithUUID:[[NSUUID UUID] UUIDString]
											  boardData:boardData_1D
											gamePlaying:YES
												  score:0];
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate saveContext];
	
	return board;
}

// TODO
-(BOOL) swipedToDirection: (BoardSwipeGestureDirection) direction {
	if ([[self gameplaying] boolValue]) {
		NSMutableArray *arr2D = [self getBoardDataArray];
		NSMutableArray *arr = [arr2D lastObject];
		arr[[arr count] - 1] = @(direction); // Set the direction for current last board
		[arr2D addObject:[arr copy]]; // Create a new board state
		arr = [arr2D lastObject];
		arr[[arr count] - 1] = @(BoardSwipeGestureDirectionNone); // Set the direction for new board to none
		NSInteger addScore = 0;
		if (direction == BoardSwipeGestureDirectionLeft) {
			for (int row = 0; row < 4; ++row) {
				int col1 = 0;
				int col2 = 0;
				int col3 = 1;
				NSInteger newTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col1)];
				NSInteger formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col2)];
				NSInteger nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col3)];
				while (col3 <= 3) {
					if ([arr[formerTileInd] intValue] == 0) {
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row, ++col2)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, ++col3)];
						continue;
					}
					if ([arr[nextTileInd] intValue] == 0) {
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, ++col3)];
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([arr[formerTileInd] intValue] == [arr[nextTileInd] intValue]) {
						newVal = 2 * [arr[formerTileInd] intValue];
						addScore += newVal;
						arr[formerTileInd] = @(0);
						arr[nextTileInd] = @(0);
						col2 += 2;
						col3 += 2;
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col2)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col3)];
					} else {
						newVal = [arr[formerTileInd] intValue];
						arr[formerTileInd] = @(0);
						col2 = col3;
						formerTileInd = nextTileInd;
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, ++col3)];
					}
					arr[newTileInd] = @(newVal);
					newTileInd = [Board getIndexFromCGPoint:CGPointMake(row, ++col1)];
				}
				int newVal = [arr[formerTileInd] intValue];
				if (newVal != 0) {
					arr[newTileInd] = @(newVal);
					arr[formerTileInd] = @(0);
				}
			}
		} else if (direction == BoardSwipeGestureDirectionRight) {
			for (int row = 0; row < 4; ++row) {
				int col1 = 3;
				int col2 = 3;
				int col3 = 2;
				NSInteger newTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col1)];
				NSInteger formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col2)];
				NSInteger nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col3)];
				while (col3 >= 0) {
					if ([arr[formerTileInd] intValue] == 0) {
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row, --col2)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, --col3)];
						continue;
					}
					if ([arr[nextTileInd] intValue] == 0) {
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, --col3)];
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([arr[formerTileInd] intValue] == [arr[nextTileInd] intValue]) {
						newVal = 2 * [arr[formerTileInd] intValue];
						addScore += newVal;
						arr[formerTileInd] = @(0);
						arr[nextTileInd] = @(0);
						col2 -= 2;
						col3 -= 2;
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col2)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, col3)];
					} else {
						newVal = [arr[formerTileInd] intValue];
						arr[formerTileInd] = @(0);
						col2 = col3;
						formerTileInd = nextTileInd;
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row, --col3)];
					}
					arr[newTileInd] = @(newVal);
					newTileInd = [Board getIndexFromCGPoint:CGPointMake(row, --col1)];
				}
				int newVal = [arr[formerTileInd] intValue];
				if (newVal != 0) {
					arr[newTileInd] = @(newVal);
					arr[formerTileInd] = @(0);
				}
			}
		} else if (direction == BoardSwipeGestureDirectionUp) {
			for (int col = 0; col < 4; ++col) {
				int row1 = 0;
				int row2 = 0;
				int row3 = 1;
				NSInteger newTileInd = [Board getIndexFromCGPoint:CGPointMake(row1, col)];
				NSInteger formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row2, col)];
				NSInteger nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row3, col)];
				while (row3 <= 3) {
					if ([arr[formerTileInd] intValue] == 0) {
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(++row2, col)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(++row3, col)];
						continue;
					}
					if ([arr[nextTileInd] intValue] == 0) {
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(++row3, col)];
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([arr[formerTileInd] intValue] == [arr[nextTileInd] intValue]) {
						newVal = 2 * [arr[formerTileInd] intValue];
						addScore += newVal;
						arr[formerTileInd] = @(0);
						arr[nextTileInd] = @(0);
						row2 += 2;
						row3 += 2;
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row2, col)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row3, col)];
					} else {
						newVal = [arr[formerTileInd] intValue];
						arr[formerTileInd] = @(0);
						row2 = row3;
						formerTileInd = nextTileInd;
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(++row3, col)];
					}
					arr[newTileInd] = @(newVal);
					newTileInd = [Board getIndexFromCGPoint:CGPointMake(++row1, col)];
				}
				int newVal = [arr[formerTileInd] intValue];
				if (newVal != 0) {
					arr[newTileInd] = @(newVal);
					arr[formerTileInd] = @(0);
				}
			}
		} else if (direction == BoardSwipeGestureDirectionUp) {
			for (int col = 0; col < 4; ++col) {
				int row1 = 3;
				int row2 = 3;
				int row3 = 2;
				NSInteger newTileInd = [Board getIndexFromCGPoint:CGPointMake(row1, col)];
				NSInteger formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row2, col)];
				NSInteger nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row3, col)];
				while (row3 >= 0) {
					if ([arr[formerTileInd] intValue] == 0) {
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(--row2, col)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(--row3, col)];
						continue;
					}
					if ([arr[nextTileInd] intValue] == 0) {
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(--row3, col)];
						continue;
					}
					// If both formerTileInd and nextTileInd are not zero, the following code get executed.
					int newVal = 0;
					if ([arr[formerTileInd] intValue] == [arr[nextTileInd] intValue]) {
						newVal = 2 * [arr[formerTileInd] intValue];
						addScore += newVal;
						arr[formerTileInd] = @(0);
						arr[nextTileInd] = @(0);
						row2 -= 2;
						row3 -= 2;
						formerTileInd = [Board getIndexFromCGPoint:CGPointMake(row2, col)];
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(row3, col)];
					} else {
						newVal = [arr[formerTileInd] intValue];
						arr[formerTileInd] = @(0);
						row2 = row3;
						formerTileInd = nextTileInd;
						nextTileInd = [Board getIndexFromCGPoint:CGPointMake(--row3, col)];
					}
					arr[newTileInd] = @(newVal);
					newTileInd = [Board getIndexFromCGPoint:CGPointMake(--row1, col)];
				}
				int newVal = [arr[formerTileInd] intValue];
				if (newVal != 0) {
					arr[newTileInd] = @(newVal);
					arr[formerTileInd] = @(0);
				}
			}
		}
		
		// Check to see if the game is still playing and update onboard tiles.
		self.gameplaying = @(NO);
		for (int i = 0; i < 16; ++i) {
			[self addOnBoardTilesObject:[Tile searchTileInDatabaseWithValue:[arr[i] integerValue]]];
			if (arr[i] == 0) {
				self.gameplaying = @(YES);
			}
		}
		
		// Update Score:
		NSInteger score = [self getIntegerScore];
		[self setIntegerScore:score + addScore];
		
		return [self setBoardDataArray:arr2D];
	}
	return NO;
}

+(CGPoint)getCGPointFromIndex: (NSInteger) val {
	CGPoint res = CGPointMake(-1, -1);
	if (val >= 0) {
		res = CGPointMake(val%4, val/4);
	}
	return res;
}

+(NSInteger) getIndexFromCGPoint: (CGPoint) point {
	NSInteger res = -1;
	if (point.x >= 0) {
		res = 4 * point.x + point.y;
	}
	return res;
}


+(NSArray *)availableCellsFromCellsArray: (NSArray *) arr {
	NSMutableArray *mutableArr = [NSMutableArray array];
	for (int i = 0; i < 16; ++i) {
		if ([arr[i] intValue] == 0) {
			[mutableArr addObject:@(i)];
		}
	}
	return mutableArr;
}

+(NSInteger) generateRandomAvailableCellIndexFromCellsArray: (NSArray *) arr {
	NSInteger res = -1;
	if ([arr count]) {
		int randomInd = arc4random()%[arr count];
		res = [arr[randomInd] intValue];
	}
	return res;
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

-(BOOL)setGameGoing: (BOOL) gameGoing {
	self.gameplaying = @(gameGoing);
	
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return [appDelegate saveContext];
}

// Returns an array of numbers (0 to 15)
-(NSArray *)availableCells {
	NSArray *boardDataArr = [NSKeyedUnarchiver unarchiveObjectWithData:self.boardData];
	NSArray *boardCurrentDataArr = [boardDataArr lastObject];
	return [Board availableCellsFromCellsArray:boardCurrentDataArr];
}

-(NSInteger) generateRandomAvailableCellIndex {
	NSArray *arr = [self availableCells];
	return [Board generateRandomAvailableCellIndexFromCellsArray:arr];
}

+(NSInteger) generateRandomInitTileValue {
	return arc4random()%100 < 90 ? 2:4; // 90% chance get 2, 10% get 4
}

#ifdef DEBUG_BOARD

-(void)printBoard {
	printf("*********************************************\n");
	printf("\n");
	NSMutableArray *mutableArr = [self getBoardDataArray];
	for (NSMutableArray *arr in mutableArr) {
		for (int row = 0; row < 4; ++row) {
			for (int column = 0; column < 4; ++column) {
				NSInteger ind = [Board getIndexFromCGPoint:CGPointMake(row, 0)];
				printf("%d ", [arr[ind] intValue]);
			}
			printf("\n");
		}
		printf("Swip Direction: %d", [[arr lastObject] intValue]);
		printf("\n\n");
	}
	printf("\n");
	printf("*********************************************\n");
}

#endif

@end
