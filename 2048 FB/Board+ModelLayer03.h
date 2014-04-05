//
//  Board+ModelLayer03.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import "Board+ModelLayer02.h"

#define DEBUG_BOARD

typedef enum BoardSwipeGestureDirection {
	BoardSwipeGestureDirectionNone = 0,
	BoardSwipeGestureDirectionLeft,
	BoardSwipeGestureDirectionRight,
	BoardSwipeGestureDirectionUp,
	BoardSwipeGestureDirectionDown
} BoardSwipeGestureDirection;

@interface Board (ModelLayer03)

+(Board *) initializeNewBoard;
+(CGPoint) getCGPointFromIndex: (NSInteger) val;
+(NSInteger) getIndexFromCGPoint: (CGPoint) point;

-(BOOL) swipedToDirection: (BoardSwipeGestureDirection) direction;

-(NSMutableArray *)getBoardDataArray;
-(BOOL)setBoardDataArray: (NSMutableArray *) array;
-(BOOL)setGameGoing: (BOOL) gameGoing;


+(NSArray *)availableCellsFromCellsArray: (NSArray *) arr;
+(NSInteger) generateRandomAvailableCellIndexFromCellsArray: (NSArray *) arr;
+(NSInteger) generateRandomInitTileValue;

-(NSArray *)availableCells;
-(NSInteger) generateRandomAvailableCellIndex;

#ifdef DEBUG_BOARD
-(void)printBoard;
#endif

@end
