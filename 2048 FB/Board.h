//
//  Board.h
//  2048 FB
//
//  Created by Shuyang Sun on 4/4/14.
//  Copyright (c) 2014 Shuyang Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tile;

@interface Board : NSManagedObject

/** This boardData is one of the most important part of Board object.
 *  It's a 3D array, holding all the game playing informations about boardData.
 *  The first demension is an array of all previous status of this board game.
 *  (Every time the user finish a swipe, there is a new data added into the array, this implementation is for the "History" feature)
 *  The second demension contains 5 elements, which is 4(rows) + 1(gesture happened on this board state)
 *  The third demension contains 4 elements, which are the 4 columns.
 *  Histories@[Rows@[Columns@[] + gestureHappened]]
 */
@property (nonatomic, retain) NSData * boardData;
@property (nonatomic, retain) NSNumber * gameplaying;
@property (nonatomic, retain) NSDecimalNumber * score;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * createDate; // The only property that is not in the dictionary
@property (nonatomic, retain) NSSet *onBoardTiles;
@end

@interface Board (CoreDataGeneratedAccessors)

- (void)addOnBoardTilesObject:(Tile *)value;
- (void)removeOnBoardTilesObject:(Tile *)value;
- (void)addOnBoardTiles:(NSSet *)values;
- (void)removeOnBoardTiles:(NSSet *)values;

@end
